json.(@image, :created_at, :updated_at)
json.id @image.id
json.url Rails.application.config_for(:project_mosul)['host'] + @image.image.url(:original)

json.artefact do
  json.id @image.try(:artefact).try(:id)
  json.uuid @image.try(:artefact).try(:uuid)
  json.name @image.try(:artefact).try(:name)
  json.uri artefact_url(@image.try(:artefact).try(:id))
end
