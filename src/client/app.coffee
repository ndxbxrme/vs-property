'use strict'

angular.module 'vsProperty', [
  'ngRoute'
  'ui.router'
  'propertyEngine'
]
.run ($rootScope, $state, $stateParams) ->
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