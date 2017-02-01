'use strict'
async = require 'async'

module.exports = (ndx) ->
  if process.env.REZI_ID and process.env.REZI_SECRET
    pageSize = 
      pageSize:2000
    updateUserDezrez = (dezrez, userId) ->
      ndx.database.exec 'UPDATE ' + ndx.settings.USER_TABLE + ' SET dezrez=? WHERE _id=?', [
        dezrez
        userId
      ]
    findByEmail = (email, userId, callback) ->
      ndx.dezrez.get 'people/findbyemail', 
        emailAddress:email
      , (err, body) ->
        if not err and body and body.length
          if body.length is 1
            updateUserDezrez body[0], userId
          callback body
        else
          callback error:'error'
    ndx.authorize = (req, res, next) ->
      if req.user
        next()
      else
        throw ndx.UNAUTHORIZED
    ndx.authorizeDezrez = (req, res, next) ->
      if req.user and req.user.dezrez
        next()
      else
        throw ndx.UNAUTHORIZED
      
    ndx.app.post '/api/dezrez/email', ndx.authorize,  (req, res) ->
      findByEmail req.body.email, req.user._id, (data) ->
        res.json data
    ndx.app.post '/api/dezrez/findbyemail', ndx.authorize, (req, res) ->
      findByEmail req.body.email, req.user._id, (data) ->
        res.json data
    ndx.app.post '/api/dezrez/update', ndx.authorize, (req, res) ->
      updateUserDezrez req.body.dezrez, req.user._id
      res.end 'OK'
    ndx.app.get '/api/dezrez/property/:id', ndx.authorize, (req, res) ->
      ndx.dezrez.get 'property/{id}', null, id:req.params.id, (err, body) ->
        if not err
          res.json body
        else
          throw err 
    ndx.app.get '/api/dezrez/property/:id/events', ndx.authorizeDezrez, (req, res) ->
      ndx.dezrez.get 'role/{id}/Events', pageSize, id:req.params.id, (err, body) ->
        if not err
          res.json body
        else
          throw err
    ndx.app.get '/api/dezrez/property/list/:type', ndx.authorizeDezrez, (req, res) ->
      type = req.params.type
      ndx.dezrez.get 'people/{id}/' + type, pageSize, id:req.user.dezrez.Id, (err, body) ->
        if not err
          res.json body
        else
          throw err
    ndx.app.get '/api/dezrez/role/:type', ndx.authorizeDezrez, (req, res) ->
      type = req.params.type
      roleIds = []
      items = []
      async.each ['selling', 'letting'], (status, callback) ->
        ndx.dezrez.get 'people/{id}/' + status, pageSize, id:req.user.dezrez.Id, (err, body) ->
          if not err
            for role in body.Collection
              if roleIds.indexOf(role.Id) is -1
                roleIds.push role.Id
          callback()
      , ->
        async.each roleIds, (roleId, callback) ->
          ndx.dezrez.get 'role/{id}/' + type, pageSize, id:roleId, (err, body) ->
            if not err
              for item in body.Collection
                items.push item
            callback()
        , ->
          res.json items
      

        
    