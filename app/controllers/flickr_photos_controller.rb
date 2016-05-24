class FlickrPhotosController < ActionController::Base
  before_action :set_flickr
  respond_to :json

  def index
    start_date = "1800-01-01 00:00:00"
    end_date = Date.today.strftime("%Y-%m-%d 00:00:00")

    @location = Location.friendly.find(params[:location_id]) if params[:location_id]

    args = {}
    args[:lat] = @location.lat if @location
    args[:lon] = @location.long if @location
    distance = params[:distance].to_i / 100.0 || 0.10 if params[:distance]
    args[:radius] = distance.to_s
    args[:radius_units] = "km"
    args[:sort] = "date-taken-desc"
    args[:accuracy] = 6
    args[:per_page] = 6
    args[:extras] = "description, license, date_upload, date_taken, owner_name, geo, tags, machine_tags, url_q, url_o"
    args[:page] = params[:flickr_page] || 1
    args[:license] = "1,2,4,5,7,8"
    args[:text] = params[:text] if params[:text]

    images = @flickr.photos.search args
    render js: images.to_hash.to_json
  end

  private
  def set_flickr
    @flickr = FlickRaw::Flickr.new
  end
end
