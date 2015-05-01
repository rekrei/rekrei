class ReconstructionsController < ApplicationController
  before_action :set_location
  before_action :set_reconstruction, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:destroy]
  before_action :authenticate_user!, except: [:show, :index]


  def show
  end

  def edit
  end

  def update
  end

  def new
  end

  def create
  end

  private
  def set_location
    @location = Location.friendly.find(params[:location_id])
  end

  def set_reconstruction
    @reconstruction = @location.reconstructions.friendly.find(params[:id])
  end

  def reconstruction_params
    params.require(:reconstruction).permit(:name, :description, :images)
  end
end