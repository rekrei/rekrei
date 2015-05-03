class AddLocationToReconstruction < ActiveRecord::Migration
  def change
    add_reference :reconstructions, :location, index: true
  end
end
