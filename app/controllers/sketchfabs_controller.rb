class SketchfabsController < ApplicationController
  before_action :set_sketchfab, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_reconstruction, only: [:new, :create, :update]

  def new
    @sketchfab = @reconstruction.sketchfabs.build
  end

  def create
    if @reconstruction.sketchfabs.create(sketchfab_params)
      redirect_to location_reconstruction_path(@reconstruction.location, @reconstruction)
    else

    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sketchfab
    @sketchfab = Sketchfab.find(params[:id])
  end

  def set_reconstruction
    @reconstruction = Reconstruction.friendly.find(params[:reconstruction_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sketchfab_params
    params.require(:sketchfab).permit(:bbcode).merge(user_id: current_user.id)
  end
end