class AddUuidToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :uuid, :string
    add_index :locations, :uuid
  end
end
