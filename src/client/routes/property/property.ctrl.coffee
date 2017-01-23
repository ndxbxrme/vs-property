'use strict'

angular.module 'vsProperty'
.controller 'PropertyCtrl', ($scope, $http) ->
  $http.get '/api/dezrez/selling'
  .then (response) ->
    console.log 'response', response