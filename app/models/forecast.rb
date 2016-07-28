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

  def self.best_casts
    result = Hash.new()
    Location.all_states.each do |state|
      (0..4).each do |day|
        result[state] ||= []
        early_forecasts = self.joins(:location).where(day: day, time: 8, locations: {state: state} ).order(solid_stars: :DESC, faded_stars: :DESC, max_height: :DESC)
        later_forecasts = self.joins(:location).where(day: day, time: 14, locations: {state: state} ).order(solid_stars: :DESC, faded_stars: :DESC, max_height: :DESC)
        location_id = rank_cast(early_forecasts, later_forecasts)
        if location_id
          am = early_forecasts.find_by(location_id: location_id)
          pm = later_forecasts.find_by(location_id: location_id)
          result[state][day] = {location: Location.find(location_id), am: am, pm: pm}
        end
      end
    end
    result
  end

  ## TODO - Filtering Service Object / clean model up

  def self.filter_data(filter_criteria: "solid_stars", day: 0, min_rating: 3)
    Forecast.where("day = ? AND #{filter_criteria} >= ?", day, min_rating)
  end

  def self.surf_of_the_day(day)
    best_rating = Forecast.where(day: day).pluck(:solid_stars).max
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

  private

  def self.rank_cast(morning, afternoon)
    rank_hash = {}
    morning.pluck(:location_id).each_with_index { |f,i| rank_hash[f] = i}
    afternoon.pluck(:location_id).each_with_index { |f,i| rank_hash[f] += i}
    location = rank_hash.sort_by{|k,v| v}[0][0]
  end

end
