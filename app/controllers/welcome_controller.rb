class WelcomeController < ApplicationController
  def index
  end

  def graduates
    if params["cohort"]
      cohort_name = params["cohort"].delete("\n").strip
      @cohort = Cohort.find_by(name: cohort_name)
      @graduates = @cohort.graduates.order('name')
    else
      @graduates = Graduate.order('name')
    end
    render json: @graduates if request.xhr?
  end
end