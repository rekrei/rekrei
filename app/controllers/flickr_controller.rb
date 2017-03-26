class FlickrController < ApplicationController

  def create
    flickr = FlickRaw::Flickr.new
    token = flickr.get_request_token(oauth_callback: flickr_callback_url)
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'read')
    session[:flickr_token] = token
    session[:flickr_url] = request.referer
    redirect_to auth_url
  end

  def callback
    flickr = FlickRaw::Flickr.new

    request_token = session[:flickr_token]
    oauth_token = params[:oauth_token]
    oauth_verifier = params[:oauth_verifier]

    raw_token = flickr.get_access_token(request_token['oauth_token'], request_token['oauth_token_secret'], oauth_verifier)
    # raw_token is a hash like this {"user_nsid"=>"92023420%40N00", "oauth_token_secret"=>"XXXXXX", "username"=>"boncey", "fullname"=>"Darren%20Greaves", "oauth_token"=>"XXXXXX"}
    # Use URI.unescape on the nsid and name parameters

    oauth_token = raw_token["oauth_token"]
    oauth_token_secret = raw_token["oauth_token_secret"]
    # Store the oauth_token and oauth_token_secret in session or database
    #   and attach to a Flickraw instance before calling any methods requiring authentication

    # Attach the tokens to your flickr instance - you can now make authenticated calls with the flickr object
    current_user.update_attributes flickr_oauth_token: oauth_token, flickr_oauth_secret: oauth_token_secret

    redirect_to session[:flickr_url]
  end

end
