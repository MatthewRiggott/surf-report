
module Api
  module V1
    class LocationsController < ApplicationController

      def index
        @response = Location.create_json(params["fields"])
        if !@response.has_key? "errors"
          render json: @response["locations"], status: 200
        else
          render json: { error: @response["errors"] }, status: 422
        end
      end

      def show
        @location = Location.find(params[:id])
        if @location
          render json: @location.forecasts, status: 200, meta: {name: @location.name, url: @location.url}
        else
          render json: {error: "invalid location id"}, status: 422
        end
      end

    end
  end
end
