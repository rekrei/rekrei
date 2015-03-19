class Artefact < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :sketchfab_models, dependent: :destroy
  after_initialize :set_uuid_value
  # has_paper_trail

  def attachments_array=(array)
    array.each do |file|
      attachments.build(:image => file)
    end
  end

  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end
end
