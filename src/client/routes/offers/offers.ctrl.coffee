'use strict'

angular.module 'vsProperty'
.controller 'OffersCtrl', ($scope, dezrez) ->
  dezrez.fetchOffers()
  $scope.getOffers = dezrez.getOffers
  $scope.loading = dezrez.loading