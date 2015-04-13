module Api
  module V1
    class ImagesController < Api::BaseController
      respond_to :json

      def index
        respond_with Image.all
      end

      def show
        @image = Image.find(params[:id])
      end
    end
  end
end