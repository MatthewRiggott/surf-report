# contains methods to repopulate forecast in model using MSW Forecast API
require 'net/http'
Dotenv.load

class MswApi

  def initialize(location)
    @location = location
    @BASE_URL = ("http://magicseaweed.com/api/" + ENV["MSW_Key"] + "/forecast/?")
  end

  def self.update_forecast_for(location)
    self.new(location).update_forecast
  end

  def update_forecast()
    forecast = Forecast.find_or_create_by(location: @location)
    response = Net::HTTP.get_response(location_url())

    if response.message == "OK"
      puts "HTTP response OK"
      puts "updated today - #{!can_update?}"
      raw_data = JSON.parse(response.body)
      new_forecast = updated_forecast_data(raw_data)
      Forecast.transaction do
        Forecast.update_history(@location)
        Forecast.update(new_forecast.keys, new_forecast.values)
        @location.update(forecast_updated_at: Time.now)
      end

      if @location.forecast_updated_at.try(:to_date) == Time.now.utc.to_date
        puts "#{@location.name} has been updated"
        return true
      else
        puts "#{@location.name} failed to update"
        return false
      end

    else
      puts "HTTP response - #{response.message}"
      puts "Already updated" if !can_update?
      return false
    end
  end

  private

  def can_update?()
    # have we already updated this location today?
    last_update = @location.forecast_updated_at
    !(Date.today == last_update.try(:to_date))
  end

  def location_url()
    URI(@BASE_URL + "spot_id=#{@location.msw_id}&fields=timestamp,swell.absMaxBreakingHeight,swell.absMinBreakingHeight,swell.components.primary.period,fadedRating,solidRating")
  end

  def updated_forecast_data(forecast)
    forecast_from_api = {}
    forecast.each do |api_data|
      cast_time = Time.at(api_data["timestamp"])
      hour_casted = cast_time.hour
      # take two forecasts per day
      if (hour_casted > 6 && hour_casted <= 9) || (hour_casted > 12 && hour_casted <= 15)
        hour_casted = (hour_casted > 6 && hour_casted <= 9) ? 8 : 14
        period = api_data["swell"]["components"]["primary"]["period"]
        min_height = api_data["swell"]["absMinBreakingHeight"]
        max_height = api_data["swell"]["absMaxBreakingHeight"]
        solid_rating = api_data["solidRating"]
        faded_rating = api_data["fadedRating"] + api_data["solidRating"]
        day = cast_time.to_date.mjd - Time.now.utc.to_date.mjd

        if day >= 0
          forecast_id = Forecast.find_by(location: @location, day: day, time: hour_casted).id
          forecast_from_api[forecast_id] = {
            min_height: min_height,
            max_height: max_height,
            period: period,
            faded_stars: faded_rating,
            solid_stars: solid_rating
          }
        end
      end
    end
    forecast_from_api
  end

end
