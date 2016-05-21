json.reconstructions @reconstructions do |reconstruction|
  json.(reconstruction, :created_at, :updated_at)
  json.uuid reconstruction.uuid
  json.name reconstruction.name
  json.slug reconstruction.slug
  json.location reconstruction.location, :uuid, :name, :slug
  json.images reconstruction.images.each do |image|
    json.uuid image.uuid
    json.url Rails.application.config_for(:rekrei)['host'] + image.image.url(:original)
  end
end
