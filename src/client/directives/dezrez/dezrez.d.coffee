angular.module 'vsProperty'
.directive 'dezrez', (auth, alert, $http, $location) ->
  restrict: 'AE'
  templateUrl: 'directives/dezrez/dezrez.html'
  replace: true
  scope: {}
  link: (scope, elem) ->
    scope.auth = auth
    scope.selectDezrezUser = (user) ->
      $http.post '/api/dezrez/update', dezrez:user
      .then (response) ->
        alert.log 'Successfully connected Dezrez account'
        auth.clearPotentialUsers()
        auth.getUser().dezrez = user
        $location.path '/'
    scope.findEmail = ->
      auth.getDezrezPromise scope.dezrezEmail
      .then ->
        alert.log 'Successfully connected Dezrez account'
      , ->
        alert.log 'Could not find Dezrez user'
      