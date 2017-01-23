'use strict'

angular.module 'vsProperty'
.factory 'dezrez', ($http) ->
  Property = ->
    @id = ''
    @details = ''
    @viewings = []
    @offers = []
  properties = []
  getProperty = (id) ->
    console.log 'get property', id
    for property in properties
      if property.id is id
        return property
    newProp = 
      id: id
      type: ''
      details: {}
      viewings: []
      offers: []
    fetchPropertyDetails newProp
    properties.push newProp
    newProp
  fetchPropertyDetails = (property) ->
    console.log 'fetch property details'
    $http.get '/api/dezrez/property/' + property.id
    .then (response) ->
      if response.data and not response.data.error
        property.details = response.data
  refresh = ->
    properties = []
    for type in ['selling', 'letting']
      $http.get '/api/dezrez/property/list/' + type
      .then (response) ->
        console.log response
        if response.data and not response.data.error
          for property in response.data.Collection
            prop = getProperty property.PropertyId
            prop.type = type
  refresh()
  fetchViewings: ->
    for property in properties
      property.viewings = []
    $http.get '/api/dezrez/role/viewings'
    .then (response) ->
      if response.data and not response.data.error
        for viewing in response.data
          prop = getProperty viewing.Property.Id
          prop.viewings.push viewing
  fetchOffers: ->
    for property in properties
      property.offers = []
    $http.get '/api/dezrez/role/offers'
    .then (response) ->
      if response.data and not response.data.error
        for offer in response.data
          prop = getProperty offer.Property.Id
          prop.offers.push offer
  getProperties: ->
    console.log 'getting properties', properties
    properties
  getProperty: (id) ->
    getProperty id