class MapController < ApplicationController
  def index
    @cohorts = Cohort.all
  end

  def graduates
    @graduates = Graduate.all
    if request.xhr?
      render json: @graduates
    end
  end
end