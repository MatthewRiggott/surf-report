module Api
  module V1

    class LocationsController < ApplicationController

    def index
      @locations = Location.all
      render json: @locations
    end


    def show



    end

    end
  end
end
