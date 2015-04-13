module Api
  module V1
    class ImagesController < Api::BaseController
      respond_to :json

      def index
        respond_with Image.all
      end

      def show
        respond_with Image.find(params[:id])
      end
    end
  end
end