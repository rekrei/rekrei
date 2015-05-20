# Inherited from Asset, image specific attachments
class Image < Asset
  # all images returned where image is parent image
  has_many :parent_matches, class_name: ImageMatch, foreign_key: :parent_image_id
  has_many :compared_images, -> (image) { where('image_matches.location_id = ?', image.location.id).order 'matches DESC' }, through: :parent_matches, class_name: Image, source: :comparison_image

  # all images where image is the compared image
  has_many :comparison_matches, class_name: ImageMatch, foreign_key: :comparison_image_id

  after_create :update_matches

  has_attached_file :masked_image, styles: {
    square: '600x360#',
    medium: '300x300>',
    thumb: '100x100>'
  }, default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :masked_image,
                                    content_type: %r{image/.*}

  self.per_page = 16

  # scope :parent_match_images, lambda {
  #   where('id IN (SELECT DISTINCT(parent_image_id) FROM image_matches)')
  # }

  scope :parent_match_images, -> { joins(:parent_matches) }
  scope :comparison_match_images, -> { joins(:comparison_matches) }
  scope :matched, -> { 
    joins(:parent_matches, :comparison_matches).uniq
  }
  scope :unmatched, -> {
    where.not(id: ImageMatch.pluck(:parent_image_id, :comparison_image_id).flatten.uniq )
  }

  scope :unmatched_for_image, ->(image) { joins(:asset_relations).where("asset_relations.relatable_id = ? AND relatable_type = 'Location'", image.location.id).where.not(id: image.parent_matches.pluck(:comparison_image_id).concat([image.id]).flatten.uniq) }

  def unmatched_images
    Image.unmatched_for_image(self)
  end

  def compare(image)
    ImageMatch.compare_images([self,image])    
  end

  def update_matches
    QueueUnmatchedImagesJob.perform_later image: self
  end

  def self.create_with_location(params:, location:)
    image = self.create(params)
    image.asset_relations.create(relatable: location)
    return image
  end
end
