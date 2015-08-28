module Api
  module V2
    class LocationsController < Api::BaseController
      respond_to :json

      def index
        @locations = Location.all
      end

      def show
        if @location = Location.find_by_uuid(params[:id])
        else
          render :json => {status: 404, error: "Location not found"}
        end
      end
    end
  end
end
