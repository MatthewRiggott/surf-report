class Location < ActiveRecord::Base
  has_many :forecasts

  # def attributes
  #   {"id" => self.id, "name" => self.name, "state" => self.state, "lat_lon" => pretty_coordinates, "url" => self.url}
  # end
  def self.all_states
    self.uniq.pluck(:state)
  end

  def self.create_json(api_input_fields)
    fields = api_input_fields.split(",") unless api_input_fields.blank?
    result = {}
    if fields.nil?
      return { "locations" => "valid fields are #{api_fields.to_s}"}
    elsif !(incorrect_fields(fields)).empty?
      return { "errors" => { "invalid field  names" => incorrect_fields(fields) }}
    else
      result["locations"] = []
      self.all.each do |location|
        result["locations"] << location.attributes.slice(*fields)
      end
    end
    result
  end

  private

  def self.incorrect_fields(fields)
    fields - api_fields
  end

  def self.api_fields
    ["id", "name", "state", "lat_lon", "url"]
  end

  # def pretty_coordinates
  #   if self.latitude && self.longitude
  #     "#{self.latitude},#{self.longitude}"
  #   else
  #     nil
  #   end
  # end
end
