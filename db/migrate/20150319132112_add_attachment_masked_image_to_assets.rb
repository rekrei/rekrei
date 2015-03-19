class AddAttachmentMaskedImageToAssets < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.attachment :masked_image
    end
  end

  def self.down
    remove_attachment :assets, :masked_image
  end
end
