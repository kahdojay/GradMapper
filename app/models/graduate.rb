class Graduate < ActiveRecord::Base
  belongs_to :cohort, foreign_key: "dbc_id"
  # after_save :load_into_soulmate
  # before_destroy :remove_from_soulmate
  after_create :scrape_linkedin

  private

  # def load_into_soulmate
  #   loader = Soulmate::Loader.new("graduates")
  #   loader.add("term" => name, "id" => id, "data" => { "link" => Rails.application.routes.url_helpers.graduate_path(self) })
  # end

  # def remove_from_soulmate
  #   loader = Soulmate::Loader.new("graduates")
  #   loader.remove("id" => id)
  # end

  def scrape_linkedin
    return "nil" if linked_in.nil?
    return "empty" if linked_in.empty?
    get_li_details(linked_in) if (linked_in.include?("linkedin") || linked_in.include?("lnkd"))
  end

  def get_li_details(link)
    profile = Linkedin::Profile.get_profile(link)
    if profile.nil? || !profile.location || !profile.current_companies
      p "Bad linked-in call"
      return "nil"
    end
    p "Seeding #{name}'s LinkedIn details"
    profile.picture ? update(img_url: profile.picture) : update(img_url: "app/assets/images/devbootcamplogo.jpeg")
    if profile.current_companies[0]
      update(location: profile.current_companies[0][:address], company: profile.current_companies[0][:company])
      search_string = location
    else
      update(location: profile.location, company: "company unknown")
      search_string = "#{location} city"
    end
    search = Geocoder.search(search_string)
    update(lat: search[0].latitude, long: search[0].longitude) if search[0]
  end

  # def update_grad(profile, coordinates)
  #   self.update(
  #     location: profile.location,
  #     company: profile.current_companies[0][:company],
  #     lat: coordinates['lat'],
  #     long: coordinates['lng']
  #     )
  # end
end
