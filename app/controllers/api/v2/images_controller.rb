module Api
  module V2
    class ImagesController < Api::BaseController
      respond_to :json

      def index
        @images = Image.all
      end

      def show
        if @image = Image.find_by_uuid(params[:id])
        else
          render :json => {status: 404, error: "Image not found"}
        end
      end
    end
  end
end
