class AssetRelationsController < ApplicationController
  before_action :set_items, only: [:create]
  before_action :authenticate_user!

  def create
    respond_to do |format|
      if @asset_relation = AssetRelation.create(asset: @asset, reconstruction: @reconstruction)
        format.html do
          redirect_to location_reconstruction_path(@reconstruction.location.slug, @reconstruction), notice: 'Asset Added to Reconstruction'
        end
        format.js do
          render json: { message: 'success', asset_relation_id: @asset_relation.id }, status: 200
        end
      else
        format.html do
          redirect_to [@reconstruction.location,@reconstruction], notice: 'Error adding asset to Reconstruction'
        end
        format.js do
          render json: { error: @asset_relation.errors.full_messages.join(',') }, status: 400
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if @asset_relation = AssetRelation.find(params[:id])
        @locaiton = @asset_relation.try(:asset).try(:location)
        @reconstruction = @asset_relation.reconstruction
        @asset_relation_id = @asset_relation.id
        @asset_relation.destroy
        format.html do
          redirect_to [@reconstruction.location, @reconstruction], notice: 'Asset Removed from Reconstruction'
        end
        format.js do
          render json: { message: 'success', asset_relation_id: @asset_relation_id }, status: 200
        end
      else
        format.html do
          redirect_to [@reconstruction.location,@reconstruction], notice: 'Error removing asset from Reconstruction'
        end
        format.js do
          render json: { error: @asset_relation.errors.full_messages.join(',') }, status: 400
        end
      end
    end
  end

  private
  def set_items
    @reconstruction = Reconstruction.friendly.find(params[:reconstruction_id])
    @asset = Asset.find(params[:asset_id])
  end
end
