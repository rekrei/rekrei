class FlickrPhotosController < ActionController::Base
  before_action :set_flickr
  before_action :set_location, only: [:index]
  respond_to :json

  def index
    start_date = "1800-01-01 00:00:00"
    end_date = Date.today.strftime("%Y-%m-%d 00:00:00")

    args = {}
    args[:lat] = @location.lat
    args[:lon] = @location.long
    distance = params[:distance].to_i / 100.0 || 0.20
    args[:radius] = distance.to_s
    args[:radius_units] = "km"
    args[:sort] = "date-taken-desc"
    args[:accuracy] = 6
    args[:per_page] = 6
    args[:extras] = "description, license, date_upload, date_taken, owner_name, geo, tags, machine_tags, url_q, url_o"
    args[:page] = params[:flickr_page] || 1
    args[:license] = "1,2,4,5,7,8"

    images = @flickr.photos.search args
    render js: images.to_hash.to_json
  end

  private
  def set_flickr
    @flickr = FlickRaw::Flickr.new
  end

  def set_location
    @location = Location.friendly.find(params[:location_id])
  end

  def location_photos_

  end
end
