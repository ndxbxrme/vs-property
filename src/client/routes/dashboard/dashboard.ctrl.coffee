'use strict'

angular.module 'vsProperty'
.controller 'DashboardCtrl', ($scope, auth, dezrez) ->
  $scope.auth = auth