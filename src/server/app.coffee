'use strict'
 
ndx = require 'ndx-server'
.config
  database: 'vs'
  tables: ['users', 'props', 'tmpprops']
  localStorage: './data'
  publicUser:
    _id: true
    dezrez:
      Id: true
.use 'ndx-passport'
.use 'ndx-passport-twitter'
.use 'ndx-passport-facebook'
.use 'ndx-user-roles'
.use 'ndx-socket'
.use 'ndx-keep-awake'
.use 'ndx-database-backup'
.use 'ndx-auth'
.use 'ndx-static-routes'
.use 'ndx-superadmin'
.use 'ndx-connect'
.use 'ndx-memory-check'
.use require './services/dezrez'
.use require './services/property'
.controller require './controllers/dezrez'
.controller require './controllers/property'
.controller (ndx) ->
  ndx.app.use '/wp-content/themes/VitalSpace2015/public/img/int/icons', ndx.static('./public/img/icons')
.start()