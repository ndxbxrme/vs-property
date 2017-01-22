'use strict'

angular.module 'vsProperty'
.controller 'PropertyCtrl', ($scope, $http) ->
  console.log 'property controller'
  $http.get '/api/dezrez/selling'
  .then (response) ->
    console.log 'response', response