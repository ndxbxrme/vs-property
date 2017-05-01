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
  $scope.toggle = (offer) ->
    for o in $scope.getOffers()
      if o isnt offer
        o.open = false
      else if o.Notes.length
        o.open = not o.open
  $scope.loading = dezrez.loading