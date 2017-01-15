(function() {
  'use strict';
  angular.module('vsProperty', ['ngRoute', 'ngTouch']).config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
      templateUrl: 'routes/main/main.html',
      controller: 'MainCtrl'
    }).otherwise({
      redirectTo: '/'
    });
    return $locationProvider.html5Mode(true);
  });

}).call(this);

//# sourceMappingURL=app.fb9e48d9.js.map
