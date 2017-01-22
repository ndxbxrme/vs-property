'use strict'

angular.module 'vsProperty'
.controller 'ViewingsCtrl', ($scope, user) ->
  if user
    console.log 'viewings controller'