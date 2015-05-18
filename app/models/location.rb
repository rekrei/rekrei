class Location < ActiveRecord::Base
  has_many :reconstructions
  has_many :asset_relations, as: :relatable
  has_many :images, through: :asset_relations, dependent: :destroy, source: :asset

  has_many :old_images, dependent: :destroy, class: Image

  has_many :image_matches
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  after_initialize :set_uuid_value
  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end
end
