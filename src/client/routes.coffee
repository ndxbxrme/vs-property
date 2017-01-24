'use strict'

angular.module 'vsProperty'
.config ($stateProvider, $locationProvider) ->
  $stateProvider
  .state 'dashboard',
    url: '/'
    templateUrl: 'routes/dashboard/dashboard.html'
    controller: 'DashboardCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise false
  .state 'properties',
    url: '/property'
    templateUrl: 'routes/property/properties.html'
    controller: 'PropertiesCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'viewings',
    url: '/viewings'
    templateUrl: 'routes/viewings/viewings.html'
    controller: 'ViewingsCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'feedback',
    url: '/feedback'
    templateUrl: 'routes/feedback/feedback.html'
    controller: 'FeedbackCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'offers',
    url: '/offers'
    templateUrl: 'routes/offers/offers.html'
    controller: 'OffersCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'profile',
    url: '/profile',
    templateUrl: 'routes/profile/profile.html'
    controller: 'ProfileCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'overview',
    url: '/:propertyID/overview',
    templateUrl: 'routes/property/overview.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'photos',
    url: '/:propertyID/photos',
    templateUrl: 'routes/property/photos.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'layout',
    url: '/:propertyID/layout',
    templateUrl: 'routes/property/layout.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'maps',
    url: '/:propertyID/maps',
    templateUrl: 'routes/property/maps.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'schools',
    url: '/:propertyID/schools',
    templateUrl: 'routes/property/schools.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'transport',
    url: '/:propertyID/transport',
    templateUrl: 'routes/property/transport.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'brochure',
    url: '/:propertyID/brochure',
    templateUrl: 'routes/property/brochure.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  .state 'taxbands',
    url: '/:propertyID/taxbands',
    templateUrl: 'routes/property/taxbands.html'
    controller: 'ViewCtrl'
    resolve:
      user: (auth) ->
        auth.getPromise true
  
    
  #.otherwise '/'
  $locationProvider.html5Mode true