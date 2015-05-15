class AddLocationToImageMatch < ActiveRecord::Migration
  def change
    add_reference :image_matches, :location, index: true
  end
end
