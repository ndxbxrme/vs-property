angular.module 'vsProperty'
.directive 'dezrez', (auth, $http, $location) ->
  restrict: 'AE'
  templateUrl: 'directives/dezrez/dezrez.html'
  replace: true
  scope: {}
  link: (scope, elem) ->
    scope.auth = auth
    scope.selectDezrezUser = (user) ->
      $http.post '/api/dezrez/update', dezrez:user
      .then (response) ->
        console.log 'update response', response
        auth.clearPotentialUsers()
        auth.getUser().dezrez = user
        $location.path '/'
    scope.findEmail = ->
      auth.getDezrezPromise scope.dezrezEmail
      