module Api
  module V1
    class ArtefactsController < Api::BaseController
      respond_to :json

      def index
        respond_with Artefact.all
      end

      def show
        @artefact = Artefact.find_by_uuid(params[:id])
      end
    end
  end
end