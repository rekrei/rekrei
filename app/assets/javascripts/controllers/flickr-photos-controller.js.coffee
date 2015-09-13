@rekrei.controller 'FlickrPhotosController', [
  '$scope'
  '$http'
  ($scope, $http) ->

    getFlickrPhotos = (page) ->
      $http.get('/locations/palmyra/flickr_photos', {'params': {'flickr_page': page}}).success((data, status, headers, config) ->
        $scope.flickrPhotos = data.photo
        $scope.totalFlickrPhotos = data.total
        return
      ).error (data, status, headers, config) ->
        alert 'There was a problem: ' + status
        return
      return

    $scope.flickrPhotos = []
    $scope.totalFlickrPhotos = 0
    $scope.flickrPhotosPerPage = 16

    getFlickrPhotos 1

    $scope.pageChanged = (newPage) ->
      getFlickrPhotos newPage
      return

    return
]
