'use strict'

angular.module 'vsProperty'
.factory 'auth', ($http, $q, $timeout, $location, dezrez) ->
  user = null
  potentialUsers = []
  loading = false
  getDezrezPromise = (defer, needsDezrez, email) ->
    if not potentialUsers.length
      loading = true
      if user.dezrez and user.dezrez.Id
        loading = false
        defer.resolve user
      else
        $http
          method: 'POST'
          url: '/api/dezrez/email'
          data:
            email:email or user.email
        .then (data) ->
          loading = false
          if data.data and data.data.length and data.data isnt 'error'
            if data.data.length is 1
              user.dezrez = data.data[0]
            else
              potentialUsers = data.data
          if needsDezrez and not user.dezrez
            defer.reject {}
          else
            defer.resolve user
        , ->
          loading = false
          if needsDezrez and not user.dezrez
            defer.reject {}
          else
            defer.resolve user
    else
      loading = false
      defer.reject {}
  getUserPromise = (needsDezrez) ->
    loading = true
    defer = $q.defer()
    if user
      getDezrezPromise defer, needsDezrez
    else
      $http.post '/api/refresh-login'
      .then (data) ->
        if data and data.data isnt 'error'
          user = data.data
          getDezrezPromise defer, needsDezrez
          if user.dezrez and not dezrez.loading('all')
            dezrez.refresh()
        else 
          loading = false
          user = null
          defer.reject {}
      , ->
        loading = false
        user = null
        defer.reject {}
    defer.promise
  getPromise: (needsDezrez) ->
    defer = $q.defer()
    getUserPromise needsDezrez
    .then ->
      defer.resolve user
    , ->
      defer.reject {}
      $location.path '/'
    defer.promise
  getDezrezPromise: (email) ->
    defer = $q.defer()
    getDezrezPromise defer, true, email
    defer.promise
  getUser: ->
    user
  getDezrezUser: ->
    if user and user.dezrez then user else null
  getPotentialUsers: ->
    potentialUsers
  clearPotentialUsers: ->
    potentialUsers = []
  loading: ->
    loading