@rekrei.factory 'FlickrPhoto', ($resource) ->
  class FlickrPhoto
    constructor: () ->
      @service = $resource('/locations/palmyra/flickr_photos',{})

    all: ->
      @service.query()
