@rekrei.controller 'ReconstructionPhotosController', [
  '$scope'
  '$http'
  ($scope, $http) ->
    $scope.currentReconstructionPage = 0
    $scope.allReconstructionPhotos = []
    $scope.totalReconstrucionPhotos = 0
    $scope.reconstructionPhotosPerPage = 16
    $scope.reconstruction = ""

    $scope.currentLocaltionPage = 0
    $scope.allLocationPhotos = []
    $scope.totalLocationPhotos = 0
    $scope.locationPhotosPerPage = 16
    $scope.reconstruction = ""

    $scope.currentFlickrPage = 0
    $scope.flickrPhotos = []
    $scope.totalFlickrPhotos = 0
    $scope.flickrPhotosPerPage = 16
    $scope.distanceSlider =
      min: 10
      max: 250
      ceil: 250
      floor: 10
      value: 20

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
      getFlickrPhotos $scope.currentPage
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
        $scope.totalReconstrucionPhotos = data.total_count
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
      locationSlug = angular.element( document.querySelector('#reconstruction-photos') )[0].attributes['reconstructionLocation'].value
      $http.post("/locations/#{locationSlug}/images.json", {'flickr_url': flickrImage.url_o, 'flickr_metadata': flickrImage}).success((data, status, headers, config) ->
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
