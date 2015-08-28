json.images @images do |image|
  json.(image, :created_at, :updated_at)
  json.uuid image.uuid
  json.url Rails.application.config_for(:project_mosul)['host'] + image.image.url(:original)
  json.location image.location
  json.reconstructions do
    image.reconstructions.each do |reconstruction|
      json.reconstruction do
        json.uuid reconstruction.uuid
        json.name reconstruction.name
        json.location do
          json.name reconstruction.location.name
          json.uuid reconstruction.location.uuid
        end
      end
    end
  end
end
