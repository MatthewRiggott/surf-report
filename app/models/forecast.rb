class Forecast < ActiveRecord::Base
  belongs_to :location
  attr_reader :date

  def self.update_history(location)
    forecast_history = location.forecasts.where("day <= 0").order(day: "ASC")
    forecast_history.each do |forecast|
      if forecast.day == -3
        forecast.destroy
      else
        forecast.update(day: forecast.day - 1)
      end
    end
  end
end
