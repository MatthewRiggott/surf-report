class ForecastsController < ApplicationController

  def index
    @defaults = default_values
    @defaults[:day] = params["day"] if params["day"]
    @defaults[:min_rating] = params["min_rating"] if params["min_rating"]
    @forecast = Forecast.filter_data(filter_params)
  end

  private

  def default_values
    { day: 0, min_rating: 3 }
  end

  def filter_params
    filter_values = Hash.new
    filter_values[:day] = params["day"] if params["day"]
    filter_values[:min_rating] = params["min_rating"] if params["min_rating"]
    filter_values
  end

end
