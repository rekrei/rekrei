json.(@image, :created_at, :updated_at, :uuid, :image_file_name, :image_file_size, :image_content_type)
json.url Rails.application.config_for(:project_mosul)['host'] + @image.image.url(:original)
json.reconstructions @image.reconstructions.collect(&:uuid)
json.location @image.location.uuid
