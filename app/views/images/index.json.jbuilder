json.total_count @images.count
json.current_page @images.current_page.to_i
json.per_page @images.per_page
json.reconstruction @reconstruction.slug
json.images @images do |image|
  json.(image, :created_at, :updated_at, :id)
  json.square_url image.image.url(:square)
  json.original_url image.image.url(:original)
  json.file_name image.image_file_name
end
