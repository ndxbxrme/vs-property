var $ = jQuery;
angular.module('propertyApp', [
  'propertyRoutes',
  'propertyEngine'
]);
angular.module('propertyRoutes', [
  'ui.router'
])
.config(function($urlRouterProvider, $stateProvider) {
  //$urlRouterProvider.otherwise('/search');
  $stateProvider
  .state('search1',{
    url: '/search/:RoleType',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search.html',
    controller: 'SearchCtrl'
  })
  .state('search2',{
    url: '/search/:RoleType/:MinimumPrice',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search.html',
    controller: 'SearchCtrl'
  })
  .state('search3',{
    url: '/search/:RoleType/:MinimumPrice/:MaximumPrice',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search.html',
    controller: 'SearchCtrl'
  })
  .state('search4',{
    url: '/search/:RoleType/:MinimumPrice/:MaximumPrice/:MinimumBedrooms',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search.html',
    controller: 'SearchCtrl'
  })
  .state('search',{
    url: '/search/:RoleType/:MinimumPrice/:MaximumPrice/:MinimumBedrooms/:IncludeStc',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search.html',
    controller: 'SearchCtrl'
  })
  .state('search5',{
    url: '/search/:RoleType/:MinimumPrice/:MaximumPrice/:MinimumBedrooms/:IncludeStc/:Search',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search.html',
    controller: 'SearchCtrl'
  })
  .state('overview', {
    url: '/:town/:street/:propertyID/overview',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/overview.php',
    controller: 'ViewCtrl'
  })
  .state('photos', {
    url: '/:town/:street/:propertyID/photos',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/photos.html',
    controller: 'ViewCtrl'
  })
  .state('layout', {
    url: '/:town/:street/:propertyID/layout',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/layout.html',
    controller: 'ViewCtrl'
  })
  .state('maps', {
    url: '/:town/:street/:propertyID/maps',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/maps.html',
    controller: 'ViewCtrl'
  })
  .state('schools', {
    url: '/:town/:street/:propertyID/schools',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/schools.html',
    controller: 'ViewCtrl'
  })
  .state('transport', {
    url: '/:town/:street/:propertyID/transport',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/transport.html',
    controller: 'ViewCtrl'
  })
  .state('brochure', {
    url: '/:town/:street/:propertyID/brochure',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/brochure.html',
    controller: 'ViewCtrl'
  })
  .state('taxbands', {
    url: '/:town/:street/:propertyID/taxbands',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/taxbands.html',
    controller: 'ViewCtrl'
  });
});
angular.module('propertyEngine', [
  'ngSanitize',
  'ui.router',
  'ngAnimate',
  'angular.filter',
  'ui.bootstrap',
  'ngMap'
])
.constant('API', {
  url: 'https://myproperty.vitalspace.co.uk/api/',
  key: 'U2FsdGVkX1+gN0j3nIuDrf4S1KtTl0vRhxunxFOeDtCZL4szHbINhQMSl3TY+PNFXXcO98NFsIhbVx8rAYArkMQRaW+Yy2jh58LtGwFfwQdp'
})
.run(function($rootScope, $state, $stateParams, $location, $http, API) {
	if(window.location.href.indexOf('myproperty')===-1) { //this file gets included in myproperty... prevents autologin
	  $http.defaults.headers.common.Authorization = "Bearer " + API.key;
	}
    $rootScope.$state = $state;
    return $rootScope.$stateParams = $stateParams;

    $rootScope.$on('$stateChangeSuccess', function() {
        
     $document[0].body.scrollTop = $document[0].documentElement.scrollTop = 0;
  });
  }
)
.run(function($rootScope, $location, $window){
     $rootScope
        .$on('$stateChangeSuccess',
            function(event){
 
                if (!$window.ga)
                    return;
 
                $window.ga('send', 'pageview', { page: $location.path() });
        });
})
.factory('Properties', function(API, $http, $q, $location) {
  var currentProperty = {};
  var currentList = [];
  var currentID = undefined;
  var loading = undefined;
  var pageNumber = 1;
  var pageSize = 12;
  var totalPages = 1;
  var totalCount = 0;
  var fetch = function(url, method, data) {
    var defer = $q.defer();
    loading = true;
    $http({
      url: url,
      method: method,
      data: data
    })
    .success(function(data) {
      loading = undefined;
      defer.resolve(data);
      //console.log(data);
    })
    .error(function(err) {
      loading = undefined;
      defer.reject(err);
    })
    return defer.promise;
  };
  var isSearchPage = function() {
    return $location.$$path.indexOf('/search') !== -1;
  };
  return {
    fetchProperty: function(propertyID) {
      var defer = $q.defer();
      if(propertyID !== currentID) {
        currentID = propertyID;
        var url = API.url + 'property/' + propertyID;
        fetch(url, 'GET', [])
        .then(function(property) {
          currentProperty = property;
          angular.forEach(property.Descriptions, function(description) {
            if(description.Name) {
              currentProperty[description.Name] = description;
            }
          });
          defer.resolve(property);
        }, function(err) {
          defer.reject(err);
        });
      }
      return defer.promise;
    },
    fetchList: function(data, page, excludeFromCurrent) {
      var defer = $q.defer();
      data.BranchIdList = [];
      data.PageNumber = page;
      data.MarketingFlags = ["ApprovedForMarketingWebsite"];
      var url = API.url + 'search';
      fetch(url, 'POST', data)
      .then(function(data) {
        if(excludeFromCurrent) {
          defer.resolve(data.Collection);
        }
        else {
          currentList = data.Collection;
          totalCount = data.TotalCount;
          defer.resolve(currentList);
        }
      }, function(err) {
        defer.reject(err);
      });
      return defer.promise;
    },
    current: function() {
      return currentProperty;
    },
    list: function() {
      return currentList;
    },
    propertyID: function() {
      return currentID;
    },
    loading: function() {
      return loading;
    },
    title: function() {
      if(!isSearchPage()) {
        if(currentProperty && currentProperty.Address) {
          return currentProperty.Address.Street + ' | ' + currentProperty.Address.Locality + ' | ' + currentID + ' | Vital Space Estate Agents';
        }
      }
      return 'Property Search';
    },
    isSearchPage: function() {
      return isSearchPage();
    },
    pageNumber: function() {
      return pageNumber;
    },
    pageSize: function() {
      return pageSize;
    },
    totalPages: function() {
      return totalPages;
    },
    totalCount: function() {
      return totalCount;
    }
  };
})
.directive('searchControls', function() {
  return {
    restrict: 'AE',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search-controls.html',
    replace: true,
    link: function(scope, elem, attrs) {
      if(!scope.formData) {
        scope.formData = {};
      }
      if(!scope.processForm) {
        scope.processForm = function() {
          if(!scope.formData.IncludeStc) {
            return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType) + '/' + (scope.formData.MinimumPrice || '0') + '/' + (scope.formData.MaximumPrice || '9999999') + '/' + (scope.formData.MinimumBedrooms || '1') + '/' + scope.formData.IncludeStc;
          }
          if(scope.formData.Search) {
            return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType) + '/' + (scope.formData.MinimumPrice || '0') + '/' + (scope.formData.MaximumPrice || '9999999') + '/' + (scope.formData.MinimumBedrooms || '1') + '/' + (scope.formData.IncludeStc) + '/' + scope.formData.Search;
          }
          if(scope.formData.MinimumBedrooms) {
            return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType) + '/' + (scope.formData.MinimumPrice || '0') + '/' + (scope.formData.MaximumPrice || '9999999') + '/' + scope.formData.MinimumBedrooms;
          }
          if(scope.formData.MaximumPrice) {
            return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType) + '/' + (scope.formData.MinimumPrice || '0') + '/' + scope.formData.MaximumPrice;
          }
          if(scope.formData.MinimumPrice) {
            return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType) + '/' + scope.formData.MinimumPrice;
          }
          return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType)
        };
      }
    }
  };
})
.directive('homeSearchControls', function() {
  return {
    restrict: 'AE',
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/search-controls-home.html',
    replace: true,
    link: function(scope, elem, attrs) {
      if(!scope.formData) {
        scope.formData = {};
      }
      if(!scope.processForm) {
        scope.processForm = function() {
          if(scope.formData.Search) {
            return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType) + '/' + (scope.formData.MinimumPrice || '0') + '/' + (scope.formData.MaximumPrice || '1000000') + '/' + (scope.formData.MinimumBedrooms || '1') + '/' + (scope.formData.IncludeStc) + '/' + scope.formData.Search;
          }
          return location.href='//vitalspace.co.uk/property/#/search/' + (scope.formData.RoleType)
        };
      }
    }
  };
})
.directive('schools', function(Properties) {
  return {
    restrict: 'AE',
    template: '<iframe id="mapframe" style="width:100%; height:600px; border:1px solid #CCCCCC;" ></iframe>',
    replace: true,
    link: function(scope, elem, attrs) {
      try{
        setLocratingIFrameProperties(
          {
            'id':'mapframe',
            'search':Properties.current().Address.Postcode,
            'text':'House in ' + Properties.current().Address.Postcode + ', ' + Properties.current().Address.Locality + ', UK'
          }
        );
      }catch (err) {
        //console.log('school', err);
      }
    }
  };
})
.directive('transport', function(Properties) {
  return {
    restrict: 'AE',
    template: '<iframe id="stationslist" style="width:100%; height:600px; border:1px solid #CCCCCC;" ></iframe>',
    replace: true,
    link: function(scope, elem, attrs) {
      try{
        setLocratingIFrameProperties(
          {
            'id':'stationslist',
            'lat':Properties.current().Address.Location.Latitude,
            'lng':Properties.current().Address.Location.Longitude,
            'text':'House in ' + Properties.current().Address.Postcode + ', ' + Properties.current().Address.Locality + ', UK',
            'type': 'stations' 
          }
        );
      }catch (err) {
        //console.log('transport', err);
      }
    }
  };
})
.directive('transportmap', function(Properties) {
  return {
    restrict: 'AE',
    template: '<iframe id="stationsmap" style="width:100%; height:600px; border:1px solid #CCCCCC;" ></iframe>',
    replace: true,
    link: function(scope, elem, attrs) {
      try{
        setLocratingIFrameProperties(
          {
            'id':'stationsmap',
            'lat':Properties.current().Address.Location.Latitude,
            'lng':Properties.current().Address.Location.Longitude,
            'text':'House in ' + Properties.current().Address.Postcode + ', ' + Properties.current().Address.Locality + ', UK',
            'type': 'localinfo',
            'showstations': 'only',
            'zoom': '8' 
          }
        );
      }catch (err) {
        //console.log('transportmap', err);
      }
    }
  };
})
.directive('fancybox', function($compile) {
  return {
    restrict: 'EA',
    replace: false,
    link: function($scope, element, attrs) {
      $(element[0]).fancybox();
    }
  };
})

.directive('similarProperties', function($timeout) {
  return {
    restrict: 'EA',
    replace: true,
    templateUrl: '//vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/similar-properties.html',
    scope: {
      properties: '='
    },
    link: function(scope, elem) {
      var initialized = false;
      scope.$watch('properties', function(n) {
        if(n && n.length && !initialized) {
          initialized = true;
          $timeout(function() {
            $('.slider-div').bxSlider({
              slideWidth: 360,
              minSlides: 1,
              maxSlides: 4,
              pager: true,
              controls: false,
              auto: true,
              speed: 1000,
              infiniteLoop: true,
              mode: 'fade',
              pause: 5000
            },100);
          });
        }
      })
    }
  };
})
.directive('bxSlider', function () {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            scope.$on('repeatFinished', function () {
                if(element.reloadSlider){
                        element.reloadSlider();
                    }
                    else{
                        element.bxSlider().bxSlider(scope.$eval('{' + attrs.bxSlider + '}'));
                    }
            });
        }
    }
})
.directive('notifyWhenRepeatFinished', function ($timeout) {
    return {
        restrict: 'A',
        link: function (scope, element, attr) {
            if (scope.$last === true) {
                $timeout(function () {
                    scope.$emit('repeatFinished');
                },100);
            }
        }
    }
})
.filter('titleCase', function() {
  return function(input) {
    input = input || '';
    return input.replace(/\w\S*/g, function(txt) {
      return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
  };
})
.controller('NavCtrl', function($scope, $filter, $sce, Properties) {
  $scope.Properties = Properties;
  $scope.getPropertyUrlData = function() {
    if(Properties.current().Address) {
      return {
        propertyID:Properties.propertyID(),
        town: $filter('slugify')(Properties.current().Address.Locality),
        street: $filter('slugify')(Properties.current().Address.Street)
      }
    }
    return {}
  };
  $scope.getTrustedUrl = function(url) {
    if(url) {
      return $sce.trustAsResourceUrl(url);
    }
  };
  $scope.makeImageUrl = function(url, width) {
    if(url) {
      return url + (url.indexOf('?')!==-1?'&width=':'?width=') + width;
    }
  };
  $scope.hasDocument = function(docName) {
    var output = false;
    angular.forEach(Properties.current().Documents, function(document) {
      if(document.DocumentSubType.DisplayName===docName) {
        output = true;
      }
    });
    return output;
  };
  $scope.getDocument = function(docName) {
    var output = {};
    angular.forEach(Properties.current().Documents, function(document) {
      if(document.DocumentSubType.DisplayName===docName) {
        output = document;
      }
    });
    return output;
  };
  $scope.hasDescription = function(descName) {
    var output = false;
    angular.forEach(Properties.current().Descriptions, function(document) {
      if(document.DescriptionType.SystemName===descName) {
        output = true;
      }
    });
    return output;
  };
  $scope.getDescription = function(descName) {
    var output = {};
    angular.forEach(Properties.current().Descriptions, function(document) {
      if(document.DescriptionType.SystemName===descName) {
        output = document;
      }
    });
    return output;
  };
  $scope.hasAllowances = function(allowName) {
    var output = false;
    angular.forEach($scope.getDescription('OccupierAllowance').Pairs, function(document) {
      if(document.Key.SystemName===allowName) {
        output = true;
      }
    });
    return output;
  };
  $scope.getAllowances = function(allowName) {
    var output = {};
    angular.forEach($scope.getDescription('OccupierAllowance').Pairs, function(document) {
      if(document.Key.SystemName===allowName) {
        output = document;
      }
    });
    return output;
  };
  $scope.index = 0;
  $scope.getMainImage = function() {
    if(Properties.current() && Properties.current().Images) {
      return Properties.current().Images[$scope.index].Url;
    }
  };
  $scope.nextImage = function() {
    $scope.index++;
    if($scope.index >= Properties.current().Images.length) {
      $scope.index = 0;
    };
  };
  $scope.prevImage = function() {
    $scope.index--;
    if($scope.index<0) {
      $scope.index = Properties.current().Images.length - 1;
    }
  };
})
.controller('SearchCtrl', function($scope, $stateParams, Properties, $anchorScroll) {
  $scope.isCollapsed = true;
  $scope.formData = {
    Search: $stateParams.Search,
    MinimumPrice: $stateParams.MinimumPrice,
    MaximumPrice: $stateParams.MaximumPrice,
    MinimumBedrooms: $stateParams.MinimumBedrooms,
    SortBy: $stateParams.SortBy,
    PageSize: $stateParams.PageSize,
    IncludeStc: $stateParams.IncludeStc,
    RoleType: $stateParams.RoleType,
  };
  if(!$scope.formData.PageSize) {
    $scope.formData.PageSize = '12';
  }
  if(!$scope.formData.RoleType) {
    $scope.formData.RoleType = 'Selling';
  }
  if(!angular.isDefined($scope.formData.IncludeStc)) {
    $scope.formData.IncludeStc = true;
  }
  $scope.maxSize = 5;
  $scope.pagination = { currentPage: 1 };
  $scope.pagingFrom = function() {
    return (($scope.pagination.currentPage - 1) * +$scope.formData.PageSize) + 1;
  };
  $scope.pagingTo = function() {
    return Math.min($scope.pagination.currentPage * +$scope.formData.PageSize, Properties.totalCount());
  };
  $scope.pageChanged = function() {
    Properties.fetchList($scope.formData, $scope.pagination.currentPage);
    $anchorScroll();
  };
  $scope.processForm = function() {
    Properties.fetchList($scope.formData, $scope.pagination.currentPage);
  };
  $scope.processForm();
  $scope.hasTag = function(property, tagName) {
      var output = false;
      if(property && property.Tags) {
        angular.forEach(property.Tags, function(tag) {
          if(tag.Name===tagName) {
            output = true;
          }
        });
      }
      return output;
    };
})
.controller('ViewCtrl', function($scope, $stateParams, $sce, Properties, $anchorScroll) {
  $scope.Properties = Properties;
  Properties.fetchProperty($stateParams.propertyID);
  $scope.getFloorplanUrl = function() {
    var floorplanUrl = '';
    angular.forEach(Properties.current().Documents, function(document) {
      if(document.DocumentSubType.DisplayName==='Floorplan') {
        floorplanUrl = document.Url;
      }
    });
    return $sce.trustAsResourceUrl(floorplanUrl);
  };
  $scope.getBrochureUrl = function() {
    var brochureUrl = '';
    angular.forEach(Properties.current().Documents, function(document) {
      if(document.DocumentSubType.DisplayName==='Brochure') {
        brochureUrl = document.Url;
      }
    });
    return $sce.trustAsResourceUrl(brochureUrl);
  };
  $scope.getFormUrl = function() {
    if(Properties.current() && Properties.current().Address) {
      return '//vitalspace.co.uk/form-test?address=' + escape(Properties.current().Address.Street + ' ' + Properties.current().Address.Locality) + '&roleid=' + Properties.current().RoleId + '&propid=' + Properties.current().PropertyId;
    }
  };
  $scope.$watchCollection('$stateParams', function() {
       $anchorScroll();
    });
})
.controller('PropSimilar', function($scope, Properties) {
  $scope.Properties = Properties;
  if(Properties.current() && Properties.current().Price && Properties.current()['Room Counts']) {
    var prop = Properties.current();
    var roomCount = prop['Room Counts'].Bathrooms + prop['Room Counts'].Bedrooms + prop['Room Counts'].Others + prop['Room Counts'].Receptions;
    Properties.fetchList({
      MinimumPrice: prop.Price.PriceValue * 0.85,
      MaximumPrice: prop.Price.PriceValue * 1.15,
      MinimumBedrooms: roomCount,
      MaximumBedrooms: roomCount,
      PageSize: 9999,
      IncludeStc: true
    });
  }
})
.controller('PropUpdates', function($scope, $q, Properties) {
  var fetchList = function(sortBy) {
      var defer = $q.defer();
      Properties.fetchList({
         MinimumPrice: 0,
         MaximumPrice: 9999999,
         MinimumBedrooms: 0,
         SortBy: sortBy,
         SortDir:-1,
         PageSize: 500,
         IncludeStc: true
      }, 1, true)
      .then(function(data) {
        defer.resolve(data);
      });
      return defer.promise;
  };
  fetchList('LastUpdated')
  .then(function(data) {
    $scope.updateList = data;
     //console.log('updateList', $scope.updateList);
  });
  fetchList('DateInstructed')
  .then(function(data) {
    $scope.otherList = data;
     // console.log('otherList', $scope.otherList);
  });
});
