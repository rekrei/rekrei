class CreateAssetRelations < ActiveRecord::Migration
  def change
    create_table :asset_relations do |t|
      t.references :asset, index: true
      t.references :relatable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
