(function() {
  'use strict';
  angular.module('vsProperty').directive('header', function($route) {
    return {
      restrict: 'AE',
      templateUrl: 'directives/header/header.html',
      replace: true,
      link: function(scope, elem) {
        return scope.isSelected = function(route) {
          if ($route && $route.current) {
            return route === $route.current.$$route.originalPath;
          }
          return false;
        };
      }
    };
  });

}).call(this);

//# sourceMappingURL=header.b01f9757.js.map
