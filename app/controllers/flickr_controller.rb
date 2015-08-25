require 'flickr_fu'

class FlickrController < ActionController::Base
  def create
    flickr = Flickr.new('flickr.yml')
    redirect_to flickr.auth.url(:write)
  end

  def flickr_callback
    flickr = Flickr.new('flickr.yml')
    flickr.auth.frob = params[:frob]
    current_user.update_attribute :flickr_token, flickr.auth.token.token
  end

  def something_else_with_flickr
    flickr = Flickr.new(YAML.load_file('flickr.yml').merge(:token => current_user.flickr_token))
    # now you have full access on the user's data :)
  end
end
