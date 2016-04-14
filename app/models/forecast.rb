class Forecast < ActiveRecord::Base
  belongs_to :location
  attr_reader :est_datetime

  def est_datetime
    (Time.now.utc.to_date + self.day.days) + Time.parse("#{self.hour_casted}:00").seconds_since_midnight.seconds
  end

  def self.update_history(location)
    forecast_history = location.forecasts.where("day <= -1").order(day: "ASC")
    forecast_history.each do |forecast|
      future_cast = Forecast.find_by(
        location: location,
        day: forecast.day + 1,
        time: forecast.time
      )
      forecast.update(future_cast.updateable_attributes)
    end
  end

  def updateable_attributes
    {
      max_height: self.max_height,
      min_height: self.min_height,
      period: self.period,
      solid_stars: self.solid_stars,
      faded_stars: self.faded_stars
    }
  end
end
