# Asset class for handling all uploads, attached files
class Asset < ActiveRecord::Base
  belongs_to :artefact
  belongs_to :reconstruction
  
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

  def self.next(record)
    unassigned_to_artefact.where('id > ?', record.id)
      .limit(1)
      .order('id ASC')
      .first
  end

  def self.previous(record)
    unassigned_to_artefact.where('id < ?', record.id)
      .limit(1)
      .order('id DESC')
      .first
  end

  def next(location = nil)
    if location
      return location.images.next(self)
    else
      return Image.next(self)
    end
  end

  def previous(location = nil)
    if location
      return location.images.previous(self)
    else
      return Image.previous(self)
    end
  end
end
