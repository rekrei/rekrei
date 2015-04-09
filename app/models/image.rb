# Inherited from Asset, image specific attachments
class Image < Asset
  has_attached_file :masked_image, styles: {
    square: '600x360#',
    medium: '300x300>',
    thumb: '100x100>'
  }, default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :masked_image,
                                    content_type: %r{image/.*}

  self.per_page = 16
end
