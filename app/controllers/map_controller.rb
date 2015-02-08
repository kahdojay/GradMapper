class MapController < ApplicationController
  def graduates
    @graduates = Graduate.all
    if request.xhr?
      render json: @graduates
    end
  end
end