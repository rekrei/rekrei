@rekrei.factory 'LocationPhotosProvider', [
  $resource
  ($resource) ->
  class LocationPhotos
    constructor: (location, reconstruction, page) ->
      @service = $resource("/locations/#{location}/images.json", {'params': {'page': page, 'show': 'all', 'reconstruction_slug': reconstruction)}})

    all: ->
      @service.query()
]
