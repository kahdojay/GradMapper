class WelcomeController < ApplicationController
  def index
  end

  def graduates
    @graduates = Graduate.all
    render json: @graduates if request.xhr?
  end
end