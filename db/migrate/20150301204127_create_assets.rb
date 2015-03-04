class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :asset_type
      t.belongs_to :artefact, index: true

      t.timestamps null: false
    end
  end
end
