json.locations @locations do |location|
  json.(location, :created_at, :updated_at)
  json.uuid location.uuid
  json.name location.name
  json.coordinates do
    json.longitude location.long
    json.latitude location.lat
  end
  json.images location.images.each do |image|
    json.uuid image.uuid
    json.url Rails.application.config_for(:project_mosul)['host'] + image.image.url(:original)
  end

  json.reconstructions location.reconstructions.each do |reconstruction|
    json.uuid reconstruction.uuid
    json.name reconstruction.name
    json.images reconstruction.images.collect(&:uuid)
  end
end
