json.(@location, :uuid, :created_at, :updated_at, :name, :slug)
json.url location_url(@location)

json.images  @location.images.each do |image|
  json.uuid image.uuid
  json.file_name image.image_file_name
end

json.coordinates do
  json.latitude @location.lat
  json.longitude @location.long
end

json.reconstrucions @location.reconstructions.each do |reconstruction|
  json.uuid reconstruction.uuid
  json.name reconstruction.name
end
