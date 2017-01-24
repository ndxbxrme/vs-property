'use strict'

angular.module 'vsProperty'
.controller 'PropertiesCtrl', ($scope, dezrez) ->
  $scope.getProperties = dezrez.getProperties