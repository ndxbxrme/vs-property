'use strict'

angular.module 'vsProperty'
.controller 'ViewingsCtrl', ($scope, dezrez) ->
  $scope.sort = '!date'
  dezrez.fetchViewings()
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading