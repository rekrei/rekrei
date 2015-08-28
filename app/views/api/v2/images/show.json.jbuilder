json.(@image, :created_at, :updated_at, :uuid, :image_file_name, :image_file_size, :image_content_type)
json.url Rails.application.config_for(:project_mosul)['host'] + @image.image.url(:original)

json.reconstructions @image.reconstructions.each do |reconstruction|
  json.uuid reconstruction.uuid
  json.name reconstruction.name
  json.location do
    json.name reconstruction.location.name
    json.uuid reconstruction.location.uuid
  end
end

json.loccation do
  json.name @image.location.name
  json.uuid @image.location.uuid
  json.slug @image.location.slug
  json.coordinates do
    json.latitude @image.location.lat
    json.longitude @image.location.long
  end
end
