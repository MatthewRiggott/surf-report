class ForecastsController < ApplicationController

  def index
    @defaults = default_values
    @defaults[:day] = params["day"] if params["day"]
    @defaults[:min_rating] = params["min_rating"] if params["min_rating"]
    if filter_params["min_rating"] == "Best"
      binding.pry
      @forecast = Forecast.self.surf_of_the_day(filter_params)
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
    filter_values[:day] = params["day"] if params["day"]
    filter_values[:min_rating] = params["min_rating"] if params["min_rating"]
    filter_values
  end

end
