require 'geokit'

class Location < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :reconstructions#, -> { uniq }, through: :images

  has_many :image_matches

  validates :name, presence: true
  validates :lat, presence: true
  validates :long, presence: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  after_initialize :set_uuid_value
  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end

  def get_extent(distance)
    point = Geokit::LatLng.new(self.lat, self.long)
    point_sw = point.endpoint(225,distance)
    point_ne = point.endpoint(45,distance)
    #Flickr wants
    #The 4 values represent the bottom-left corner of the box and the top-right corner,
    #minimum_longitude, minimum_latitude, maximum_longitude, maximum_latitude.
    bbox = [point_sw.lng, point_sw.lat, point_ne.lng, point_ne.lat]
    return bbox.join(",")
  end
end
