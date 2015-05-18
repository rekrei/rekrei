class Reconstruction < ActiveRecord::Base
  belongs_to :cover_image, class_name: Image
  belongs_to :location

  has_many :asset_relations, as: :relatable
  has_many :images, through: :asset_relations, dependent: :destroy, source: :asset

  has_many :old_images, dependent: :destroy, class: Image
  has_many :sketchfabs, dependent: :destroy

  after_initialize :set_uuid_value
  has_paper_trail

  scope :sketchfabless, lambda {
    where('id NOT IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }
  scope :with_sketchfabs, lambda {
    where('id IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }

  extend FriendlyId
  friendly_id :name, use: :slugged

  def set_cover_image(image)
    self.update(cover_image: image)
  end
  
  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end

  def set_default_cover_image
    self.set_cover_image(self.images.first) if self.images.count > 0
  end
end
