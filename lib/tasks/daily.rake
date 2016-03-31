require './app/services/msw_api'
require 'dotenv'
Dotenv.load

namespace :daily do
  desc "TODO"
  task consume_api: :environment do
    Location.all.each do |location|
      MswApi.update_forecast_for(location)
    end
  end
end
