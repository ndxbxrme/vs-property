'use strict'

angular.module 'vsProperty'
.controller 'DashboardCtrl', ($scope, auth) ->
  $scope.auth = auth