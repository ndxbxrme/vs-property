'use strict'

module.exports = (ndx) ->
  ndx.app.options '/api/search', (req, res) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    res.setHeader 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
    res.end()
  ndx.app.options '/api/property/:id', (req, res) ->
    res.setHeader 'Access-Control-Allow-Origin', '*'
    res.setHeader 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
    res.end()
  ndx.app.post '/api/search', (req, res) ->
    whereProps = []
    whereSql = ' true=true '
    if req.body.MinimumPrice
      whereSql += ' AND Price->PriceValue > ? '
      whereProps.push +req.body.MinimumPrice
    if req.body.MaximumPrice
      whereSql += ' AND Price->PriceValue < ? '
      whereProps.push +req.body.MaximumPrice
    if req.body.MinimumBedrooms
      whereSql += ' AND RoomCountsDescription->Bedrooms > ? '
      whereProps.push +req.body.MinimumBedrooms
    if req.body.MaximumBedrooms
      whereSql += ' AND RoomCountsDescription->Bedrooms < ? '
      whereProps.push +req.body.MaximumBedrooms
    if req.body.MinimumRooms
      whereSql += ' AND NoRooms > ? '
      whereProps.push +req.body.MinimumRooms
    if req.body.MaximumRooms
      whereSql += ' AND NoRooms < ? '
      whereProps.push +req.body.MaximumRooms
    if not req.body.IncludeStc
      whereSql += ' AND stc=false '
    if req.body.RoleType
      whereSql += ' AND RoleType->SystemName = ? '
      whereProps.push req.body.RoleType
    if req.body.Search
      whereSql += " AND Search LIKE '%#{req.body.Search.replace("'", '')}%' "
    sortby = 'Price->PriceValue'
    sortdir = 1
    limit = 0
    skip = 0
    if req.body.SortBy
      sortby = req.body.SortBy.replace '.', '->'
    if req.body.SortDir
      sortdir = req.body.SortDir
    if req.body.PageSize
      limit = +req.body.PageSize
    if req.body.PageNumber
      skip = (+req.body.PageNumber - 1) * limit
    totalProps = ndx.database.exec "SELECT * FROM props WHERE #{whereSql}", whereProps
    total = totalProps.length
    orderby = " ORDER BY #{sortby} #{if sortdir is 1 then 'ASC' else 'DESC'} "
    paging = " LIMIT #{limit} OFFSET #{skip} "
    props = ndx.database.exec "SELECT * FROM props WHERE #{whereSql} #{orderby} #{paging}", whereProps
    res.json
      TotalCount: total
      CurrentCount: props.length
      PageSize: limit
      PageNumber: Math.floor(skip / limit) + 1
      Collection: props
  ndx.app.get '/property/:id', (req, res) ->
    if req.params.id
      props = ndx.database.exec 'SELECT * FROM props WHERE RoleId=?', [req.params.id]
      if props and props.length
        property = props[0]
        similar = []
        if property.RoomCountsDescription and property.RoomCountsDescription.Bedrooms
          similar = ndx.database.exec 'SELECT * FROM props WHERE RoomCountsDescription->Bedrooms=? AND Price->PriceValue>? AND Price->PriceValue<? LIMIT 4', [
            property.RoomCountsDescription.Bedrooms
            property.Price.PriceValue * 0.85
            property.Price.PriceValue * 1.15
          ]
        superagent.get "#{apiUrl}#{req.params.id}?APIKey=#{apiKey}"
        .set 'Rezi-Api-Version', '1.0'
        .send()
        .end (err, response) ->
          if not err and response.body
            response.body.similar = similar
          res.json response.body
      else
        res.json
          error: 'no property found'
    else
      res.json
        error: 'no id'