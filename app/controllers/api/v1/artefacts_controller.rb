module Api
  module V1
    class ArtefactsController < Api::BaseController
      respond_to :json

      def index
        respond_with Artefact.all
      end

      def show
        if @artefact = Artefact.find_by_uuid(params[:id])
        else
          render :json => {status: 404, error: "Image not found"}
        end
      end
    end
  end
end