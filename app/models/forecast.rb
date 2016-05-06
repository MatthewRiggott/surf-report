class Forecast < ActiveRecord::Base
  belongs_to :location

  def name
    self.location.name
  end

  def url
    self.location.name
  end

  def attributes
    {
      "date" => (self.location.updated_at + self.day.days + self.time.hours).to_f,
      "faded_rating" => self.faded_stars,
      "solid_rating" => self.solid_stars,
      "period" => self.period,
      "max_height" => self.max_height,
      "min_height" => self.min_height
    }
  end

  def self.ratings_range
    [0,1,2,3,4,5,"Best"]
  end

  def self.filter_data(day: 0, min_rating: 3)
    Forecast.where("day = ? AND solid_stars = ?", day, min_rating)
  end

  def self.forecast_array(location, start_day, end_day)

    start_day = start_day.nil? ? -3 : start_day.to_i
    forecasts = location.forecasts.where("day >= ? AND day <= ?", start_day, end_day)
    forecasts = forecasts.order(:day, :time).to_a
    {
      beach_name: location.name,
      beach_id: location.id,
      forecast_url: location.url,
      forecast: forecasts
    }
  end

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

  def self.display_attributes
    { printable: [
        "Name",
        "Max Height",
        "Min Height",
        "Faded Star Rating",
        "Solid Star Rating",
        "Period",
        "URL Link"
      ],
      method_fields: [
        :name,
        :max_height,
        :min_height,
        :solid_stars,
        :faded_stars,
        :period,
        :url
      ]
    }
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
