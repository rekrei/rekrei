@rekrei.controller 'FlickrPhotosController', [
  '$scope'
  '$http'
  ($scope, $http) ->

    getFlickrPhotos = (page) ->
      $http.get('/locations/palmyra/flickr_photos', {'params': {'flickr_page': page, 'distance': $scope.distanceSlider.value}}).success((data, status, headers, config) ->
        $scope.currentPage = page
        $scope.flickrPhotos = data.photo
        $scope.totalFlickrPhotos = data.total
        return
      ).error (data, status, headers, config) ->
        alert 'There was a problem: ' + status
        return
      return

    $scope.distanceSlider =
      min: 10
      max: 250
      ceil: 250
      floor: 10
      value: 20

    $scope.currentPage = 0
    $scope.flickrPhotos = []
    $scope.totalFlickrPhotos = 0
    $scope.flickrPhotosPerPage = 16

    getFlickrPhotos 1

    $scope.sliderChanged = () ->
      getFlickrPhotos $scope.currentPage
      return

    $scope.pageChanged = (newPage) ->
      getFlickrPhotos newPage
      return

    return
]
