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
    sleep 1

    if response.message == "OK"
      puts "HTTP response OK"
      puts "updated today - #{!can_update?}"
      if can_update?
        raw_data = JSON.parse(response.body)
        new_forecast = updated_forecast_data(raw_data)
        if Forecast.update(new_forecast.keys, new_forecast.values)
          puts "#{@location.name} updated"
          return true
        else
          puts "#{@location.name} failed to update"
          return false
        end
      end
    else
      puts "HTTP response bad - #{response.message}"
      return false
    end
  end

  private

  def can_update?()
    # have we already updated this location today?
    todays_cast = Forecast.find_by(location: @location, day: 0, time: 8)
    if todays_cast.max_height.nil?
      true
    else
      !(Date.today == todays_cast.updated_at.to_date)
    end
  end

  def location_url()
    URI(@BASE_URL + "spot_id=#{@location.msw_id}&fields=localTimestamp,swell.absMaxBreakingHeight,swell.absMinBreakingHeight,swell.components.primary.period,fadedRating,solidRating")
  end

  def updated_forecast_data(forecast)
    forecast_from_api = {}
    forecast.each do |api_data|
      cast_time = Time.at(api_data["localTimestamp"])
      hour_casted = cast_time.hour
      # take two forecasts per day
      if (hour_casted > 6 && hour_casted <= 9) || (hour_casted > 12 && hour_casted <= 15)
        hour_casted = (hour_casted > 6 && hour_casted <= 9) ? 8 : 14
        period = api_data["swell"]["components"]["primary"]["period"]
        min_height = api_data["swell"]["absMinBreakingHeight"]
        max_height = api_data["swell"]["absMaxBreakingHeight"]
        faded_rating = api_data["fadedRating"]
        solid_rating = api_data["solidRating"]
        day = cast_time.to_date.mjd - Date.today.mjd
        forecast_id = Forecast.find_by(location: @location, day: day, time: hour_casted).id
        forecast_from_api[forecast_id] =
        {
          time: hour_casted, day: day, period: period,
          min_height: min_height, max_height: max_height,
          solid_stars: solid_rating, faded_stars: faded_rating
        }
      end
    end
    forecast_from_api
  end

end
