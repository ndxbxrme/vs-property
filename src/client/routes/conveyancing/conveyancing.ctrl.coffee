'use strict'

angular.module 'vsProperty'
.controller 'ConveyancingCtrl', ($scope, dezrez) ->
  $('#whytEmbed').detach().appendTo('#whytPlaceholder')
  $scope.$on '$destroy', ->
    $('#whytEmbed').detach().appendTo('#whytDock')
  $scope.getProperties = dezrez.getProperties