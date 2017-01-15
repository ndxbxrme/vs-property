'use strict'

angular.module 'vsProperty', [
  'ngRoute'
  'ngTouch'
]
.config ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/',
    templateUrl: 'routes/main/main.html'
    controller: 'MainCtrl'
  .otherwise
    redirectTo: '/'
  $locationProvider.html5Mode true