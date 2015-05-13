# Asset class for handling all uploads, attached files
class Asset < ActiveRecord::Base
  after_initialize :set_uuid_value

  belongs_to :artefact
  belongs_to :reconstruction  
  belongs_to :location


  has_attached_file :image, styles: {
    square: '600x360#',
    medium: '300x300>',
    thumb: '100x100>'
  }, default_url: '/assets/:style/missing.png'
  validates_attachment_content_type :image, content_type: %r{image/.*}

  scope :assigned_to_artefact, -> { where('artefact_id IS NOT NULL') }
  scope :unassigned_to_artefact, -> { where('artefact_id IS NULL') }
  scope :unassigned_to_reconstruction, -> { where('reconstruction_id IS NULL') }
  scope :assigned_to_reconstruction, -> { where('reconstruction_id IS NOT NULL') }
  scope :unmasked, -> { where('masked_image_file_name IS NULL') }
  scope :masked, -> { where('masked_image_file_name IS NOT NULL') }
  scope :location, ->(location) { where(location: location)}

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
end
