class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate
  after_create :linkedin_scraper

  private

  def load_into_soulmate
    loader = Soulmate::Loader.new("graduates")
    loader.add("term" => name, "id" => id, "data" => { "link" => Rails.application.routes.url_helpers.graduate_path(self) })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("graduates")
    loader.remove("id" => id)
  end

  def linkedin_scraper
    return ("nil") if (linked_in.nil?)
    return ("empty") if (linked_in.empty?)
    get_linkedin(linked_in) if (linked_in.include?("linkedin") || linked_in.include?("lnkd"))
  end

  def get_linkedin(link)
    profile = Linkedin::Profile.get_profile(link)

    if !profile.nil? && !profile.name.nil? && !profile.location.nil? && !profile.current_companies.empty? && !grad_location(profile).empty?
      coordinates = grad_location(profile)[0].data["geometry"]["location"]
      update_grad(profile, coordinates)
    end
  end

  def grad_location(profile)
    Geocoder.search("#{profile.location}, #{profile.current_companies[0][:company]}")
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
