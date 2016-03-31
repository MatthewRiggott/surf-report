class Location < ActiveRecord::Base
  has_many :forecasts
  has_many :surfhistories

end
