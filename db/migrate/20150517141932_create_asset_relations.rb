class CreateAssetRelations < ActiveRecord::Migration
  def change
    create_table :asset_relations do |t|
      t.references :asset, index: true
      t.references :reconstruction, index: true

      t.timestamps null: false
    end
  end
end
