'use strict'

angular.module 'vsProperty'
.controller 'OffersCtrl', ($scope, dezrez) ->
  $scope.sort = '!date'
  dezrez.fetchOffers()
  $scope.getOffers = dezrez.getOffers
  $scope.loading = dezrez.loading