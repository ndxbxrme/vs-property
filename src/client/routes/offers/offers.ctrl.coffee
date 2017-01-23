'use strict'

angular.module 'vsProperty'
.controller 'OffersCtrl', ($scope, dezrez) ->
  dezrez.fetchOffers()
  $scope.getProperties = dezrez.getProperties