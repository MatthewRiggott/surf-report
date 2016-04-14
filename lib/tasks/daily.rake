require './app/services/msw_api'
require 'dotenv'
Dotenv.load

namespace :daily do
  desc "TODO"
  task consume_api: :environment do
    Location.all.each do |location|
      MswApi.update_forecast_for(location) if location.forecast_updated_at.try(:to_date) != Date.today
    end
  end
end
