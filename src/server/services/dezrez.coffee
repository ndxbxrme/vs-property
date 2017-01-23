'use strict'

superagent = require 'superagent'

module.exports = (ndx) ->
  if process.env.REZI_ID and process.env.REZI_SECRET
    envUrls =
      dev:
        auth: 'https://dezrez-core-auth-uat.dezrez.com/Dezrez.Core.Api/oauth/token/'
        api: 'https://core-api-uat.dezrez.com/api/'
      live:
        auth: ''
        api: ''
    urls = envUrls[process.env.ENV or 'dev']
    accessToken = null
    tokenExpires = 0
    refreshToken = (cb) ->
      if tokenExpires < new Date().valueOf()
        authCode = new Buffer process.env.REZI_ID + ':' + process.env.REZI_SECRET
        .toString 'base64'
        grantType = 'client_credentials'
        scopes = 'event_read event_write people_read people_write property_read property_write impersonate_web_user'
        superagent.post urls.auth
        .set 'Authorization', 'Basic ' + authCode
        .send
          grant_type: grantType
          scope: scopes
        .end (err, response) ->
          if not err
            accessToken = response.body.access_token
            tokenExpires = new Date().valueOf() + (6000 * 1000)
          return cb(err)
      else
        return cb()
    get = (route, query, params, callback) ->
      doCallback = (err, body) ->
        if Object.prototype.toString.call(params) is '[object Function]'
          return params err, body
        else if Object.prototype.toString.call(callback) is '[object Function]'
          return callback err, body
      refreshToken (err) ->
        if not err
          if params
            route = route.replace /\{([^\}]+)\}/g, (all, key) ->
              params[key]
          console.log 'getting', route
          query = query or {}
          query.agencyId = 37
          superagent.get urls.api + route
          .set 'Rezi-Api-Version', '1.0'
          .set 'Content-Type', 'application/json'
          .set 'Authorization', 'Bearer ' + accessToken
          .query query
          .send()
          .end (err, response) ->
            doCallback err, response?.body
        else
          return doCallback err, []
    post = (route, data, params, callback) ->
      doCallback = (err, body) ->
        if Object.prototype.toString.call(params) is '[object Function]'
          return params err, body
        else if Object.prototype.toString.call(callback) is '[object Function]'
          return callback err, body
      refreshToken (err) ->
        if not err
          if params
            route = route.replace /\{([^\}]+)\}/g, (all, key) ->
              params[key]
          data = data or {}
          superagent.post 'https://core-api-uat.dezrez.com/api/' + route
          .set 'Rezi-Api-Version', '1.0'
          .set 'Content-Type', 'application/json'
          .set 'Authorization', 'Bearer ' + accessToken
          .query
            agencyId: 37
          .send data
          .end (err, response) ->
            doCallback err, response?.body
        else
          return doCallback err, []
    ndx.dezrez =
      get: get
      post: post
        