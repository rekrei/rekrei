$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])

@rekrei = angular.module 'appRekrei', ['ngResource','angularUtils.directives.dirPagination','rzModule']
