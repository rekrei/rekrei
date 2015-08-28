class Api::BaseController < ApplicationController
  def index
    render :json => {
      v1: {
        images_url: '/images',
        artefacts_url: '/artefacts'
      },
      v2: {
        images_url: '/images',
        reconstructions_url: '/reconstruction'
      }
    }
  end
end
