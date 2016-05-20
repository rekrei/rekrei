json.images @images do |image|
  json.(image, :created_at, :updated_at)
  json.uuid image.uuid
  json.url Rails.application.config_for(:rekrei)['host'] + image.image.url(:original)
  json.location image.location.uuid
  json.reconstructions image.reconstructions.collect(&:uuid)
end
