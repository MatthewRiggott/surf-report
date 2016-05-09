class Forecast < ActiveRecord::Base
  belongs_to :location, -> {order(name: :asc)}

  def name
    self.location.name
  end

  def display_time
    if time == 8
      "8:00 AM"
    else
      "2:00 PM"
    end
  end

  def url
    self.location.url
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

  def self.filter_data(filter_criteria: "solid_stars", day: 0, min_rating: 3)
    Forecast.where("day = ? AND #{filter_criteria} >= ?", day, min_rating)
  end

  def self.surf_of_the_day(day)
    best_rating = Forecast.all.pluck(:solid_stars).max
    Forecast.where("day = ? AND solid_stars = ?", day, best_rating)
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
        "Time",
        "Max Height",
        "Min Height",
        "Faded Star Rating",
        "Solid Star Rating",
        "Period"
      ],
      method_fields: [
        :name,
        :display_time,
        :max_height,
        :min_height,
        :faded_stars,
        :solid_stars,
        :period
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
