class AssetRelationsController < ApplicationController
  # skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_items, only: [:create]

  before_action do |controller|
    authenticate_user! if controller.request.format.html?
  end

  before_action do |controller|
    require_user! if controller.request.format.json?
  end

  def create
    respond_to do |format|
      if @asset_relation = AssetRelation.create(asset: @asset, reconstruction: @reconstruction)
        format.html do
          redirect_to location_reconstruction_path(@reconstruction.location.slug, @reconstruction), notice: 'Asset Added to Reconstruction'
        end
        format.json do
          render json: { message: 'success', asset_relation_id: @asset_relation.id, asset_id: @asset.id }, status: 200
        end
      else
        format.html do
          redirect_to [@reconstruction.location,@reconstruction], notice: 'Error adding asset to Reconstruction'
        end
        format.json do
          render json: { error: @asset_relation.errors.full_messages.join(',') }, status: 400
        end
      end
    end
  end

  def destroy
    respond_to do |format|
      if params[:reconstruction_slug]
        reconstruction = Reconstruction.friendly.find(params[:reconstruction_slug])
        @asset_relation = AssetRelation.where(reconstruction_id: reconstruction.id, asset_id: params[:id]).first
      else
        @asset_relation = AssetRelation.find(params[:id])
      end
      if @asset_relation
        @asset_relation_id = @asset_relation.id
        @reconstruction = @asset_relation.reconstruction
        @asset_relation.destroy
        format.html do
          redirect_to [@reconstruction.location, @reconstruction], notice: 'Asset Removed from Reconstruction'
        end
        format.json do
          render json: { message: 'success', asset_relation_id: @asset_relation.id }, status: 200
        end
      else
        format.html do
          redirect_to [@reconstruction.location,@reconstruction], notice: 'Error removing asset from Reconstruction'
        end
        format.json do
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

  protected
  def json_request?
    request.format.json?
  end
end
