'use strict'

angular.module 'vsProperty'
.controller 'ProfileCtrl', ($scope, user) ->
  $scope.user = user