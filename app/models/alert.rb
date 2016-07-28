class Alert < ActiveRecord::Base
  has_many :users

  def daily_alert
    everyday = self.new(
      sunday: true,
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true
    )
  end

  def weekend_alert
    self.new(
      sunday: true,
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: true,
      saturday: true
    )
  end

  def self.check_alerts_notify_users
    # forecasts[state][day] = {location, morning_cast, afternoon}
    forecasts = Forecast.best_casts
    # send email

  end



end
