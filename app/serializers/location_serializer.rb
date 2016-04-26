class LocationSerializer < ActiveModel::Serializer
  attributes :name, :state, :id, :url, :lat_lon
  has_many :forecasts

  def lat_lon
    "#{object.latitude},#{object.longitude}"
  end
end
