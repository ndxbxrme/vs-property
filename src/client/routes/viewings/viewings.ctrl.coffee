'use strict'

angular.module 'vsProperty'
.controller 'ViewingsCtrl', ($scope, $interval, $http, dezrez) ->
  $scope.sort = '-date'
  dezrez.fetchViewings()
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading