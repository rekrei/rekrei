class Asset < ActiveRecord::Base
  belongs_to :artefact
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  # do_not_validate_attachment_file_type :image
end