'use strict'
async = require 'async'

module.exports = (ndx) ->
  if process.env.REZI_ID and process.env.REZI_SECRET
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
        return next req, res
      res.json
        error: 'not authorized'
    ndx.authorizeDezrez = (req, res, next) ->
      console.log 'authorize dezrez', req.user.dezrez.Id
      if req.user and req.user.dezrez
        return next req, res
      res.json
        error: 'not authorized'
      
    ndx.app.post '/api/dezrez/email',  (req, res) ->
      findByEmail req.body.email, req.user._id, (data) ->
        res.json data
    ndx.app.post '/api/dezrez/findbyemail', (req, res) ->
      findByEmail req.body.email, req.user._id, (data) ->
        res.json data
    ndx.app.post '/api/dezrez/update', (req, res) ->
      updateUserDezrez req.body.dezrez, req.user._id
      res.end 'OK'
    ndx.app.get '/api/dezrez/property/:id', (req, res) ->
      ndx.dezrez.get 'property/{id}', null, id:req.params.id, (err, body) ->
        if not err
          res.json body
        else
          res.json
            error: err
    ndx.app.get '/api/dezrez/property/list/:type', (req, res) ->
      type = req.params.type
      ndx.dezrez.get 'people/{id}/' + type, null, id:req.user.dezrez.Id, (err, body) ->
        if not err
          res.json body
        else
          res.json
            error: err
    ndx.app.get '/api/dezrez/role/:type', (req, res) ->
      type = req.params.type
      roleIds = []
      items = []
      async.each req.user.dezrez.GroupMemberships, (groupMembership, callback) ->
        if groupMembership.Group
          ndx.dezrez.get 'group/{id}/roles', null, id:groupMembership.Group.Id, (err, body) ->
            if not err
              for role in body.Collection
                console.log role
                if roleIds.indexOf(role.Id) is -1
                  roleIds.push role.Id
            callback()
      , ->
        console.log 'roleIds', roleIds
        async.each roleIds, (roleId, callback) ->
          ndx.dezrez.get 'role/{id}/' + type, null, id:roleId, (err, body) ->
            console.log 'err'
            if not err
              console.log 'got', type
              console.log 'body', body
              for item in body.Collection
                items.push item
            callback()
        , ->
          console.log 'hi from me'
          res.json items
      

        
    