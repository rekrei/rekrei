class Reconstruction < ActiveRecord::Base
  belongs_to :cover_image, class_name: Image
  belongs_to :location

  has_many :asset_relations
  has_many :images, -> { uniq }, through: :asset_relations, dependent: :destroy, source: :asset

  has_many :old_images, dependent: :destroy, class: Image
  has_many :sketchfabs, dependent: :destroy

  after_initialize :set_uuid_value
  has_paper_trail

  scope :sketchfabless, lambda {
    where('reconstructions.id NOT IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }
  scope :with_sketchfabs, lambda {
    where('reconstructions.id IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }

  validates :location, presence: true
  # validates :cover_image, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  def show_cover_image
    self.cover_image || self.images.first
  end

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
