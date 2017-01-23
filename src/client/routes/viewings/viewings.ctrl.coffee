'use strict'

angular.module 'vsProperty'
.controller 'ViewingsCtrl', ($scope, $http, dezrez) ->
  console.log 'waking up dezrez'
  dezrez.fetchViewings()