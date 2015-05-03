class CreateReconstructions < ActiveRecord::Migration
  def change
    create_table :reconstructions do |t|
      t.string :name
      t.string :uuid
      t.string :slug
      t.text :description
      t.references :cover_image, index: true
      t.timestamps null: false
    end
    add_index :reconstructions, :uuid
  end
end
