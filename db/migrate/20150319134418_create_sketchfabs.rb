class CreateSketchfabs < ActiveRecord::Migration
  def change
    create_table :sketchfabs do |t|
      t.references :artefact, index: true
      t.string :bbcode

      t.timestamps null: false
    end
    add_foreign_key :sketchfabs, :artefacts
  end
end
