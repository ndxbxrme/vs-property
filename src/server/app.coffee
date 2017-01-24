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
.use 'ndx-socket'
.use 'ndx-keep-awake'
.use require './services/dezrez'
.controller require './controllers/dezrez'
.controller (ndx) ->
  ndx.app.use '/wp-content/themes/VitalSpace2015/public/img/int/icons', ndx.static('./public/img/icons')
.controller 'ndx-static-routes'
.start()