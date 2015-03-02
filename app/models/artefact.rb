class Artefact < ActiveRecord::Base
  has_many :attachments, dependent: :destroy
  # has_paper_trail
end
