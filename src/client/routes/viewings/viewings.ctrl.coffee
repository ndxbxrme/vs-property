'use strict'

angular.module 'vsProperty'
.controller 'ViewingsCtrl', ($scope, $interval, dezrez) ->
  $scope.sort = '-date'
  dezrez.fetchViewings()
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading
  fetchDetails = () -> 
    properties = $scope.getProperties() or []
    for property in properties
      $http.post 'https://server.vitalspace.co.uk/dezrez/refresh/' + (property.RoleId or property.roleId)
  iv = $interval fetchDetails, 10 * 60 * 1000
  fetchDetails()
  $scope.$on '$destroy', () -> 
    $interval.cancel iv