'use strict'

angular.module 'vsProperty'
.controller 'ConveyancingCtrl', ($scope, dezrez) ->
  $('#whytEmbed').detach().appendTo('#whytPlaceholder')
  $scope.getProperties = dezrez.getProperties