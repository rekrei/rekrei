class Location < ActiveRecord::Base
  has_many :reconstructions

  extend FriendlyId
  friendly_id :name, use: :slugged
  
  after_initialize :set_uuid_value
  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end
end
