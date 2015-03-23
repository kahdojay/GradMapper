class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"
  after_create :check_valid_li

  def self.offset_grads_by_city(city)
    Graduate.where(city: city).each do |graduate|
      graduate.update(lat: graduate.lat.to_f + rand(-0.012..0.012), long: graduate.long.to_f + rand(-0.012..0.012))
    end
  end

  def self.offset_all_grads
    Graduate.where.not(lat:"unknown").each do |graduate|
      graduate.update(lat: graduate.lat.to_f + rand(-0.012..0.012), long: graduate.long.to_f + rand(-0.012..0.012))
    end
  end

  def self.scrape_li
    Graduate.where(valid_linked_in?: true, lat: "unknown").each do |graduate|
      graduate.get_li_details(graduate.linked_in)
    end
    dense_cities = ["Greater New York City Area", "New York City", "San Francisco", "San Francisco Bay Area", "Greater Chicago Area", "Chicago", "Boston"]
    dense_cities.each { |city| Graduate.offset_grads_by_city(city) }
  end

  def self.rescrape_locations
    Graduate.where(lat:"unknown", valid_linked_in?: true).each do |graduate|
      graduate.get_li_details(graduate.linked_in)
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
    profile.picture ? update(img_url: profile.picture) : update(img_url: "app/assets/images/avatar.png")
    if profile.location && profile.country
      update(city: profile.location, state_or_country: profile.country)
      if profile.location == profile.country
        search = Geocoder.search("#{profile.location.gsub(/Greater|Area|City/,'').strip} City")
      else
        search = Geocoder.search("#{profile.location.gsub(/Greater|Area|City/,'').strip}, #{profile.country.gsub(/Greater|Area|City/,'').strip}")
      end
    end
    if search && search[0]
      update(lat: search[0].latitude, long: search[0].longitude, display: true)
    end
    if profile.current_companies[0]
      update(company: profile.current_companies[0][:company])
    end
  end
end