'use strict'

angular.module 'vsProperty'
.controller 'PropertiesCtrl', ($scope, $interval, dezrez) ->
  $scope.loading = dezrez.loading
  $scope.getProperties = dezrez.getProperties
  $scope.getFeedbackCount = (property) ->
    count = 0
    for viewing in property.viewings
      count += viewing.Feedback.length
    count
  fetchDetails = () -> 
    properties = $scope.getProperties() or []
    for property in properties
      $http.post 'https://server.vitalspace.co.uk/dezrez/refresh/' + (property.RoleId or property.roleId)
  iv = $interval fetchDetails, 10 * 60 * 1000
  fetchDetails()
  $scope.$on '$destroy', () -> 
    $interval.cancel iv