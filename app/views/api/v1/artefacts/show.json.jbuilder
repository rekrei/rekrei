json.(@artefact, :uuid, :id, :created_at, :updated_at, :id, :name)
json.url artefact_url(@artefact)

json.images @artefact.images do |image|
  json.(image, :created_at, :updated_at)
  json.id image.id
  json.url Rails.application.config_for(:project_mosul)['host'] + image.image.url(:original)
end
