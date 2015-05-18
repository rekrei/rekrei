class AssetRelation < ActiveRecord::Base
  belongs_to :asset
  belongs_to :relatable, polymorphic: true

  def self.migrate_to_many_to_many
    Asset.all.each do |asset|
      if asset.old_location.present?
        AssetRelation.create(relatable: asset.old_location, asset: asset)
      end
      if asset.old_reconstruction.present?
        AssetRelation.create(relatable: asset.old_reconstruction, asset: asset)
      end
    end
  end
end
