json.(@location, :uuid, :created_at, :updated_at, :name, :slug)
json.url location_url(@location)

json.coordinates do
  json.latitude @location.lat
  json.longitude @location.long
end

json.reconstrucions @location.reconstructions.each do |reconstruction|
  json.uuid reconstruction.uuid
  json.name reconstruction.name
  json.images reconstruction.images.collect(&:uuid)
end

json.images  @location.images.each do |image|
  json.uuid image.uuid
  json.file_name image.image_file_name
  json.url Rails.application.config_for(:rekrei)['host'] + image.image.url(:original)
end
