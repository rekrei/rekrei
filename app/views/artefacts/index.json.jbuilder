json.array!(@artefacts) do |artefact|
  json.extract! artefact, :id, :name, :description, :images
  json.url artefact_url(artefact, format: :json)
end
