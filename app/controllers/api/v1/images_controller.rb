module Api
  module V1
    class ImagesController < Api::BaseController
      respond_to :json

      def index
        @images = Image.all
      end

      def show
        @image = Image.find_by_uuid(params[:id])
      end
    end
  end
end