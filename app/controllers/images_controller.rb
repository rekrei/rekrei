class ImagesController < ApplicationController
  before_action :set_location, except: [:download]
  before_action :require_admin!, only: [:destroy]
  before_action :authenticate_user!, except: [:show, :index, :download]
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  # GET /images
  # GET /images.json
  def index
    @images = @location.images.unassigned_to_reconstruction.paginate(page: params[:page])
    @image = @location.images.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images.map(&:to_jq_image) }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @previous = @image.previous(@image)
    @next = @image.next(@image)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = @location.image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # POST /images
  # POST /images.json
  def create
    @image = @location.images.create(params: image_params)
    if @image.save
      # send success header
      render json: { message: 'success', fileID: @image.id }, status: 200
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @image.errors.full_messages.join(',') }, status: 400
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update_attributes(image_params)
        format.html do
          redirect_to [@location,@image], notice: 'Image was successfully updated.'
        end
        # format.json { head :no_content }
        format.json do
          render json: { files: [@image.to_jq_upload] },
                 status: :created, location: @image
        end
      else
        format.html { render action: 'edit' }
        format.json do
          render json: @image.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  def download
    @image = Image.find(params[:id])
    send_data File.read(@image.image.path),
              filename: @image.image_file_name,
              type: @image.image_content_type,
              disposition: 'attachment' if @image.image
  end

  private

  def set_location
    @location = Location.friendly.find(params[:location_id])
  end

  def set_image
    @image = @location.images.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:reconstruction_id, :image)
  end
end
