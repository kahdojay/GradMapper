class WelcomeController < ApplicationController
  def index
  end

  def graduates
    if request.xhr?
      input = params["input"].delete("\n").strip if params["input"]
      case params["filter"]
      when "name"
        @graduates = Graduate.where(name: input, display: true).order("name")
      when "city"
        @graduates = Graduate.where(city: input, display: true).order("name")
      when "company"
        @graduates = Graduate.where(company: input, display: true).order("name")
      when "cohort"
        cohort_name = input
        @cohort = Cohort.find_by(name: cohort_name)
        @graduates = @cohort.graduates.where(display: true).order("name")
      else
        @graduates = Graduate.where(display: true).order("name")
      end
      render json: @graduates
    end
  end
end