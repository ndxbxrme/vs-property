'use strict'
 
ndx = require 'ndx-server'
.config
  database: 'vs'
  tables: ['users']
  host: 'localhost:3000'
  localStorage: './data'
.use 'ndx-passport'
.use 'ndx-passport-twitter'
.use 'ndx-passport-facebook'
.use 'ndx-user-roles'
.use 'ndx-socket'
.use 'ndx-keep-awake'
.use 'ndx-database-backup'
.use require './services/dezrez'
.use (ndx) ->
  ndx.database.on 'ready', ->
    users = ndx.database.exec 'SELECT * FROM ' + ndx.settings.USER_TABLE + ' WHERE local->email=?', ['admin@admin.com']
    if not users.length
      ndx.database.exec 'INSERT INTO users VALUES ?', [{
        local:
          email: 'admin@admin.com'
          password: ndx.generateHash 'admin'
        roles:
          admin: {}
      }]
      console.log 'inserted'
.controller require './controllers/dezrez'
.controller (ndx) ->
  ndx.app.use '/wp-content/themes/VitalSpace2015/public/img/int/icons', ndx.static('./public/img/icons')
.controller 'ndx-static-routes'
.start()