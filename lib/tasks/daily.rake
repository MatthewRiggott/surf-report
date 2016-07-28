require './app/services/msw_api'
require './app/models/alert'
if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load
end

namespace :daily do
  desc "daily task - update db from forecast API"
  task consume_api: :environment do
    Location.all.each do |location|
      MswApi.update_forecast_for(location) if location.forecast_updated_at.try(:to_date) != Date.today
    end
  end

  desc "daily task - check user notifications and send emails as needed"
  task email_notifications: :environment do
    Alert.check_alerts_notify_users
  end
end
