class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate
  after_create :scrape_linkedin

  private

  def load_into_soulmate
    loader = Soulmate::Loader.new("graduates")
    loader.add("term" => name, "id" => id, "data" => { "link" => Rails.application.routes.url_helpers.graduate_path(self) })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("graduates")
    loader.remove("id" => id)
  end

  def scrape_linkedin
    return ("nil") if (linked_in.nil?)
    return ("empty") if (linked_in.empty?)
    get_linkedin_profile(linked_in) if (linked_in.include?("linkedin") || linked_in.include?("lnkd"))
  end

  def get_linkedin_profile(link)
    profile = Linkedin::Profile.get_profile(link)
    if profile && profile.location && profile.current_companies[0]
      p "Seeding #{profile.name}'s location and company"
      update(location: profile.location, company: profile.current_companies[0][:company])
      search = Geocoder.search("#{profile.location} #{profile.current_companies[0][:company]}")
      if search[0]
        p "Seeding #{profile.name}'s coordinates"
        lat = search[0].latitude
        lng = search[0].longitude
        update(lat: lat, long: lng)
      end
    end
  end

  def update_grad(profile, coordinates)
    self.update(
      location: profile.location,
      company: profile.current_companies[0][:company],
      lat: coordinates['lat'],
      long: coordinates['lng']
      )
  end
end
