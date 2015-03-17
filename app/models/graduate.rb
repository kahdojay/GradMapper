class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"

  def self.scrape_li
    Graduate.order('name').each do |graduate|
      next if graduate.linked_in.nil? || graduate.linked_in.empty?
      graduate.get_li_details(graduate.linked_in) if (graduate.linked_in.include?("linkedin") || graduate.linked_in.include?("lnkd"))
    end
  end

  def get_li_details(link)
    profile = Linkedin::Profile.get_profile(link)
    if profile.nil? || !profile.location || !profile.current_companies
      p "Bad linked-in call"
      return "nil"
    end
    p "Seeding #{name}'s LinkedIn details"
    profile.picture ? update(img_url: profile.picture) : update(img_url: "app/assets/images/devbootcamplogo.jpeg")
    if !profile.current_companies[0] && profile.location && profile.country
      update(city: profile.location, state_or_country: profile.country)
      search = Geocoder.search("#{city}, #{state_or_country}")
    end
    if profile.current_companies[0] && profile.location && profile.country
      update(company: profile.current_companies[0][:company], city: profile.location, state_or_country: profile.country)
      search = Geocoder.search("#{company} in #{city}, #{state_or_country}")
    end
    if search && search[0]
      update(lat: search[0].latitude, long: search[0].longitude)
    end
  end
end
