'use strict'

angular.module 'vsProperty'
.filter 'hasDocument', ->
  (property, docName) ->
    if property.Documents and property.Documents.length
      for document in property.Documents
        if document.DocumentSubType.DisplayName is docName
          return 'Yes'
    'No'