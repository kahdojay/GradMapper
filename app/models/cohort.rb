class Cohort < ActiveRecord::Base
  has_many :graduates, primary_key: "dbc_id", foreign_key: "dbc_id"
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  private
  def load_into_soulmate
    loader = Soulmate::Loader.new("cohorts")
    loader.add("term" => name, "id" => id, "data" => { "link" => Rails.application.routes.url_helpers.cohort_path(self) })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("cohorts")
    loader.remove("id" => id)
  end
end