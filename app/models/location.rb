class Location < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :reconstructions, through: :images

  has_many :image_matches
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  after_initialize :set_uuid_value
  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end
end
