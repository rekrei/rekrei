class AddReconstructionToAsset < ActiveRecord::Migration
  def change
    add_reference :assets, :reconstruction, index: true
  end
end
