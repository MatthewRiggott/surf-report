class ForecastsController < ApplicationController

  def index
    @defaults = default_values
    @defaults[:day] = params["date"] if params["date"]
    @defaults[:min_rating] = params["min_rating"] if params["min_rating"]
    if filter_params[:min_rating] == "Best"
      @forecast = Forecast.surf_of_the_day(filter_params[:day])
    else
      @forecast = Forecast.filter_data(filter_params)
    end
  end

  private

  def default_values
    { day: 0, min_rating: 3 }
  end

  def filter_params
    filter_values = Hash.new
    filter_values[:day] = params["date"].nil? ? 0 : params["date"]
    filter_values[:min_rating] = params["min_rating"].nil? ? 3 : params["min_rating"]
    filter_values
  end

end
