class LocationSerializer < ActiveModel::Serializer
  attributes :name, :state, :id, :url, :latitude, :longitude

  has_many :forecasts

end
