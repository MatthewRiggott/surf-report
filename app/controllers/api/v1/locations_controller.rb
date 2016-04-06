
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
    end
  end
end
