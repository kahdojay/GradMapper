class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"
  # TODO: create after_create callback to popluate valid_linked_in?
  after_create :check_valid_li

  def self.scrape_li
    Graduate.order('name').each do |graduate|
      graduate.get_li_details(graduate.linked_in) if graduate.valid_linked_in?
    end
  end

  def self.rescrape_locations
    Graduate.where(lat:"unknown", valid_linked_in?: false).each do |graduate|
      graduate.get_li_details(graduate.linked_in) if graduate.valid_linked_in? == true
    end
  end

  def check_valid_li
    if linked_in && (linked_in.include?("linkedin") || linked_in.include?("lnkd"))
      update(valid_linked_in?: true)
    end
  end

  def get_li_details(link)
    profile = Linkedin::Profile.get_profile(link)
    if profile.nil? || !profile.location
      p "Error"
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
      random_modifier = ((1+rand/2)/10000 + 1)
      update(lat: search[0].latitude * random_modifier, long: search[0].longitude * random_modifier)
    end
  end
end