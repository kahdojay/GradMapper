class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"
  # TODO: create after_create callback to popluate valid_linked_in?

  def self.scrape_li
    Graduate.order('name').each do |graduate|
      next if graduate.linked_in.nil? || graduate.linked_in.empty?
      graduate.get_li_details(graduate.linked_in) if (graduate.linked_in.include?("linkedin") || graduate.linked_in.include?("lnkd"))
    end
  end

  def self.rescrape_locations
    Graduate.where(lat:"unknown").each do |graduate|
      next if graduate.linked_in.nil? || graduate.linked_in.empty?
      graduate.get_li_details(graduate.linked_in) if (graduate.linked_in.include?("linkedin") || graduate.linked_in.include?("lnkd"))
    end
  end

  def get_li_details(link)
    profile = Linkedin::Profile.get_profile(link)
    if profile.nil? || !profile.location || !profile.current_companies
      p "Bad linked-in call"
      sleep 1
      return "nil"
    end
    p "Seeding #{name}'s LinkedIn details"
    profile.picture ? update(img_url: profile.picture) : update(img_url: "app/assets/images/devbootcamplogo.jpeg")
    if !profile.current_companies[0] && profile.location && profile.country
      update(city: profile.location, state_or_country: profile.country)
      if profile.location == profile.country
        search = Geocoder.search("#{city.gsub(/Greater|Area|City/,'').strip} City")
      else
        search = Geocoder.search("#{city.gsub(/Greater|Area|City/,'').strip} City, #{state_or_country}")
      end
    end
    if profile.current_companies[0] && profile.location && profile.country
      update(company: profile.current_companies[0][:company], city: profile.location, state_or_country: profile.country)
      if profile.location == profile.country
        search = Geocoder.search("#{company} in #{city.gsub(/Greater|Area|City/,'').strip} City")
      else
        search = Geocoder.search("#{company} in #{city.gsub(/Greater|Area|City/,'').strip} City, #{state_or_country}")
      end
    end
    if search && search[0]
      # TODO: bug test random_modifier
      random_modifier = (1+rand/2)/100 + 1
      update(lat: search[0].latitude * random_modifier, long: search[0].longitude * random_modifier)
    end
  end
end
