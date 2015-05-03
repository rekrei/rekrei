class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.float :lat, precision: 6, scale: 2
      t.float :long, precision: 6, scale: 2
      t.timestamps null: false
    end
  end
end
