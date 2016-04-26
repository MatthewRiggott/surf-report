class ForecastSerializer < ActiveModel::Serializer
  attributes :period, :min_height, :max_height, :faded_rating, :solid_rating, :date

  def faded_rating
    "#{object.faded_stars}"
  end

  def solid_rating
    "#{object.solid_stars}"
  end

  def date
    "#{(object.location.updated_at.to_date + object.day.days + object.time.hours).to_f.round(0)}"
  end

end
