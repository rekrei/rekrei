class Artefact < ActiveRecord::Base
  has_many :assets, dependent: :destroy
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
