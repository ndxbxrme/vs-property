'use strict'

angular.module 'vsProperty'
.controller 'ReportsCtrl', ($scope, auth, dezrez) ->
  $scope.auth = auth
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading
  
  $scope.getFeedbackCount = (property) ->
    count = 0
    for viewing in property.viewings
      count += viewing.Feedback.length
    count