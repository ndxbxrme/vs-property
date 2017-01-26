'use strict'

angular.module 'vsProperty'
.directive 'propertyStatusBar', ->
  restrict: 'AE'
  templateUrl: 'directives/property-status-bar/property-status-bar.html'
  replace: true