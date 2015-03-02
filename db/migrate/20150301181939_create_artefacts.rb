class CreateArtefacts < ActiveRecord::Migration
  def change
    create_table :artefacts do |t|
      t.string :name
      t.string :description
      t.string :museum_identifier

      t.timestamps null: false
    end
  end
end
