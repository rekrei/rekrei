class AddUserToSketchfab < ActiveRecord::Migration
  def change
    add_reference :sketchfabs, :user, index: true
  end
end
