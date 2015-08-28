# Artefact, base level model for movable heritage
class Artefact < ActiveRecord::Base
  has_many :asset_relations, as: :relatable
  has_many :images, through: :asset_relations, dependent: :destroy, source: :asset

  has_many :sketchfabs, dependent: :destroy

  after_initialize :set_uuid_value
  has_paper_trail

  scope :sketchfabless, lambda {
    where('id NOT IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }
  scope :with_sketchfabs, lambda {
    where('id IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }

  self.per_page = 16

  def attachments_array=(array)
    array.each do |file|
      attachments.build(image: file)
    end
  end

  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end

  def migrate_to_reconstruction
    reconstruction = Reconstruction.find_or_create(name: self.name, description: self.description, uuid: self.uuid, location_id: 1)

    self.images.each do |image|
      image.update(reconstruction: reconstruction)
    end

    self.sketchfabs.each do |sketchfab|
      sketchfab.update(reconstruction: reconstruction)
    end
  end
end
