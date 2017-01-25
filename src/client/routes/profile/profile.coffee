'use strict'

angular.module 'vsProperty'
.controller 'ProfileCtrl', ($scope, $http, user) ->
  status = ''
  $scope.user = user
  $scope.status = (name) ->
    status is name
  $scope.setStatus = (name) ->
    $scope.submitted = false
    $scope.error = null
    status = name
  $scope.updatePassword = ->
    $scope.submitted = true
    if $scope.upf.$valid
      $http.post '/api/update-password',
        oldPassword: $scope.oldPassword
        newPassword: $scope.newPassword
      .then (response) ->
        if response.error
          $scope.error = response.error
        else
          #pop a message
          console.log 'password updated'
        $scope.submitted = false
      , ->
        $scope.error = 'Server error'
        $scope.submitted = false