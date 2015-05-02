class AddLocationToAssets < ActiveRecord::Migration
  def change
    add_reference :assets, :location, index: true
  end
end
