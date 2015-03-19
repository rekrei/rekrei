class Image < Asset
  has_attached_file :masked_image, :styles => { square: "600x360#", medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end