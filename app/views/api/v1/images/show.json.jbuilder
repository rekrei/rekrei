json.(@image, :created_at, :updated_at)
json.uuid @image.uuid
json.url Rails.application.config_for(:rekrei)['host'] + @image.image.url(:original)

json.artefact do
  json.id @image.try(:artefact).try(:id)
  json.uuid @image.try(:artefact).try(:uuid)
  json.name @image.try(:artefact).try(:name)
  json.uri @image.artefact.present? ? api_artefact_path(@image.artefact.uuid) : nil
end
