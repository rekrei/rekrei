json.(@image, :created_at, :updated_at)
json.id @image.id
json.url Rails.application.config_for(:project_mosul)['host'] + @image.image.url(:original)
