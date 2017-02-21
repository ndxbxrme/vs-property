'use strict'

superagent = require 'superagent'

module.exports = (ndx) ->
  ndx.database.on 'ready', ->
    apiUrl = process.env.API_URL or ndx.settings.API_URL
    apiKey = process.env.API_KEY or ndx.settings.API_KEY
    fetchProperties = ->
      fetchStcProperties = (pageNo, cb) ->
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
              property.stc = true
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
              return fetchStcProperties pageNo + 1, cb
          else
            return cb? err
        return
      fetchNonStcProperties = (pageNo, cb) ->
        superagent.post "#{apiUrl}search?APIKey=#{apiKey}"
        .set('Rezi-Api-Version', '1.0')
        .send
          MarketingFlags: 'ApprovedForMarketingWebsite'
          MinimumPrice: 0
          MaximumPrice: 9999999
          MinimumBedrooms: 0
          SortBy: 0
          PageSize: 2000
          IncludeStc: false
          BranchIdList: []
          PageNumber: pageNo
        .end (err, response) ->
          if not err and response.body.Collection     
            for property in response.body.Collection
              ndx.database.exec 'UPDATE tmpprops SET stc=false WHERE RoleId = ?', [property.RoleId], true
            if response.body.CurrentCount < response.body.PageSize
              return cb?()
            else
              return fetchNonStcProperties pageNo + 1, cb
          else
            return cb? err
        return
      ndx.database.exec 'DELETE FROM tmpprops', null, true
      fetchStcProperties 1, ->
        fetchNonStcProperties 1, ->
          tables = ndx.database.getDb() 
          tables.props.data = tables.tmpprops.data
          tables.tmpprops.data = []
          return
        return
    setInterval fetchProperties, 10 * 60 * 1000
    fetchProperties()