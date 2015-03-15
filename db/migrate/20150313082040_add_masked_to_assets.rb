class AddMaskedToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :masked, :boolean
  end
end
