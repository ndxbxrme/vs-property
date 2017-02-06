'use strict'

angular.module 'vsProperty', [
  'ngRoute'
  'ui.router'
  'propertyEngine'
  'ui.gravatar'
]
.config (gravatarServiceProvider) ->
  gravatarServiceProvider.defaults =
    size: 16
    "default": 'mm'
    rating: 'pg'
.run ($rootScope, $state, $stateParams, auth) ->
  auth.getPromise false
  $rootScope.$on '$stateChangeSuccess', ->
    propertyPages = [
      'overview'
      'photos'
      'layout'
      'maps'
      'schools'
      'transport'
      'brochure'
      'taxbands'
    ]
    $rootScope.propertyPage = propertyPages.indexOf($state.current.name) isnt -1
  root = Object.getPrototypeOf $rootScope
  root.sort = ''
  root.setSort = (field) ->
    if @sort.indexOf(field) is -1
      @sort = field
    else
      if @sort.indexOf('-') is 0
        @sort = field
      else
        @sort = '-' + field
  root.getSortClass = (field) ->
    "has-sort": true
    sorting: @sort.indexOf(field) isnt -1
    desc: @sort.indexOf('-') is 0