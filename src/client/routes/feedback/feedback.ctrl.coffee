'use strict'

angular.module 'vsProperty'
.controller 'FeedbackCtrl', ($scope, dezrez) ->
  $scope.sort = '-date'
  dezrez.fetchViewings()
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading
  $scope.toggle = (viewing) ->
    for property in dezrez.getProperties()
      for v in property.viewings
        if v isnt viewing
          v.open = false
        else if v.Feedback.length or v.Notes.length
          v.open = not v.open
  fetchDetails = () -> 
    properties = $scope.getProperties() or []
    for property in properties
      $http.post 'https://server.vitalspace.co.uk/dezrez/refresh/' + (property.RoleId or property.roleId)
  iv = $interval fetchDetails, 10 * 60 * 1000
  $scope.$on '$destroy', ->
    $interval.cancel iv
    for property in dezrez.getProperties()
      for v in property.viewings
        v.open = false
      