class Api::BaseController < ApplicationController
  def index
    render :json => {
      images_url: '/images', 
      artefacts_url: '/artefacts'
    }
  end
end