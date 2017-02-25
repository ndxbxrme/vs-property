'use strict'

superagent = require 'superagent'

module.exports = (ndx) ->
  ndx.database.on 'ready', ->
    apiUrl = process.env.API_URL or ndx.settings.API_URL
    apiKey = process.env.API_KEY or ndx.settings.API_KEY
    fetchProperties = (pageNo, cb) ->
      superagent.post "#{apiUrl}search?APIKey=#{apiKey}"
      .set('Rezi-Api-Version', '1.0')
      .send
        MarketingFlags: 'ApprovedForMarketingWebsite'
        MinimumPrice: 0
        MaximumPrice: 9999999
        MinimumBedrooms: 0
        SortBy: 0
        PageSize: 2000
        IncludeStc: true
        BranchIdList: []
        PageNumber: pageNo
      .end (err, response) ->
        if not err and response.body.Collection
          for property in response.body.Collection
            property.stc = property.RoleStatus.SystemName is 'OfferAccepted'
            property.NoRooms = 0
            if property.RoomCountsDescription
              if property.RoomCountsDescription.Bedrooms then property.NoRooms += property.RoomCountsDescription.Bedrooms
              if property.RoomCountsDescription.Bathrooms then property.NoRooms += property.RoomCountsDescription.Bathrooms
              if property.RoomCountsDescription.Receptions then property.NoRooms += property.RoomCountsDescription.Receptions
              if property.RoomCountsDescription.Others then property.NoRooms += property.RoomCountsDescription.Others
            property.SearchField = "#{property.Address.Street}|#{property.Address.Town}|#{property.Address.Locality}|#{property.Address.Postcode}|#{property.Address.County}"
            ndx.database.exec 'INSERT INTO tmpprops VALUES ?', [property], true
          if response.body.CurrentCount < response.body.PageSize
            return cb?()
          else
            return fetchProperties pageNo + 1, cb
        else
          return cb? err
      return
    doFetchProperties = ->
      fetchProperties 1, ->
        tables = ndx.database.getDb() 
        if tables.tmpprops.data.length
          #console.log 'inserting', tables.tmpprops.data.length
          tables.props.data = tables.tmpprops.data
        tables.tmpprops.data = []
        return
      return
    setInterval doFetchProperties, 5 * 60 * 1000
    doFetchProperties()