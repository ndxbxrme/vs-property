(function() {
  'use strict';
  angular.module('vsProperty').config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
      templateUrl: 'routes/dashboard/dashboard.html',
      controller: 'DashboardCtrl'
    }).when('/property', {
      templateUrl: 'routes/property/property.html',
      controller: 'PropertyCtrl'
    }).when('/viewings', {
      templateUrl: 'routes/viewings/viewings.html',
      controller: 'ViewingsCtrl'
    }).when('/feedback', {
      templateUrl: 'routes/feedback/feedback.html',
      controller: 'FeedbackCtrl'
    }).when('/offers', {
      templateUrl: 'routes/offers/offers.html',
      controller: 'OffersCtrl'
    }).otherwise({
      redirectTo: '/'
    });
    return $locationProvider.html5Mode(true);
  });

}).call(this);

//# sourceMappingURL=routes.eb9c79ae.js.map
