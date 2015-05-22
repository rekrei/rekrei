class CreateImageMatches < ActiveRecord::Migration
  def change
    create_table :image_matches do |t|
      t.references :parent_image, index: true
      t.references :comparison_image, index: true
      t.integer :matches
      t.string :time_to_match
      t.binary :has_error

      t.timestamps null: false
    end
  end
end
