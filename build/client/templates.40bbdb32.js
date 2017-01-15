angular.module('vsProperty').run(['$templateCache', function($templateCache) {
  'use strict';

  $templateCache.put('routes/dashboard/dashboard.html',
    "<h2>dashboard</h2>"
  );


  $templateCache.put('routes/feedback/feedback.html',
    "<h2>feedback</h2>"
  );


  $templateCache.put('routes/offers/offers.html',
    "<h2>offers</h2>"
  );


  $templateCache.put('routes/property/property.html',
    "<h2>property</h2>"
  );


  $templateCache.put('routes/viewings/viewings.html',
    "<h2>viewings</h2>"
  );


  $templateCache.put('directives/header/header.html',
    "<div class=\"header\"><section class=\"container\"><a href=\"/\"><img src=\"public/img/VitalSpaceLogo-2016.svg\" class=\"logo\"/></a><ul class=\"menu\"><li ng-class=\"{selected:isSelected('/')}\"><a href=\"/\">Dashboard</a></li><li ng-class=\"{selected:isSelected('/property')}\"><a href=\"/property\">Property</a></li><li ng-class=\"{selected:isSelected('/viewings')}\"><a href=\"/viewings\">Viewings</a></li><li ng-class=\"{selected:isSelected('/feedback')}\"><a href=\"/feedback\">Feedback</a></li><li ng-class=\"{selected:isSelected('/offers')}\"><a href=\"/offers\">Offers</a></li></ul></section></div>"
  );

}]);
