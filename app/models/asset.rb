# Asset class for handling all uploads, attached files
class Asset < ActiveRecord::Base
  after_initialize :set_uuid_value

  has_many :asset_relations
  
  has_one :asset_reconstruction_relation, -> { where(relatable_type: 'Reconstruction') }, class: AssetRelation
  has_one :reconstruction, through: :asset_reconstruction_relation, source: :relatable, source_type: 'Reconstruction'
  
  has_one :asset_location_relation, -> { where(relatable_type: 'Location') }, class: AssetRelation
  has_one :location, through: :asset_location_relation, source: :relatable, source_type: 'Location'

  belongs_to :artefact
  belongs_to :old_location, class_name: 'Location', foreign_key: 'location_id'
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
  scope :location, ->(location) { where(id: AssetRelation.where(relatable: location).pluck(:asset_id))}

  scope :assigned_to_reconstruction, -> { joins(:asset_relations).where("asset_relations.relatable_type = 'Reconstruction'") }
  scope :unassigned_to_reconstruction, -> { joins(:asset_relations).where.not('asset_relations.asset_id IN (?)', AssetRelation.where(relatable_type: 'Reconstruction').pluck(:asset_id)) }


  def self.next(record)
    ids = location(record.location).unassigned_to_reconstruction.pluck(:id)
    if id = ids[ids.find_index(record.id) + 1]
      return Image.find(id)
    else
      nil
    end
  end

  def self.previous(record)
    ids = location(record.location).unassigned_to_reconstruction.pluck(:id)
    index = ids.find_index(record.id)
    case index
    when 0
      return nil
    when nil
      return nil
    else
      return Image.find(ids[index - 1])
    end
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
