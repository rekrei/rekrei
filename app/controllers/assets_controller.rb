class AssetsController < ApplicationController
  # GET /assets
  # GET /assets.json
  def index
    @artefact = Artefact.find(params[:artefact_id])

    @assets = @artefact.assets

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assets }
    end
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
    @asset = Asset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.json
  def new
    @artefact = Artefact.find(params[:artefact_id])
    @asset = @artefact.assets.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    #@gallery = Gallery.find(params[:gallery_id])

    @asset = Asset.find(params[:id])
    # @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.json
  def create
    @artefact = Artefact.new(artefact_params)
    respond_to do |format|
      if @artefact.save

        if params[:assets]
          # The magic is here ;)
          params[:assets].each { |image|
            @artefact.assets.create(image: image)
          }
        end

        format.html { redirect_to @artefact, notice: 'Artefact was successfully created.' }
        format.json { render json: @artefact, status: :created, location: @artefact }
      else
        format.html { render action: "new" }
        format.json { render json: @artefact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.json
  def update
    @artefact = Artefact.find(params[:id])

    respond_to do |format|
      if @artefact.update_attributes(artefact_params)
        if params[:assets]
          # The magic is here ;)
          params[:assets].each { |image|
            @artefact.assets.create(image: image)
          }
        end
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def make_default
    @artefact = Artefact.find(params[:id])
    @asset = Asset.find(params[:asset_id])

    @artefact.cover = @asset.id
    @artefact.save

    respond_to do |format|
      format.js
    end
  end

  private

  def asset_params
    params.require(:asset).permit(:asset_id, :image)
  end
end