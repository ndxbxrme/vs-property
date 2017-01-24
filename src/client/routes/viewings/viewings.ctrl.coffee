'use strict'

angular.module 'vsProperty'
.controller 'ViewingsCtrl', ($scope, dezrez) ->
  dezrez.fetchViewings()
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading