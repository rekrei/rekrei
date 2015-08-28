json.locations @locations do |location|
  json.(location, :created_at, :updated_at)
  json.uuid location.uuid
  json.name location.name

  json.images location.images.each do |image|
    json.uuid image.uuid
    json.url Rails.application.config_for(:project_mosul)['host'] + image.image.url(:original)
  end

  json.reconstructions location.reconstructions.each do |reconstruction|
    json.uuid reconstruction.uuid
    json.name reconstruction.name
    json.location do
      json.name reconstruction.location.name
      json.uuid reconstruction.location.uuid
    end
  end
end
