'use strict'

angular.module 'vsProperty'
.controller 'FeedbackCtrl', ($scope, $interval, $http, dezrez) ->
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
  $scope.$on '$destroy', ->
    for property in dezrez.getProperties()
      for v in property.viewings
        v.open = false
      