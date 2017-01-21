'use strict'

superagent = require 'superagent'

module.exports = ->
  if process.env.REZI_ID and process.env.REZI_SECRET
    url = 'https://dezrez-core-auth-uat.dezrez.com/Dezrez.Core.Api/oauth/token/'
    authCode = new Buffer process.env.REZI_ID + ':' + process.env.REZI_SECRET
    .toString 'base64'
    grantType = 'client_credentials'
    scopes = 'event_read event_write people_read people_write property_read property_write impersonate_web_user'
    superagent.post url
    .set 'Authorization', 'Basic ' + authCode
    .send
      grant_type: grantType
      scope: scopes
    .end (err, response) ->
      if not err
        credentials = response.body
        console.log credentials
        superagent.get 'https://core-api-uat.dezrez.com/api/people/findbyemail'
        .set 'Rezi-Api-Version', '1.0'
        .set 'Content-Type', 'application/json'
        .set 'Authorization', 'Bearer ' + credentials.access_token
        .query
          emailAddress: 'richard@vitalspace.co.uk'
          agencyId: 37
        .send()
        .end (err, response) ->
          console.log 'err', err, 'response', response.body
        
        
    