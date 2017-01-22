'use strict'

angular.module 'vsProperty'
.directive 'login', (auth, $http, $location) ->
  restrict: 'AE'
  templateUrl: 'directives/login/login.html'
  replace: true
  scope: {}
  link: (scope, elem) ->
    scope.getUser = auth.getUser
    
    scope.login = ->
      scope.submitted = true
      if scope.loginForm.$valid
        $http.post '/api/login',
          email: scope.email
          password: scope.password
        .then (response) ->
          if response.data.error
            scope.message = response.data.message[0]
            scope.submitted = false
          else
            auth.getPromise()
            .then ->
              $location.path '/'
        , ->
          scope.submitted = false
    scope.signup = ->
      scope.submitted = true
      if scope.loginForm.$valid
        $http.post '/api/signup',
          email: scope.email
          password: scope.password
        .then (response) ->
          if response.data.error
            scope.message = response.data.message[0]
            scope.submitted = false
          else
            auth.getPromise()
            .then ->
              $location.path '/'
        , ->
          scope.submitted = false