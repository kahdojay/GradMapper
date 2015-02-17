class WelcomeController < ApplicationController
  def index
  end

  def graduates
    if params["cohort"]
      cohort_name = params["cohort"].delete("\n").strip
      @cohort = Cohort.find_by(name: cohort_name)
      @graduates = @cohort.graduates
    else
      @graduates = Graduate.all
    end
    render json: @graduates if request.xhr?
  end
end