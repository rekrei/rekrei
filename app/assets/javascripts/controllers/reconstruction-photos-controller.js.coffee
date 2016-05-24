@rekrei.controller 'ReconstructionPhotosController', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $scope.currentReconstructionPage = 0
    $scope.allReconstructionPhotos = []
    $scope.totalReconstructionPhotos = 0
    $scope.reconstructionPhotosPerPage = 12
    $scope.reconstruction = ""

    $scope.currentLocationPage = 0
    $scope.allLocationPhotos = []
    $scope.totalLocationPhotos = 0
    $scope.locationPhotosPerPage = 12
    $scope.reconstruction = ""

    $scope.currentFlickrTextPage = 0
    $scope.flickrTextPhotos = []
    $scope.totalFlickrTextPhotos = 0
    $scope.flickrTextPhotosPerPage = 6

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

    getFlickrPhotosText = (page) ->
      $http.get("/flickr_photos", {'params': {'flickr_page': page, 'text': $scope.flickrTextSearch}}).success((data, status, headers, config) ->
        $scope.currentFlickrTextPage = page
        $scope.flickrTextPhotos = data.photo
        $scope.totalFlickrTextPhotos = data.total
        return
      ).error (data, status, headers, config) ->
        processError(status)
        return
      return

    $scope.searchForFlickrPhotos = ->
      getFlickrPhotosText 1

    $scope.flickrTextPageChanged = (newPage) ->
      getFlickrPhotosText newPage
      return

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

    getAllReconstructionPhotos = (page) ->
      locationSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionLocation'].value
      reconstructionSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionSlug'].value
      $http.get("/locations/#{locationSlug}/images.json", {'params': {'page': page, 'show': 'reconstruction', 'reconstruction_slug': reconstructionSlug}}).success((data, status, headers, config) ->
        $scope.currentReconstructionPage = data.current_page
        $scope.allReconstructionPhotos = data.images
        $scope.totalReconstructionPhotos = data.total_count
        $scope.reconstructionPhotosPerPage = data.per_page
        $scope.reconstruction = data.reconstruction
        return
      ).error (data, status, headers, config) ->
        processError(status)
        return
      return

    $scope.reconstructionPageChanged = (newPage) ->
      getAllReconstructionPhotos newPage
      return

    $scope.addPhotoFromFlickr = (flickrImage) ->
      reconstructionSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionSlug'].value
      locationSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionLocation'].value
      $http.post("/locations/#{locationSlug}/images.json", {'flickr_url': flickrImage.url_o, 'flickr_metadata': flickrImage, 'reconstruction_slug': reconstructionSlug}).success((data, status, headers, config) ->
        $scope.allReconstructionPhotos.push data.photo
      ).error (data, status, headers, config) ->
        processError(status)

    $scope.addReconstructionPhoto = (image) ->
      $http.post("/reconstructions/#{$scope.reconstruction}/asset_relations.json", {'asset_id': image.id}).success((data, status, headers, config) ->
        $scope.allReconstructionPhotos.push image
        indexForPhoto = $scope.allLocationPhotos.indexOf(image)
        $scope.allLocationPhotos.splice(indexForPhoto,1)
      ).error (data, status, headers, config) ->
        processError(status)

    $scope.removeImageFromReconstruction = (image,reconstruction) ->
      $http.delete("/asset_relations/#{image.id}.json", {params: {'reconstruction_slug': $scope.reconstruction}}).success((data, status, headers, config) ->
        $scope.allLocationPhotos.push image
        indexForPhoto = $scope.allReconstructionPhotos.indexOf(image)
        $scope.allReconstructionPhotos.splice(indexForPhoto,1)
      ).error (data, status, headers, config) ->
        processError(status)

    getAllReconstructionPhotos 1

    getAllLocationPhotos = (page) ->
      locationSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionLocation'].value
      reconstructionSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionSlug'].value
      $http.get("/locations/#{locationSlug}/images.json", {'params': {'page': page, 'show': 'all', 'reconstruction_slug': reconstructionSlug}}).success((data, status, headers, config) ->
        $scope.currentLocationPage = data.current_page
        $scope.allLocationPhotos = data.images
        $scope.totalLocationPhotos = data.total_count
        $scope.locationPhotosPerPage = data.per_page
        $scope.reconstruction = data.reconstruction
        return
      ).error (data, status, headers, config) ->
        processError(status)
        return
      return

    getAllLocationPhotos 1

    $scope.locationPageChanged = (newPage) ->
      getAllLocationPhotos newPage
      return

    return
]
