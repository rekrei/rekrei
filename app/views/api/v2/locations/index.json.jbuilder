json.locations @locations do |location|
  json.(location, :created_at, :updated_at)
  json.uuid location.uuid
  json.name location.name
  json.coordinates do
    json.longitude location.long
    json.latitude location.lat
  end
  json.url location_url(location)
  json.url Rails.application.config_for(:rekrei)['host'] + location_path(location)
end
