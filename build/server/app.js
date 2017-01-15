(function() {
  'use strict';
  var ndx;

  ndx = require('ndx-server').config({
    database: 'vs',
    tables: ['users'],
    host: 'localhost:3000',
    localStorage: './data'
  }).use('ndx-passport').use('ndx-socket').use('ndx-keep-awake').controller('ndx-static-routes').start();

}).call(this);

//# sourceMappingURL=app.js.map
