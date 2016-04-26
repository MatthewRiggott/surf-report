class ForecastsController < ApplicationController

  def index
    binding.pry
    @forecast = Forecast.create_json(params)
    render json: @response["locations"], status: 200

  end


end
