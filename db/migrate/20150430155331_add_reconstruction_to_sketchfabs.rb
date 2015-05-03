class AddReconstructionToSketchfabs < ActiveRecord::Migration
  def change
    add_reference :sketchfabs, :reconstruction, index: true
  end
end
