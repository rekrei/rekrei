class AddMetadataToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :metadata, :text
  end
end
