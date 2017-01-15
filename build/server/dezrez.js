(function() {
  'use strict';
  var superagent;

  superagent = require('superagent');

  module.exports = function() {
    var authCode, grantType, scopes, url;
    if (process.env.REZI_ID && process.env.REZI_SECRET) {
      url = 'https://dezrez-core-auth-uat.dezrez.com/Dezrez.Core.Api/oauth/token/';
      authCode = new Buffer(process.env.REZI_ID + ':' + process.env.REZI_SECRET).toString('base64');
      grantType = 'client_credentials';
      scopes = 'event_read event_write people_read people_write property_read property_write impersonate_web_user';
      return superagent.post(url).set('Authorization', 'Basic ' + authCode).send({
        grant_type: grantType,
        scope: scopes
      }).end(function(err, response) {
        var credentials;
        if (!err) {
          credentials = response.body;
          return superagent.get('https://core-api-uat.dezrez.com/api/people/findbyemail').set('Rezi-Api-Version', '1.0').set('Authorization', 'bearer ' + credentials.access_token).query({
            emailAddress: 'martin@manchestermade.com'
          }).send().end(function(err, response) {
            return console.log('err', err, 'response', response.body);
          });
        }
      });
    }
  };

}).call(this);

//# sourceMappingURL=dezrez.js.map
