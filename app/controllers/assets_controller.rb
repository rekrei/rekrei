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
    #@artefact = Artefact.find(params[:artefact_id])

    @asset = Asset.find(params[:id])
    # @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(params[:asset])

    if @asset.save
      respond_to do |format|
        format.html {
          render :json => [@asset.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@asset.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  # PUT /assets/1
  # PUT /assets/1.json
  def update

    @artefact = Artefact.find(params[:artefact_id])

    @asset = @artefact.assets.find(params[:id])

    respond_to do |format|
      if @asset.update_attributes(asset_params)
        format.html { redirect_to artefact_path(@artefact), notice: 'Asset was successfully updated.' }
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
    #@artefact = Artefact.find(params[:artefact_id])
    #@asset = @artefact.assets.find(params[:id])
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def make_default
    @asset = Asset.find(params[:id])
    @artefact = Artefact.find(params[:artefact_id])

    @artefact.cover = @asset.id
    @artefact.save

    respond_to do |format|
      format.js
    end
  end

  private

  def asset_params
    params.require(:asset).permit(:artefact_id, :image)
  end
end