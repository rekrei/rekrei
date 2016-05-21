class ReconstructionsController < ApplicationController
  before_action :set_location
  before_action :set_reconstruction, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:destroy]
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @reconstructions = @location.reconstructions.paginate per_page: 16, page: params[:reconstructions_page]
  end

  def show
  end

  def edit
    @image = @reconstruction.cover_image || @reconstruction.images.first || nil
  end

  def update
    respond_to do |format|
      if @reconstruction.update_attributes(reconstruction_params)
        @image = Image.find(reconstruction_params[:cover_image_id])
        @reconstruction.cover_image = @image
        @reconstruction.save

        if params[:images]
          # The magic is here ;)
          params[:images].each do |image|
            @reconstruction.images.create(image: image, location_id: @location.id)
          end
        end
        format.html { redirect_to [@location, @reconstruction], notice: 'Reconstruction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @reconstruction.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    if params[:image_id]
      @image = Image.find(params[:image_id])
      @reconstruction = Reconstruction.new(cover_image: @image, location: @location)
    else
      @reconstruction = Reconstruction.new(location: @location)
    end
  end

  def create
    @image = Image.find(reconstruction_params[:cover_image_id]) if reconstruction_params[:cover_image_id]
    @reconstruction = Reconstruction.new reconstruction_params
    @reconstruction.location = @location
    @reconstruction.cover_image = @image if @image

    respond_to do |format|
      if @reconstruction.save
        @reconstruction.asset_relations.create(asset: @image)
        format.html { redirect_to [@location, @reconstruction], notice: 'Reconstruction was successfully created.' }
        format.json { render json: @reconstruction, status: :created, location: @reconstruction }
      else
        format.html { render action: 'new' }
        format.json { render json: @reconstruction.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_location
    @location = Location.friendly.find(params[:location_id])
  end

  def set_reconstruction
    @reconstruction = @location.reconstructions.friendly.find(params[:id])
  end

  def reconstruction_params
    params.require(:reconstruction).permit(:name, :description, :images, :cover_image_id)
  end
end
