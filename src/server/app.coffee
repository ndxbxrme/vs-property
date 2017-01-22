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
.controller require './dezrez.js'
.controller 'ndx-static-routes'
.start()