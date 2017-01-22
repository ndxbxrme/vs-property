'use strict'

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
    ndx.app.post '/api/dezrez/email', (req, res) ->
      findByEmail req.body.email, req.user._id, (data) ->
        res.json data
    ndx.app.post '/api/dezrez/findbyemail', (req, res) ->
      findByEmail req.body.email, req.user._id, (data) ->
        res.json data
    ndx.app.post '/api/dezrez/update', (req, res) ->
      updateUserDezrez req.body.dezrez, req.user._id
      res.end 'OK'
    ndx.app.get '/api/dezrez/selling', (req, res) ->
      ndx.dezrez.get 'people/{id}/selling', null, id:req.user.dezrez.Id, (err, body) ->
        if not err
          res.json body
        else
          res.json
            error: err
      

        
    