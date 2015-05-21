class AssetRelation < ActiveRecord::Base
  belongs_to :asset
  belongs_to :reconstruction

  def self.migrate_to_many_to_many
    Asset.all.each do |asset|
      if asset.old_reconstruction.present?
        AssetRelation.create(reconstruction: asset.old_reconstruction, asset: asset)
      end
    end
  end
end
