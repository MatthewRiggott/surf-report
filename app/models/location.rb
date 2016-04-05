class Location < ActiveRecord::Base
  has_many :forecasts

  def attributes
    {"id" => self.id, "name" => self.name, "state" => self.state, "lat_lon" => pretty_coordinates, "url" => self.url}
  end

  def self.create_json(fields)
    result = {}
    wrong_attribute_fields = fields - self.attribute_names
    return { "errors" => { "invalid field names" => wrong_attribute_fields }} if !(wrong_attribute_fields).empty?
    self.all.each do |location|
      result["locations"] << location.attributes.slice(*fields)
    end
    result
  end

  private

  def pretty_coordinates
    if self.latitude && self.longitude
      "#{self.latitude},#{self.longitude}"
    else
      nil
    end
  end
end
