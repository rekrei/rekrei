class LocationsController < ApplicationController

  def index
    @locations = Location.all
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.long
      marker.infowindow view_context.link_to location.name, location_path(location)
    end
  end

  def show
    @location = Location.friendly.find(params[:id])
    @reconstructions = @location.reconstructions.paginate per_page: 16, page: params[:page]
  end

end
