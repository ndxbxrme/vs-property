'use strict'

angular.module 'vsProperty'
.controller 'OffersCtrl', ($scope, dezrez) ->
  $scope.sort = '-date'
  dezrez.fetchOffers()
  $scope.getOffers = ->
    offers = dezrez.getOffers()
    i = offers.length
    while i-- > 0
      if not offers[i].prop.details.Address
        offers.splice i, 1
    offers
  $scope.loading = dezrez.loading