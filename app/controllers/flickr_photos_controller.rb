class FlickrPhotosController < ActionController::Base
  before_action :set_flickr
  before_action :set_location, only: [:index]
  respond_to :json

  def index
    start_date = "1900-01-01 00:00:00"
    end_date = Date.today.strftime("%Y-%m-%d 00:00:00")

    args = {}
    args[:lat] = @location.lat
    args[:lon] = @location.long
    distance = params[:distance].to_i / 100.0 || 0.20
    args[:radius] = distance.to_s
    args[:radius_units] = "km"
    # args[:min_taken_date] = start_date
    # args[:max_taken_date] = end_date
    args[:sort] = "date-taken-desc"
    args[:accuracy] = 6
    args[:per_page] = 16
    args[:extras] = "description, license, date_upload, date_taken, owner_name, geo, tags, machine_tags, url_q, url_o"
    args[:page] = params[:flickr_page] || 1
    args[:license] = "1,2,4,5,7,8"

    images = @flickr.photos.search args
    render js: images.to_hash.to_json
  end

  def show
    if image = @flickr.photos.getInfo(photo_id: params[:id])
      photographer = image.owner.realname || image.owner.username
      render json: {url_small: FlickRaw.url_q(image), url_original: FlickRaw.url_o(image), id: image.id, flickr_url: FlickRaw.url_photopage(image), photographer: photographer, title: image.title}
    else
      render json: {status: 404, error: "Image not found"}
    end
  end

  private
  def set_flickr
    @flickr = FlickRaw::Flickr.new
  end

  def set_location
    @location = Location.friendly.find(params[:location_id])
  end
end
