
module Api
  module V1
    class LocationsController < ApplicationController

      def index
        if params["fields"]
          @response = Location.create_json(params["fields"].split ",")
          if !@response.has_key? "errors"
            render json: @response["locations"], status: 200
          else
            render json: { error: @response["errors"] }, status: 422
          end
        else
          render json: { error: "No field parameters" }, status: 422
        end
      end
    end
  end
end
