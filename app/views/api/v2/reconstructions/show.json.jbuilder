json.(@reconstruction, :uuid, :created_at, :updated_at, :name, :slug)
json.url location_reconstruction_url(@reconstruction.location, @reconstruction)

json.images @reconstruction.images.each do |image|
  json.created_at image.created_at
  json.updated_at image.updated_at
  json.uuid image.uuid
  json.file_name image.image_file_name
  json.content_type image.image_content_type
  json.file_size image.image_file_size
  json.url Rails.application.config_for(:rekrei)['host'] + image.image.url(:original)
end

json.location do
  json.uuid @reconstruction.location.uuid
  json.name @reconstruction.location.name
  json.slug @reconstruction.location.slug
  json.coordinates do
    json.latitude @reconstruction.location.lat
    json.longitude @reconstruction.location.long
  end
end
