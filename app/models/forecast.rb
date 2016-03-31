class Forecast < ActiveRecord::Base
  belongs_to :location
  #before_update :update_history

  private

  def update_history
    if self.day == 0 && self.time == 8
      location = self.location
      (-2..0).each do |day|
        [8,14].each do |hour|
          Forecast.find_by(day: day, time: hour, location: location).update(day: day-1)
        end
      end
    end
  end
end
