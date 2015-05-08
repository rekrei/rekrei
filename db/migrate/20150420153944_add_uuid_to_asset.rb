class AddUuidToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :uuid, :string
  end
end
