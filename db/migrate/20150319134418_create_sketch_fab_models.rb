class CreateSketchFabModels < ActiveRecord::Migration
  def change
    create_table :sketch_fab_models do |t|
      t.references :artefact, index: true
      t.string :bbcode

      t.timestamps null: false
    end
    add_foreign_key :sketch_fab_models, :artefacts
  end
end
