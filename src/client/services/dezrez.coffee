'use strict'

angular.module 'vsProperty'
.factory 'dezrez', ($http) ->
  loading =
    selling: false
    letting: false
    viewings: false
    offers: false
  properties = []
  offers = []
  getProperty = (id) ->
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
    property.loading = true
    $http.get '/api/property/3775830'# + property.id
    .then (response) ->
      property.loading = false
      if response.data and not response.data.error
        property.details = response.data
        property.error = false
        property.loadingEvents = true
        $http.get "/api/dezrez/property/#{property.id}/events"
        .then (response) ->
          if response.data and response.data.Collection and response.data.Collection.length
            property.mailouts = 0
            for event in response.data.Collection
              if event.EventType.Name is 'Mailout'
                property.mailouts += event.Properties.length
          property.loadingEvents = false
        ,
          property.loadingEvents = false
      else
        property.error = true
    , ->
      property.loading = false
      property.error = true
  fetchViewings = ->
    if not loading.viewings
      loading.viewings = true
      $http.get '/api/dezrez/role/viewings'
      .then (response) ->
        loading.viewings = false
        if response.data and not response.data.error
          openIds = []
          for property in properties
            for viewing in property.viewings
              if viewing.open then openIds.push viewing.Id
            property.viewings = []
          for viewing in response.data
            viewing.date = new Date(viewing.StartDate).valueOf()
            viewing.AccompaniedBy = []
            for group in viewing.AttendingGroups
              if group.Type.Name isnt 'Owner'
                for person in group.AttendingPeople
                  if not viewing.MainContact
                    viewing.MainContact =
                      name: person.ContactName
                      email: person.PrimaryEmail
                      sortname: person.LastName + person.FirstName
                  else
                    viewing.AccompaniedBy.push 
                      name: person.ContactName
                      email: person.PrimaryEmail
            if openIds.indexOf(viewing.Id) isnt -1
              viewing.open = true
            prop = getProperty viewing.MarketingRoleId
            prop.viewings.push viewing
      , ->
        loading.viewings = false
  fetchOffers = ->
    if not loading.offers
      loading.offers = true
      $http.get '/api/dezrez/role/offers'
      .then (response) ->
        loading.offers = false
        if response.data and not response.data.error
          offers = []
          for property in properties
            property.offers = []
          for offer in response.data
            offer.date = new Date(offer.DateTime).valueOf()
            prop = getProperty offer.MarketingRoleId
            prop.offers.push offer
            offers.push offer
      , ->
        loading.offers = false
  refresh = ->
    loading.selling = true
    properties = []
    $http.get '/api/dezrez/property/list/selling'
    .then (response) ->
      loading.selling = false
      if response.data and not response.data.error
        for property in response.data.Collection
          prop = getProperty property.Id
          prop.type = 'selling'
    , ->
      loading.selling = false
    $http.get '/api/dezrez/property/list/letting'
    .then (response) ->
      loading.letting = false
      if response.data and not response.data.error
        for property in response.data.Collection
          prop = getProperty property.Id
          prop.type = 'letting'
    , ->
      loading.letting = false
    fetchViewings()
    fetchOffers()
  getProperties: ->
    properties
  getProperty: (id) ->
    getProperty id
  getOffers: ->
    offers
  fetchViewings: fetchViewings
  fetchOffers: fetchOffers
  refresh: refresh
  loading: (type) ->
    if type is 'properties'
      return loading.selling or loading.letting
    if type is 'all'
      return loading.selling or loading.letting or loading.viewings or loading.offers
    loading[type]