'use strict'

angular.module 'vsProperty'
.controller 'ReportsCtrl', ($scope, auth, dezrez) ->
  $scope.auth = auth
  $scope.getProperties = dezrez.getProperties
  $scope.loading = dezrez.loading
  
  $scope.getFeedbackCount = (property) ->
    count = 0
    for viewing in property.viewings
      count += viewing.Feedback.length
    count
    
  $scope.hasDocument = (docName, property) ->
    if property.Documents and property.Documents.length
      for document in property.Documents
        if document.DocumentSubType.DisplayName is docName
          return true
    false
