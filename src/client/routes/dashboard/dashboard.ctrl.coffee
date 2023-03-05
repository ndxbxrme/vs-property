'use strict'

angular.module 'vsProperty'
.controller 'DashboardCtrl', ($scope, auth, dezrez) ->
  $scope.auth = auth
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading
  
  $scope.getSalutation = ->
    hours = new Date().getHours()
    if hours < 12
      return 'Good Morning'
    else if hours < 17
      return 'Good Afternoon'
    'Good Evening'
  fetchDetails = () -> 
    properties = $scope.getProperties() or []
    for property in properties
      $http.post 'https://server.vitalspace.co.uk/dezrez/refresh/' + (property.RoleId or property.roleId)
  iv = $interval fetchDetails, 10 * 60 * 1000
  $scope.$on '$destroy', () -> 
    $interval.cancel iv