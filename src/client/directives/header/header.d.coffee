'use strict'

angular.module 'vsProperty'
.directive 'header', ($route) ->
  restrict: 'AE'
  templateUrl: 'directives/header/header.html'
  replace: true
  link: (scope, elem) ->
    scope.isSelected = (route) ->
      if $route and $route.current
        return route is $route.current.$$route.originalPath
      false