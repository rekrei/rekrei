@rekrei.controller 'LocationPhotosController', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $scope.currentLocationPage = 0
    $scope.allLocationPhotos = []
    $scope.totalLocationPhotos = 0
    $scope.locationPhotosPerPage = 12
    $scope.reconstruction = ""

    $scope.currentFlickrPage = 0
    $scope.flickrPhotos = []
    $scope.totalFlickrPhotos = 0
    $scope.flickrPhotosPerPage = 6
    $scope.distanceSlider =
      value: 10
      options:
        floor: 1
        ceil: 500

    $scope.$on 'slideEnded', ->
      getFlickrPhotos $scope.currentFlickrPage
      return

    processError = (status) ->
      switch status
        when 401 then alert 'Not Authorized, you need to login'
        when 404 then alert 'Item not found'
        when 500 then alert 'Oh no! Something went wrong!'

    getFlickrPhotos = (page) ->
      locationSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionLocation'].value
      $http.get("/locations/#{locationSlug}/flickr_photos", {'params': {'flickr_page': page, 'distance': $scope.distanceSlider.value}}).success((data, status, headers, config) ->
        $scope.currentFlickrPage = page
        $scope.flickrPhotos = data.photo
        $scope.totalFlickrPhotos = data.total
        return
      ).error (data, status, headers, config) ->
        processError(status)
        return
      return

    getFlickrPhotos 1

    $scope.flickrSliderChanged = () ->
      getFlickrPhotos $scope.currentFlickrPage
      return

    $scope.flickrPageChanged = (newPage) ->
      getFlickrPhotos newPage
      return

    $scope.addPhotoFromFlickr = (flickrImage) ->
      reconstructionSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionSlug'].value
      locationSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionLocation'].value
      $http.post("/locations/#{locationSlug}/images.json", {'flickr_url': flickrImage.url_o, 'flickr_metadata': flickrImage}).success((data, status, headers, config) ->
        $scope.allReconstructionPhotos.push data.photo
      ).error (data, status, headers, config) ->
        processError(status)

    $scope.locationPageChanged = (newPage) ->
      getAllLocationPhotos newPage
      return

    return
]
