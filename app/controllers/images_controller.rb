class ImagesController < ApplicationController
  before_filter :require_admin!, only: [:destroy]
  before_filter :authenticate_user!, :except => [:show, :index]
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  # GET /images
  # GET /images.json
    # GET /images
  # GET /images.json
  def index
    @images = Image.unassigned_to_artefact

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images.map{|image| image.to_jq_image } }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @previous = @image.previous
    @next = @image.next
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.create(image_params)
    if @image.save
      # send success header
      render json: { message: "success", fileID: @image.id }, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
      #  will not interpret the response as an error:
      render json: { error: @image.errors.full_messages.join(',')}, :status => 400
    end 
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update_attributes(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        # format.json { head :no_content }
        format.json { render json: {files: [@image.to_jq_upload]}, status: :created, location: @image }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
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

  private

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:artefact_id, :image)
  end
end