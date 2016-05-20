module Api
  module V2
    class LocationsController < Api::BaseController
      respond_to :json

      def index
        @locations = Rails.cache.fetch("all_locations", expires_in: 24.hours) do
          Location.all
        end
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
