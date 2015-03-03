class Artefact < ActiveRecord::Base
  has_many :attachments, dependent: :destroy
  after_initialize :set_uuid_value
  # has_paper_trail

  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end
end
