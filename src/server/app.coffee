'use strict'
 
ndx = require 'ndx-server'
.config
  database: 'vs'
  tables: ['users', 'props', 'tmpprops']
  localStorage: './data'
  maxSqlCacheSize: 50
  publicUser:
    _id: true
    local: true
    dezrez:
      Id: true
      ContactName: true
.use (ndx) ->
  if process.env.REZI_ID and process.env.REZI_SECRET and process.env.AGENCY_ID and process.env.API_URL and process.env.API_KEY
    true
  else
    console.log '*****************************'
    console.log 'ENVIRONMENT VARIABLES NOT SET'
    console.log '*****************************'
.use 'ndx-cors'
#.use 'ndx-profiler'
.use 'ndx-passport'
.use 'ndx-passport-twitter'
.use 'ndx-passport-facebook'
.use 'ndx-user-roles'
#.use 'ndx-socket'
.use 'ndx-keep-awake'
.use 'ndx-database-backup'
.use 'ndx-auth'
.use 'ndx-static-routes'
.use 'ndx-superadmin'
.use 'ndx-connect'
.use require './services/dezrez'
.use require './services/property'
.controller require './controllers/dezrez'
.controller require './controllers/property'
.controller (ndx) ->
  ndx.app.use '/wp-content/themes/VitalSpace2015/public/img/int/icons', ndx.static('./public/img/icons')
.start()