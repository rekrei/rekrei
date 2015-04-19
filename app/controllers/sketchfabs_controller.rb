class SketchfabsController < ApplicationController
  before_action :set_sketchfab, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_artefact, only: [:new, :create, :update]

  def new
    @sketchfab = @artefact.sketchfabs.build
  end

  def create
    if @artefact.sketchfabs.create(sketchfab_params)
      redirect_to artefact_path(@artefact)
    else

    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sketchfab
    @sketchfab = Sketchfab.find(params[:id])
  end

  def set_artefact
    @artefact = Artefact.find(params[:artefact_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sketchfab_params
    params.require(:sketchfab).permit(:bbcode).merge(user_id: current_user.id)
  end
end