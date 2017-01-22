'use strict'

angular.module 'vsProperty'
.config ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/',
    templateUrl: 'routes/dashboard/dashboard.html'
    controller: 'DashboardCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise false
  .when '/property',
    templateUrl: 'routes/property/property.html'
    controller: 'PropertyCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .when '/viewings',
    templateUrl: 'routes/viewings/viewings.html'
    controller: 'ViewingsCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .when '/feedback',
    templateUrl: 'routes/feedback/feedback.html'
    controller: 'FeedbackCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .when '/offers',
    templateUrl: 'routes/offers/offers.html'
    controller: 'OffersCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .otherwise
    redirectTo: '/'
  $locationProvider.html5Mode true