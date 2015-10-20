@rekrei.controller 'LocationPhotosController', [
  '$scope'
  '$http'
  'LocationPhotos'
  ($scope, $http, LocationPhotos) ->
    getAllPhotos = (page) ->
      locationSlug = angular.element( document.querySelector('#location-photos') )[0].attributes['reconstructionLocation'].value
      reconstructionSlug = angular.element( document.querySelector('#location-photos') )[0].attributes['reconstructionSlug'].value
      data = LocationPhotos.query(locationSlug, reconstructionSlug, page)
      $scope.currentPage = data.current_page
      $scope.allPhotos = data.images
      $scope.totalPhotos = data.total_count
      $scope.photosPerPage = data.per_page
      $scope.reconstruction = data.reconstruction
      return


    $scope.currentPage = 0
    $scope.allPhotos = []
    $scope.totalPhotos = 0
    $scope.photosPerPage = 16
    $scope.reconstruction = ""

    getAllPhotos 1

    $scope.sliderChanged = () ->
      getAllPhotos $scope.currentPage
      return

    $scope.pageChanged = (newPage) ->
      getAllPhotos newPage
      return

    return
]
