module Api
  module V2
    class ReconstructionsController < Api::BaseController
      respond_to :json

      def index
        @reconstructions = Reconstruction.all
      end

      def show
        if @reconstruction = Reconstruction.find_by_uuid(params[:id])
        else
          render :json => {status: 404, error: "Reconstrucion not found"}
        end
      end
    end
  end
end
