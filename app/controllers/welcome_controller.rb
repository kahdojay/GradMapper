class WelcomeController < ApplicationController
  def index
  end

  def graduates
    if request.xhr?
      input = params["input"].delete("\n").strip if params["input"]
      puts "INPUT IS #{input}"
      puts "FILTER IS #{params['filter']}"
      case params["filter"]
      when "name"
        puts "NAME SEARCH"
        @graduates = Graduate.where(name: input, display: true).order("name")
      when "company"
        puts "COMPANY SEARCH"
        @graduates = Graduate.where(company: input, display: true).order("name")
      when "cohort"
        puts "COHORT SEARCH"
        cohort_name = input
        @cohort = Cohort.find_by(name: cohort_name)
        @graduates = @cohort.graduates.where(display: true).order("name")
      else
        @graduates = Graduate.where(display: true).order("name")
      end
      render json: @graduates
    end

    # if params["cohort"]
    #   cohort_name = params["cohort"].delete("\n").strip
    #   @cohort = Cohort.find_by(name: cohort_name)
    #   @graduates = @cohort.graduates.where(display: true).order("name")
    # else
    #   @graduates = Graduate.where(display: true).order("name")
    # end
    # render json: @graduates if request.xhr?
  end
end