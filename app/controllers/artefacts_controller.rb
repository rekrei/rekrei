class ArtefactsController < ApplicationController
  before_action :set_artefact, only: [:show, :edit, :update, :destroy]
  before_action :require_admin!, only: [:destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :redirect_to_home
  # GET /artefacts
  # GET /artefacts.json
  def index
    @artefacts = Artefact.paginate(page: params[:page])
  end

  # GET /artefacts/1
  # GET /artefacts/1.json
  def show
  end

  # GET /artefacts/new
  def new
    @artefact = Artefact.new
  end

  # GET /artefacts/1/edit
  def edit
  end

  # POST /artefacts
  # POST /artefacts.json
  def create
    @artefact = Artefact.new(artefact_params)
    respond_to do |format|
      if @artefact.save

        if params[:images]
          # The magic is here ;)
          params[:images].each do |image|
            @artefact.images.create(image: image)
          end
        end

        format.html { redirect_to @artefact, notice: 'Artefact was successfully created.' }
        format.json { render json: @artefact, status: :created, location: @artefact }
      else
        format.html { render action: 'new' }
        format.json { render json: @artefact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artefacts/1
  # PATCH/PUT /artefacts/1.json
  def update
    @artefact = Artefact.find(params[:id])

    respond_to do |format|
      if @artefact.update_attributes(artefact_params)
        if params[:images]
          # The magic is here ;)
          params[:images].each do |image|
            @artefact.images.create(image: image)
          end
        end
        format.html { redirect_to @artefact, notice: 'Asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @artefact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artefacts/1
  # DELETE /artefacts/1.json
  def destroy
    @artefact.destroy
    respond_to do |format|
      format.html { redirect_to artefacts_url, notice: 'Artefact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def redirect_to_home
    redirect_to root_path, status: 301, notice: 'Artefacts are now reconstructions embedded in locations, please choose a location first.'
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_artefact
    @artefact = Artefact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def artefact_params
    params.require(:artefact).permit(:name, :description, :museum_identifier, :images)
  end
end
