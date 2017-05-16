$(document).on 'page:load', ->
  $('[ng-app]').each ->
    module = $(this).attr('ng-app')
    angular.bootstrap(this, [module])

@rekrei = angular.module 'Rekrei', ['ngResource','angularUtils.directives.dirPagination','rzModule', 'Devise', 'ng-rails-csrf']

# @rekrei.config ["$httpProvider", ($httpProvider) ->
#   $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
# ]
