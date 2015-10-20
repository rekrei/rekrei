# Asset class for handling all uploads, attached files
class Asset < ActiveRecord::Base
  after_initialize :set_uuid_value

  has_many :asset_relations
  has_many :reconstructions, through: :asset_relations

  # has_one :asset_reconstruction_relation, -> { where(relatable_type: 'Reconstruction') }, class: AssetRelation
  # has_one :reconstruction, through: :asset_reconstruction_relation, source: :relatable, source_type: 'Reconstruction'

  belongs_to :artefact
  belongs_to :location
  belongs_to :old_reconstruction, class_name: 'Reconstruction', foreign_key: 'reconstruction_id'

  has_attached_file :image, styles: {
    square: '600x360#',
    medium: '300x300>',
    thumb: '100x100>'
  }, default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :image, content_type: %r{image/.*}

  scope :assigned_to_artefact, -> { where('artefact_id IS NOT NULL') }
  scope :unmasked, -> { where('masked_image_file_name IS NULL') }
  scope :masked, -> { where('masked_image_file_name IS NOT NULL') }
  scope :location, ->(location) { where(location: location) }

  scope :assigned_to_reconstruction, -> { where(id: AssetRelation.pluck(:asset_id)) }
  scope :unassigned_to_reconstruction, -> { where.not(id: AssetRelation.pluck(:asset_id)) }


  def self.next(record)
    location(record.location)
      .unassigned_to_reconstruction.where('id > ?', record.id)
      .limit(1)
      .order('id ASC')
      .first
  end

  def self.previous(record)
    location(record.location)
      .unassigned_to_reconstruction.where('id < ?', record.id)
      .limit(1)
      .order('id DESC')
      .first
  end

  def next
    return Image.next(self)
  end

  def previous
    return Image.previous(self)
  end

  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end

  def add_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def image_remote_url=(url_value)
    self.image = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/face.png
    # avatar_file_name == "face.png"
    # avatar_content_type == "image/png"
    @image_remote_url = url_value
  end
end
