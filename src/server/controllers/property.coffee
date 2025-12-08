'use strict'

superagent = require 'superagent'

module.exports = (ndx) ->
  apiUrl = process.env.API_URL or ndx.settings.API_URL
  apiKey = process.env.API_KEY or ndx.settings.API_KEY
  ndx.app.post '/api/search', (req, res) ->
    whereProps = []
    whereSql = ' true=true '
    if req.body.MinimumPrice
      whereSql += ' AND Price->PriceValue >= ? '
      whereProps.push +req.body.MinimumPrice
    if req.body.MaximumPrice and req.body.MaximumPrice isnt '0'
      whereSql += ' AND Price->PriceValue <= ? '
      whereProps.push +req.body.MaximumPrice
    if req.body.MinimumBedrooms
      whereSql += ' AND RoomCountsDescription->Bedrooms >= ? '
      whereProps.push +req.body.MinimumBedrooms
    if req.body.MaximumBedrooms and req.body.MaximumBedrooms isnt '0'
      whereSql += ' AND RoomCountsDescription->Bedrooms <= ? '
      whereProps.push +req.body.MaximumBedrooms
    if req.body.MinimumRooms
      whereSql += ' AND NoRooms >= ? '
      whereProps.push +req.body.MinimumRooms
    if req.body.MaximumRooms
      whereSql += ' AND NoRooms <= ? '
      whereProps.push +req.body.MaximumRooms
    if not req.body.IncludeStc
      whereSql += ' AND stc=false '
    if req.body.RoleType
      whereSql += ' AND RoleType->SystemName = ? '
      whereProps.push req.body.RoleType
    if req.body.RoleStatus
      whereSql += ' AND RoleStatus->SystemName = ? '
      whereProps.push req.body.RoleStatus
    if req.body.Search
      whereSql += " AND SearchField LIKE '%#{req.body.Search.replace("'", '')}%' "
    sortby = 'Price->PriceValue'
    sortdir = 1
    limit = 0
    skip = 0
    if req.body.SortBy
      sortby = req.body.SortBy.replace '.', '->'
    if req.body.SortDir
      sortdir = req.body.SortDir
    if req.body.PageSize
      limit = +req.body.PageSize
    if req.body.PageNumber
      skip = ((+req.body.PageNumber - 1) * limit) + 1
    totalProps = ndx.database.exec "SELECT * FROM props WHERE #{whereSql}", whereProps
    total = totalProps.length
    orderby = " ORDER BY #{sortby} #{if sortdir is 1 then 'ASC' else 'DESC'} "
    paging = " LIMIT #{limit} OFFSET #{skip} "
    props = ndx.database.exec "SELECT * FROM props WHERE #{whereSql} #{orderby} #{paging}", whereProps
    res.json
      TotalCount: total
      CurrentCount: props.length
      PageSize: limit
      PageNumber: Math.floor((skip - 1) / limit) + 1
      Collection: props
  ndx.app.get '/api/property/:id', (req, res) ->
    property = 
      'RoleId': 29622430
      'PropertyId': 3818741
      'PropertyStyle':
        'Id': 49568
        'Name': 'Period'
        'SystemName': 'Period'
      'Address':
        'OrganizationName': ''
        'Number': '34'
        'BuildingName': ''
        'Street': 'Oak Grove'
        'Town': 'Manchester'
        'Locality': 'Urmston'
        'County': ''
        'Postcode': 'M41 0XU'
        'Location':
          'Latitude': 53.450415066924386
          'Longitude': -2.3469569437312177
          'Altitude': 0
      'RoomCountsDescription':
        'Bedrooms': 2
        'Bathrooms': 1
        'Receptions': 2
        'Conservatories': 0
        'Extensions': 0
        'Others': 0
        'DescriptionType':
          'DisplayName': 'Room Count'
          'SystemName': 'RoomCount'
        'Name': null
        'Notes': null
      'AmenityDescription':
        'Gardens': 1
        'ParkingSpaces': 1
        'ParkingTypes': '(Collection)'
        'Garages': 1
        'Acreage': 0
        'AcreageMeasurementUnitType': null
        'AccessibilityTypes': '(Collection)'
        'HeatingSources': '(Collection)'
        'ElectricitySupply': '(Collection)'
        'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
        'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
        'BroadbandConnectionTypes': '(Collection)'
        'DescriptionType':
          'DisplayName': 'Amenity'
          'SystemName': 'Amenity'
        'Name': null
        'Notes': null
      'FloodErosionDescription': null
      'RightsRestrictionsDescription': null
      'BranchDetails':
        'Id': 245201
        'Name': 'VitalSpace Estate Agents'
        'Description': null
        'ContactDetails':
          'Addresses': [ {
            'AddressType':
              'DisplayName': 'Primary'
              'SystemName': 'Primary'
            'Address':
              'OrganizationName': null
              'Number': null
              'BuildingName': null
              'Street': 'Eden Square'
              'Town': 'Manchester'
              'Locality': 'Urmston'
              'County': ''
              'Postcode': 'M41 5AA'
              'Location':
                'Latitude': 0
                'Longitude': 0
                'Altitude': 0
            'ContactOrder': 1
          } ]
          'ContactItems': [
            {
              'ContactItemType':
                'DisplayName': 'Email'
                'SystemName': 'Email'
              'Value': 'offers@vitalspace.co.uk'
              'Notes': null
              'ContactOrder': 1
              'AllowContact': true
            }
            {
              'ContactItemType':
                'DisplayName': 'Website'
                'SystemName': 'Website'
              'Value': 'http://www.vitalspace.co.uk'
              'Notes': null
              'ContactOrder': 1
              'AllowContact': true
            }
            {
              'ContactItemType':
                'DisplayName': 'Telephone'
                'SystemName': 'Telephone'
              'Value': '0161 747 7807'
              'Notes': null
              'ContactOrder': 1
              'AllowContact': true
            }
            {
              'ContactItemType':
                'DisplayName': 'Mobile'
                'SystemName': 'Mobile'
              'Value': '0161 747 7807'
              'Notes': null
              'ContactOrder': 1
              'AllowContact': true
            }
            {
              'ContactItemType':
                'DisplayName': 'ExplicitSendEmailDetails'
                'SystemName': 'ExplicitSendEmailDetails'
              'Value': null
              'Notes': null
              'ContactOrder': 1
              'AllowContact': false
            }
          ]
      'PropertyType':
        'DisplayName': 'Terraced House'
        'SystemName': 'TerracedHouse'
      'Tags': [ { 'Name': 'urmston' } ]
      'Images': [
        {
          'IsPrimaryImage': true
          'Id': 52518223
          'Url': 'https://docs.rezi.cloud/YLQSqT1G-dteb7nWjLCct-lN-2kaGJxxq5owzJPu9QM%3d/52518223.jpg?v=000000000d4a83cb'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 1
        }
        {
          'IsPrimaryImage': false
          'Id': 52518412
          'Url': 'https://docs.rezi.cloud/MJ3sxmIjA-hGMw8B84yOz8juUMR7kjTsxP7WOcNO6w0%3d/52518412.jpg?v=000000000d4a83d7'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 2
        }
        {
          'IsPrimaryImage': false
          'Id': 52518608
          'Url': 'https://docs.rezi.cloud/vlicdIJypJAnOu9Y_ZK_LnjD34YNC1CoPbTHEzCW364%3d/52518608.jpg?v=000000000d4a83e1'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 3
        }
        {
          'IsPrimaryImage': false
          'Id': 52518413
          'Url': 'https://docs.rezi.cloud/hSOyUhoPLajDMiopRaicFXWGdL9Qh2PeN7Jizz1udlY%3d/52518413.jpg?v=000000000d4a83f5'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 4
        }
        {
          'IsPrimaryImage': false
          'Id': 52518609
          'Url': 'https://docs.rezi.cloud/NtWcvA8zhA8o5jo0MUjUMWHZQ4K-zf-mcZUJEvzMTk0%3d/52518609.jpg?v=000000000d4a83ff'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 5
        }
        {
          'IsPrimaryImage': false
          'Id': 52518414
          'Url': 'https://docs.rezi.cloud/QlSoatxbShN2SgKEnVmDQu1CsiIhS8G3Z0tqWYWgKN8%3d/52518414.jpg?v=000000000d4a840b'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 6
        }
        {
          'IsPrimaryImage': false
          'Id': 52518224
          'Url': 'https://docs.rezi.cloud/vCFmv0w_zE6ZuxZQFuw7c-UGl-JRLqADCxjdBFkoBDM%3d/52518224.jpg?v=000000000d4a83eb'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 7
        }
        {
          'IsPrimaryImage': false
          'Id': 52518225
          'Url': 'https://docs.rezi.cloud/rZp-9K6bXbddU1HWqehgALbyQ9aFS5ysOjqbJEUsmR8%3d/52518225.jpg?v=000000000d4a8415'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 8
        }
        {
          'IsPrimaryImage': false
          'Id': 52518610
          'Url': 'https://docs.rezi.cloud/wwsrAUHQWo2rXaXLcBll7ouEgWIuP1Bw06suMrccHek%3d/52518610.jpg?v=000000000d4a841f'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 9
        }
        {
          'IsPrimaryImage': false
          'Id': 52518316
          'Url': 'https://docs.rezi.cloud/mLXZcT107cRqntQs0DzHkzVwymrxXHMnJB1xHEOXV5A%3d/52518316.jpg?v=000000000d4a8429'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 10
        }
        {
          'IsPrimaryImage': false
          'Id': 52518507
          'Url': 'https://docs.rezi.cloud/q6qUhXK3oGutOFyyC1Yh4tbU_xlNFkSfcYcaSrK3W6c%3d/52518507.jpg?v=000000000d4a843d'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 11
        }
        {
          'IsPrimaryImage': false
          'Id': 52518317
          'Url': 'https://docs.rezi.cloud/rlWvdZciFlLM8HQ8qD1eoHpTzJ1zuPZ5F-zMD27Ek2c%3d/52518317.jpg?v=000000000d4a8433'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 12
        }
        {
          'IsPrimaryImage': false
          'Id': 52518611
          'Url': 'https://docs.rezi.cloud/RpJqt2kvpj7cKhL66P_GmuU_oTfZmqnTNdfrFE3RXwg%3d/52518611.jpg?v=000000000d4a8447'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 13
        }
        {
          'IsPrimaryImage': false
          'Id': 52518415
          'Url': 'https://docs.rezi.cloud/gjhmw3q11F1bFTmNd6kNG3vD7RkqFWS6y2IIFJK5Rw4%3d/52518415.jpg?v=000000000d4a845b'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 14
        }
        {
          'IsPrimaryImage': false
          'Id': 52517825
          'Url': 'https://docs.rezi.cloud/wvneFquGlz5KHWgAb_ckRhN7W7-YLBpCQRjOoViAaAg%3d/52517825.jpg?v=000000000d4a8451'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Photo'
            'SystemName': 'Photo'
          'Order': 15
        }
      ]
      'SummaryTextDescription': '<p>**WALK INTO URMSTON** - **CONVERTED LOFT&nbsp;SPACE &amp; UTILITY ROOM** - VITALSPACE ESTATE AGENTS are proud to offer for sale this EXTENDED TWO BEDROOM mid period terrace property situated in the heart of Urmston town centre. With the added benefit of a spacious loft room, in brief the accommodation comprises; a generously sized living room which leads through into a well proportioned dining kitchen beyond. A conveniently placed utility room can be found to the rear of the property with space for a variety of appliances. Stairs rise to the first floor level where a landing gives access into two good sized bedrooms and a well appointed three piece bathroom with a shower over bath combination. A pull down ladder from the landing provides access into a converted loft space, ideal for use as a study or home office. Externally to the rear of the property, an enclosed&nbsp;walled courtyard garden can be found providing an excellent space for a table and chairs during those summer months with a part gravel, part raised decked seating area. Situated in the centre of Urmston ideally placed to enjoy the ever growing selection of amenities including local shops, bars, restaurants, Urmston Grammar school as well as being within walking distance to Urmston train station. Offered for sale with no onward chain, an internal inspection is strongly recommended. Contact VitalSpace Estate Agents for further information.</p>'
      'RoleType':
        'DisplayName': 'Selling'
        'SystemName': 'Selling'
      'Flags': [
        {
          'DisplayName': 'On Market'
          'SystemName': 'OnMarket'
        }
        {
          'DisplayName': 'Approved For Marketing on Websites'
          'SystemName': 'ApprovedForMarketingWebsite'
        }
        {
          'DisplayName': 'Approved For Marketing on Portals'
          'SystemName': 'ApprovedForMarketingPortals'
        }
        {
          'DisplayName': 'Approved For Marketing on Printed Media'
          'SystemName': 'ApprovedForMarketingPrint'
        }
        {
          'DisplayName': 'Offer Accepted'
          'SystemName': 'OfferAccepted'
        }
      ]
      'RoleStatus':
        'DisplayName': 'Offer Accepted'
        'SystemName': 'OfferAccepted'
      'EPC':
        'EPCType':
          'DisplayName': 'England and Wales Residential'
          'SystemName': 'EnglandWalesResidential'
        'EERCurrent': 64
        'EERPotential': 76
        'EIRCurrent': 0
        'EIRPotential': 0
        'EPARCurrent': 0
        'EPARPotential': 0
        'Image':
          'Id': 53029725
          'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce64_pe76_ci0_pi0v2.png'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'EPC'
            'SystemName': 'EPC'
          'Order': 0
      'DateInstructed': '2025-10-17T10:17:29'
      'LastUpdated': '2025-11-26T16:19:02.2758908'
      'ClosingDate': null
      'Price':
        'PriceValue': 220000
        'CurrencyCode': 'GBP'
        'PriceType': null
        'PriceQualifierType': null
        'PriceText': ''
        'AnnualGroundRent': 0
        'GroundRentReviewPeriodYears': 0
        'AnnualServiceCharge': 0
        'TenureUnexpiredYears': null
        'SharedOwnershipPercentage': null
        'SharedOwnershipRent': null
        'SharedOwnershipRentFrequency': null
      'Deposit': null
      'ViewPoints': []
      'OwningTeam':
        'Name': 'Richard Antrobus'
        'Title': 'Mr'
        'Email': 'richard@vitalspace.co.uk'
        'Phone': '07977 473111'
      'Documents': [
        {
          'Id': 52545782
          'Url': 'https://docs.rezi.cloud/HonjDDteL_EoOO-0fYGTmhYZRPhlPeUeZmC7NgvBEVA%3d/52545782.pdf?v=000000000d4b4457'
          'DocumentType':
            'DisplayName': 'Document'
            'SystemName': 'Document'
          'DocumentSubType':
            'DisplayName': 'Brochure'
            'SystemName': 'Brochure'
          'Order': 1
        }
        {
          'Id': 52518227
          'Url': 'https://docs.rezi.cloud/BdnhedMD7wpUFYH4bQpjD1hF1PbJeWCq7C6dsgktS5A%3d/52518227.jpg?v=000000000d4a84d1'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'Floorplan'
            'SystemName': 'Floorplan'
          'Order': 2
        }
        {
          'Id': 53029725
          'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce64_pe76_ci0_pi0v2.png'
          'DocumentType':
            'DisplayName': 'Image'
            'SystemName': 'Image'
          'DocumentSubType':
            'DisplayName': 'EPC'
            'SystemName': 'EPC'
          'Order': 3
        }
        {
          'Id': 52518530
          'Url': 'https://www.youtube.com/embed/AlHeF7DWiRs?si=DW9cg2LiyldGLACo'
          'DocumentType':
            'DisplayName': 'Web Page Link'
            'SystemName': 'Link'
          'DocumentSubType':
            'DisplayName': 'Virtual Tour'
            'SystemName': 'VirtualTour'
          'Order': 4
        }
      ]
      'Fees': [ {
        'FeeId': null
        'Name': '1.0% + VAT'
        'FeeValueType':
          'DisplayName': 'Percentage'
          'SystemName': 'Percentage'
        'FeeCategoryType':
          'DisplayName': 'Commission'
          'SystemName': 'Commission'
        'FeeChargeType':
          'DisplayName': 'Applicable'
          'SystemName': 'Applicable'
        'FeeLiabilityType':
          'DisplayName': 'Vendor'
          'SystemName': 'Vendor'
        'FeeFrequency':
          'DisplayName': 'Flat Price'
          'SystemName': 'FlatPrice'
        'ApplyTax': true
        'VatValue': 0.2
        'DefaultValue': 1
        'ScaleableFees': []
        'AdditionalFees': []
        'Notes': null
        'TransactionType':
          'DisplayName': 'Sales'
          'SystemName': 'Sales'
      } ]
      'Descriptions': [
        {
          'Text': '<p>**WALK INTO URMSTON** - **CONVERTED LOFT&nbsp;SPACE &amp; UTILITY ROOM** - VITALSPACE ESTATE AGENTS are proud to offer for sale this EXTENDED TWO BEDROOM mid period terrace property situated in the heart of Urmston town centre. With the added benefit of a spacious loft room, in brief the accommodation comprises; a generously sized living room which leads through into a well proportioned dining kitchen beyond. A conveniently placed utility room can be found to the rear of the property with space for a variety of appliances. Stairs rise to the first floor level where a landing gives access into two good sized bedrooms and a well appointed three piece bathroom with a shower over bath combination. A pull down ladder from the landing provides access into a converted loft space, ideal for use as a study or home office. Externally to the rear of the property, an enclosed&nbsp;walled courtyard garden can be found providing an excellent space for a table and chairs during those summer months with a part gravel, part raised decked seating area. Situated in the centre of Urmston ideally placed to enjoy the ever growing selection of amenities including local shops, bars, restaurants, Urmston Grammar school as well as being within walking distance to Urmston train station. Offered for sale with no onward chain, an internal inspection is strongly recommended. Contact VitalSpace Estate Agents for further information.</p>'
          'DescriptionType':
            'DisplayName': 'Summary Text'
            'SystemName': 'SummaryText'
          'Name': 'Summary Text'
          'Notes': null
        }
        {
          'Text': '<p>**WALK INTO URMSTON** - **CONVERTED LOFT SPACE &amp; UTILITY ROOM** - VITALSPACE ESTATE AGENTS are proud to offer for sale this EXTENDED TWO BEDROOM mid period terrace property situated in the heart of Urmston town centre. With the added benefit of a spacious loft room, in brief the accommodation comprises; a generously sized living room which leads through into a well proportioned dining kitchen beyond. A conveniently placed utility room can be found to the rear of the property with space for a variety of appliances. Stairs rise to the first floor level where a landing gives access into two good sized bedrooms and a well appointed three piece bathroom with a shower over bath combination. A pull down ladder from the landing provides access into a converted loft space, ideal for use as a study or home office. Externally to the rear of the property, an enclosed walled courtyard garden can be found providing an excellent space for a table and chairs during those summer months with a part gravel, part raised decked seating area. Situated in the centre of Urmston ideally placed to enjoy the ever growing selection of amenities including local shops, bars, restaurants, Urmston Grammar school as well as being within walking distance to Urmston train station. Offered for sale with no onward chain, an internal inspection is strongly recommended. Contact VitalSpace Estate Agents for further information.</p>'
          'DescriptionType':
            'DisplayName': 'Text'
            'SystemName': 'Text'
          'Name': 'Main Marketing'
          'Notes': null
        }
        {
          'Features': [
            {
              'Order': 1
              'Feature': 'Two bedrooms'
            }
            {
              'Order': 2
              'Feature': 'Mid terrace property'
            }
            {
              'Order': 3
              'Feature': 'Walk into Urmston'
            }
            {
              'Order': 4
              'Feature': 'Converted loft space'
            }
            {
              'Order': 5
              'Feature': 'Useful utility room'
            }
            {
              'Order': 6
              'Feature': 'Gas central heating'
            }
            {
              'Order': 7
              'Feature': 'uPVC double glazing'
            }
            {
              'Order': 8
              'Feature': 'Ideal first home'
            }
            {
              'Order': 9
              'Feature': 'Enclosed rear courtyard'
            }
            {
              'Order': 10
              'Feature': 'Viewing recommended'
            }
          ]
          'DescriptionType':
            'DisplayName': 'Feature'
            'SystemName': 'Feature'
          'Name': 'Features'
          'Notes': null
        }
        {
          'Tags': [ { 'Name': 'urmston' } ]
          'DescriptionType':
            'DisplayName': 'Tag'
            'SystemName': 'Tag'
          'Name': 'Tags'
          'Notes': null
        }
        {
          'PropertyType':
            'DisplayName': 'Terraced House'
            'SystemName': 'TerracedHouse'
          'StyleType':
            'DisplayName': 'Period'
            'SystemName': 'Period'
          'LeaseType':
            'DisplayName': 'Freehold'
            'SystemName': 'Freehold'
          'AgeType': null
          'DescriptionType':
            'DisplayName': 'Style and Age'
            'SystemName': 'StyleAge'
          'Name': null
          'Notes': null
        }
        {
          'Bedrooms': 2
          'Bathrooms': 1
          'Receptions': 2
          'Conservatories': 0
          'Extensions': 0
          'Others': 0
          'DescriptionType':
            'DisplayName': 'Room Count'
            'SystemName': 'RoomCount'
          'Name': null
          'Notes': null
        }
        {
          'Text': '<p>How long have you owned the property for? 13 years</p>\n<p>When was the roof last replaced? Yes, approx 2012</p>\n<p>How old is the boiler and when was it last inspected? Gas central heating</p>\n<p>When was the property last rewired? No</p>\n<p>Which way does the garden face? East facing rear garden</p>\n<p>Are there any extensions and if so when were they built? Loft (not to regulations)</p>\n<p>Reasons for sale of property? Relocate</p>\n<p>If you would like to submit an offer on this property, please visit our website - https://www.vitalspace.co.uk/offer - and complete our online offer form.</p>'
          'DescriptionType':
            'DisplayName': 'Custom Text'
            'SystemName': 'CustomText'
          'Name': 'FAQ'
          'Notes': null
        }
        {
          'Gardens': 1
          'ParkingSpaces': 1
          'ParkingTypes': '(Collection)'
          'Garages': 1
          'Acreage': 0
          'AcreageMeasurementUnitType': null
          'AccessibilityTypes': '(Collection)'
          'HeatingSources': '(Collection)'
          'ElectricitySupply': '(Collection)'
          'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
          'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
          'BroadbandConnectionTypes': '(Collection)'
          'DescriptionType':
            'DisplayName': 'Amenity'
            'SystemName': 'Amenity'
          'Name': null
          'Notes': null
        }
        {
          'AuthorityName': 'Trafford Borough Council'
          'TaxBand':
            'Id': 123002
            'Name': 'Band B'
            'SystemName': 'B'
          'TaxBandAmount': 0
          'DescriptionType':
            'DisplayName': 'Local Authority'
            'SystemName': 'LocalAuthority'
          'Name': null
          'Notes': null
        }
        {
          'Text': '<p>EPC GRADE:- TBC</p>'
          'DescriptionType':
            'DisplayName': 'Custom Text'
            'SystemName': 'CustomText'
          'Name': 'Council Tax Band'
          'Notes': null
        }
      ]
      'similar': [
        {
          'RoleId': 29638833
          'PropertyId': 1135814
          'PropertyStyle':
            'Id': 49568
            'Name': 'Period'
            'SystemName': 'Period'
          'Address':
            'OrganizationName': ''
            'Number': '8'
            'BuildingName': ''
            'Street': 'Reginald Street'
            'Town': 'Manchester'
            'Locality': 'Eccles'
            'County': ''
            'Postcode': 'M30 7DA'
            'Location':
              'Latitude': 53.475564102034284
              'Longitude': -2.3704382923536294
              'Altitude': 0
          'RoomCountsDescription':
            'Bedrooms': 2
            'Bathrooms': 1
            'Receptions': 1
            'Conservatories': 0
            'Extensions': 0
            'Others': 0
            'DescriptionType':
              'DisplayName': 'Room Count'
              'SystemName': 'RoomCount'
            'Name': null
            'Notes': null
          'AmenityDescription':
            'Gardens': 1
            'ParkingSpaces': 0
            'ParkingTypes': '(Collection)'
            'Garages': 0
            'Acreage': 0
            'AcreageMeasurementUnitType': null
            'AccessibilityTypes': '(Collection)'
            'HeatingSources': '(Collection)'
            'ElectricitySupply': '(Collection)'
            'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'BroadbandConnectionTypes': '(Collection)'
            'DescriptionType':
              'DisplayName': 'Amenity'
              'SystemName': 'Amenity'
            'Name': null
            'Notes': null
          'FloodErosionDescription': null
          'RightsRestrictionsDescription': null
          'BranchDetails':
            'Id': 245201
            'Name': 'VitalSpace Estate Agents'
            'Description': null
            'ContactDetails':
              'Addresses': [ {
                'AddressType':
                  'DisplayName': 'Primary'
                  'SystemName': 'Primary'
                'Address':
                  'OrganizationName': null
                  'Number': null
                  'BuildingName': null
                  'Street': 'Eden Square'
                  'Town': 'Manchester'
                  'Locality': 'Urmston'
                  'County': ''
                  'Postcode': 'M41 5AA'
                  'Location':
                    'Latitude': 0
                    'Longitude': 0
                    'Altitude': 0
                'ContactOrder': 1
              } ]
              'ContactItems': [
                {
                  'ContactItemType':
                    'DisplayName': 'Email'
                    'SystemName': 'Email'
                  'Value': 'offers@vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Website'
                    'SystemName': 'Website'
                  'Value': 'http://www.vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Telephone'
                    'SystemName': 'Telephone'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Mobile'
                    'SystemName': 'Mobile'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'ExplicitSendEmailDetails'
                    'SystemName': 'ExplicitSendEmailDetails'
                  'Value': null
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': false
                }
              ]
          'PropertyType':
            'DisplayName': 'Terraced House'
            'SystemName': 'TerracedHouse'
          'Tags': [ { 'Name': 'eccles' } ]
          'Images': [
            {
              'IsPrimaryImage': true
              'Id': 6128701
              'Url': 'https://docs.rezi.cloud/x6GWxoMn7KvbJrzguBtCNg3LSWIHFr8evo5dncSBDbc%3d/6128701.jpg?v=000000000d4cb9e3'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 1
            }
            {
              'IsPrimaryImage': false
              'Id': 6128707
              'Url': 'https://docs.rezi.cloud/XaO9LhH3vpuCq-Xf5jlF-wwQaZzEqGsQgiOgKF36qMo%3d/6128707.jpg?v=000000000d4cb9e9'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 2
            }
            {
              'IsPrimaryImage': false
              'Id': 6128703
              'Url': 'https://docs.rezi.cloud/WC_8NTT-LIOvbkSzLbL3czLaVO-EmAIS6GlCCk0GdRM%3d/6128703.jpg?v=000000000d4cb9e5'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 3
            }
            {
              'IsPrimaryImage': false
              'Id': 6128705
              'Url': 'https://docs.rezi.cloud/18M_T1NI3i79wSFdmKN0pWLIluQkL8Jys5lW3eIP-Dk%3d/6128705.jpg?v=000000000d4cb9e7'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 4
            }
            {
              'IsPrimaryImage': false
              'Id': 6128704
              'Url': 'https://docs.rezi.cloud/JxiFlCgmjHsgz6auKmOG1QIKyr3E03QkU2qn4pOwwII%3d/6128704.jpg?v=000000000d4cb9e6'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 5
            }
            {
              'IsPrimaryImage': false
              'Id': 6128706
              'Url': 'https://docs.rezi.cloud/ivUjW0YkkEG1xN85F-GRZWqzzE290tUpOpKmbyuPPSY%3d/6128706.jpg?v=000000000d4cb9e8'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 6
            }
            {
              'IsPrimaryImage': false
              'Id': 6126998
              'Url': 'https://docs.rezi.cloud/0YtwUd9BJxTeRI3zEOTHXtZYjifYiHZ7CpfVS226iC4%3d/6126998.jpg?v=000000000d4cb9e0'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 7
            }
            {
              'IsPrimaryImage': false
              'Id': 6127000
              'Url': 'https://docs.rezi.cloud/nEg0IeE7g07I5s6xmTjiNWIf3d_fMkE-RQEE01NHVfM%3d/6127000.jpg?v=000000000d4cb9e2'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 8
            }
            {
              'IsPrimaryImage': false
              'Id': 6126997
              'Url': 'https://docs.rezi.cloud/8cQJ9yNQ-SrWa7cHoeg3bIY_RNV0goLEudI8Smb4Xf0%3d/6126997.jpg?v=000000000d4cb9df'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 9
            }
            {
              'IsPrimaryImage': false
              'Id': 6126999
              'Url': 'https://docs.rezi.cloud/Hagd5g9YpDprN3zxzg9dWF3E5e9ORh4sSO4uBok2ujo%3d/6126999.jpg?v=000000000d4cb9e1'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 10
            }
            {
              'IsPrimaryImage': false
              'Id': 6128702
              'Url': 'https://docs.rezi.cloud/nlWFOdcvCSj00FZXC2PmpKjEKY0LMg9Prv5c_JPgHT8%3d/6128702.jpg?v=000000000d4cb9e4'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 11
            }
          ]
          'SummaryTextDescription': '<p>**NO ONWARD CHAIN** - **MODERNISATION REQUIRED** - VITALSPACE ESTATE AGENTS are pleased to offer for sale this&nbsp;TWO BEDROOM mid terrace property located in the popular Peel Green area of Eccles. Situated within close proximity to major transport links, with easy access to Manchester City Centre and surrounding amenities including The Trafford Centre. In brief, the accommodation comprises; entrance vestibule, living room and a fitted kitchen/diner. To the first floor, a shaped landing provides entry into two bedrooms and a three piece fitted bathroom. This property is gas central heated and double glazed throughout. Externally to the front there is a paved palisade whilst to the rear, a good sized paved patio can be found with a lawned fenced area beyond. There is also a brick built outhouse ideal for storage. Offered for sale with no onward chain, please contact VitalSpace Estate Agents to arrange an internal inspection.</p>'
          'RoleType':
            'DisplayName': 'Selling'
            'SystemName': 'Selling'
          'Flags': [
            {
              'DisplayName': 'On Market'
              'SystemName': 'OnMarket'
            }
            {
              'DisplayName': 'Approved For Marketing on Websites'
              'SystemName': 'ApprovedForMarketingWebsite'
            }
            {
              'DisplayName': 'Approved For Marketing on Portals'
              'SystemName': 'ApprovedForMarketingPortals'
            }
            {
              'DisplayName': 'Approved For Marketing on Printed Media'
              'SystemName': 'ApprovedForMarketingPrint'
            }
            {
              'DisplayName': 'Offer Accepted'
              'SystemName': 'OfferAccepted'
            }
          ]
          'RoleStatus':
            'DisplayName': 'Offer Accepted'
            'SystemName': 'OfferAccepted'
          'EPC':
            'EPCType':
              'DisplayName': 'England and Wales Residential'
              'SystemName': 'EnglandWalesResidential'
            'EERCurrent': 64
            'EERPotential': 89
            'EIRCurrent': 0
            'EIRPotential': 0
            'EPARCurrent': 0
            'EPARPotential': 0
            'Image':
              'Id': 52609085
              'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce64_pe89_ci0_pi0v2.png'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'EPC'
                'SystemName': 'EPC'
              'Order': 0
          'DateInstructed': '2025-10-22T18:59:27'
          'LastUpdated': '2025-11-05T16:40:47.5609563'
          'ClosingDate': null
          'Price':
            'PriceValue': 150000
            'CurrencyCode': 'GBP'
            'PriceType': null
            'PriceQualifierType':
              'DisplayName': 'Offers Over'
              'SystemName': 'OffersOver'
            'PriceText': 'Offers Over'
            'AnnualGroundRent': 0
            'GroundRentReviewPeriodYears': 0
            'AnnualServiceCharge': 0
            'TenureUnexpiredYears': null
            'SharedOwnershipPercentage': null
            'SharedOwnershipRent': null
            'SharedOwnershipRentFrequency': null
          'Deposit': null
          'ViewPoints': []
          'OwningTeam':
            'Name': 'Richard Antrobus'
            'Title': 'Mr'
            'Email': 'richard@vitalspace.co.uk'
            'Phone': '07977 473111'
          'Documents': [
            {
              'Id': 52609097
              'Url': 'https://docs.rezi.cloud/ylU0cSGqJzCGbaBKvE7vAsdP-E3BoBUtz9GNQoy7jeI%3d/52609097.pdf?v=000000000d4cbc87'
              'DocumentType':
                'DisplayName': 'Document'
                'SystemName': 'Document'
              'DocumentSubType':
                'DisplayName': 'Brochure'
                'SystemName': 'Brochure'
              'Order': 1
            }
            {
              'Id': 52609151
              'Url': 'https://docs.rezi.cloud/PVKNxtXD0qagl7Pv0riPxuuXF7rOYrMd-D_vHsB7B5U%3d/52609151.jpg?v=000000000d4cbc80'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Floorplan'
                'SystemName': 'Floorplan'
              'Order': 2
            }
            {
              'Id': 52609085
              'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce64_pe89_ci0_pi0v2.png'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'EPC'
                'SystemName': 'EPC'
              'Order': 3
            }
          ]
          'Fees': [ {
            'FeeId': null
            'Name': '1.0% + VAT'
            'FeeValueType':
              'DisplayName': 'Percentage'
              'SystemName': 'Percentage'
            'FeeCategoryType':
              'DisplayName': 'Commission'
              'SystemName': 'Commission'
            'FeeChargeType':
              'DisplayName': 'Applicable'
              'SystemName': 'Applicable'
            'FeeLiabilityType':
              'DisplayName': 'Vendor'
              'SystemName': 'Vendor'
            'FeeFrequency':
              'DisplayName': 'Flat Price'
              'SystemName': 'FlatPrice'
            'ApplyTax': true
            'VatValue': 0.2
            'DefaultValue': 1
            'ScaleableFees': []
            'AdditionalFees': []
            'Notes': null
            'TransactionType':
              'DisplayName': 'Sales'
              'SystemName': 'Sales'
          } ]
          'Descriptions': [
            {
              'Bedrooms': 2
              'Bathrooms': 1
              'Receptions': 1
              'Conservatories': 0
              'Extensions': 0
              'Others': 0
              'DescriptionType':
                'DisplayName': 'Room Count'
                'SystemName': 'RoomCount'
              'Name': null
              'Notes': null
            }
            {
              'Rooms': []
              'DescriptionType':
                'DisplayName': 'Room'
                'SystemName': 'Room'
              'Name': null
              'Notes': null
            }
            {
              'Tags': [ { 'Name': 'eccles' } ]
              'DescriptionType':
                'DisplayName': 'Tag'
                'SystemName': 'Tag'
              'Name': 'Tags'
              'Notes': null
            }
            {
              'AuthorityName': 'Salford City Council'
              'TaxBand':
                'Id': 123001
                'Name': 'Band A'
                'SystemName': 'A'
              'TaxBandAmount': 0
              'DescriptionType':
                'DisplayName': 'Local Authority'
                'SystemName': 'LocalAuthority'
              'Name': null
              'Notes': null
            }
            {
              'Text': '<p>**NO ONWARD CHAIN** - **MODERNISATION REQUIRED** - VITALSPACE ESTATE AGENTS are pleased to offer for sale this&nbsp;TWO BEDROOM mid terrace property located in the popular Peel Green area of Eccles. Situated within close proximity to major transport links, with easy access to Manchester City Centre and surrounding amenities including The Trafford Centre. In brief, the accommodation comprises; entrance vestibule, living room and a fitted kitchen/diner. To the first floor, a shaped landing provides entry into two bedrooms and a three piece fitted bathroom. This property is gas central heated and double glazed throughout. Externally to the front there is a paved palisade whilst to the rear, a good sized paved patio can be found with a lawned fenced area beyond. There is also a brick built outhouse ideal for storage. Offered for sale with no onward chain, please contact VitalSpace Estate Agents to arrange an internal inspection.</p>'
              'DescriptionType':
                'DisplayName': 'Summary Text'
                'SystemName': 'SummaryText'
              'Name': 'Summary Text'
              'Notes': null
            }
            {
              'Text': '<p>**NO ONWARD CHAIN** - **MODERNISATION REQUIRED** - VITALSPACE ESTATE AGENTS are pleased to offer for sale this TWO BEDROOM mid terrace property located in the popular Peel Green area of Eccles. Situated within close proximity to major transport links, with easy access to Manchester City Centre and surrounding amenities including The Trafford Centre. In brief, the accommodation comprises; entrance vestibule, living room and a fitted kitchen/diner. To the first floor, a shaped landing provides entry into two bedrooms and a three piece fitted bathroom. This property is gas central heated and double glazed throughout. Externally to the front there is a paved palisade whilst to the rear, a good sized paved patio can be found with a lawned fenced area beyond. There is also a brick built outhouse ideal for storage. Offered for sale with no onward chain, please contact VitalSpace Estate Agents to arrange an internal inspection.</p>'
              'DescriptionType':
                'DisplayName': 'Text'
                'SystemName': 'Text'
              'Name': 'Main Marketing'
              'Notes': null
            }
            {
              'Features': [
                {
                  'Order': 1
                  'Feature': 'Two bedrooms'
                }
                {
                  'Order': 2
                  'Feature': 'Mid terrace property'
                }
                {
                  'Order': 3
                  'Feature': 'Gas central heating'
                }
                {
                  'Order': 4
                  'Feature': 'uPVC Double Glazing'
                }
                {
                  'Order': 5
                  'Feature': 'Large kitchen diner'
                }
                {
                  'Order': 6
                  'Feature': 'No onward chain'
                }
                {
                  'Order': 7
                  'Feature': 'Scope to modernise'
                }
                {
                  'Order': 8
                  'Feature': 'Attractively priced'
                }
                {
                  'Order': 9
                  'Feature': 'Popular location'
                }
                {
                  'Order': 10
                  'Feature': 'Viewing recommended'
                }
              ]
              'DescriptionType':
                'DisplayName': 'Feature'
                'SystemName': 'Feature'
              'Name': 'Features'
              'Notes': null
            }
            {
              'Text': '<p>EPC GRADE:- D</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'Council Tax Band'
              'Notes': null
            }
            {
              'Gardens': 1
              'ParkingSpaces': 0
              'ParkingTypes': '(Collection)'
              'Garages': 0
              'Acreage': 0
              'AcreageMeasurementUnitType': null
              'AccessibilityTypes': '(Collection)'
              'HeatingSources': '(Collection)'
              'ElectricitySupply': '(Collection)'
              'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'BroadbandConnectionTypes': '(Collection)'
              'DescriptionType':
                'DisplayName': 'Amenity'
                'SystemName': 'Amenity'
              'Name': null
              'Notes': null
            }
            {
              'PropertyType':
                'DisplayName': 'Terraced House'
                'SystemName': 'TerracedHouse'
              'StyleType':
                'DisplayName': 'Period'
                'SystemName': 'Period'
              'LeaseType':
                'DisplayName': 'Leasehold'
                'SystemName': 'Leasehold'
              'AgeType': null
              'DescriptionType':
                'DisplayName': 'Style and Age'
                'SystemName': 'StyleAge'
              'Name': null
              'Notes': null
            }
            {
              'DescriptionType':
                'DisplayName': 'Charges'
                'SystemName': 'Charges'
              'Name': null
              'Notes': null
            }
            {
              'Text': '<p>How long have you owned the property for? Since 2011</p>\n<p>When was the roof last replaced? Not during ownership</p>\n<p>How old is the boiler and when was it last inspected? Gas central heating - inspected annually</p>\n<p>When was the property last rewired? - unknown but EICR report in place</p>\n<p>Which way does the garden face? North West facing rear garden</p>\n<p>Are there any extensions and if so when were they built? No</p>\n<p>Reasons for sale of property? Sale of buy to let</p>\n<p>If you would like to submit an offer on this property, please visit our website - https://www.vitalspace.co.uk/offer - and complete our online offer form.</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'FAQ'
              'Notes': null
            }
          ]
          'stc': true
          'NoRooms': 4
          'SearchField': 'Reginald Street|Manchester|Eccles|M30 7DA|'
          'displayAddress': '8 Reginald Street, Eccles, Manchester, M30 7DA'
          '_id': '69282d2cfeda7300c1aa644d'
        }
        {
          'RoleId': 29215602
          'PropertyId': 1961108
          'PropertyStyle':
            'Id': 49567
            'Name': 'Modern'
            'SystemName': 'Modern'
          'Address':
            'OrganizationName': ''
            'Number': '12'
            'BuildingName': ''
            'Street': 'Heron Street'
            'Town': 'Manchester'
            'Locality': 'Hulme'
            'County': ''
            'Postcode': 'M15 5PR'
            'Location':
              'Latitude': 53.4621459974
              'Longitude': -2.2507074757
              'Altitude': 0
          'RoomCountsDescription':
            'Bedrooms': 2
            'Bathrooms': 1
            'Receptions': 1
            'Conservatories': 0
            'Extensions': 0
            'Others': 0
            'DescriptionType':
              'DisplayName': 'Room Count'
              'SystemName': 'RoomCount'
            'Name': null
            'Notes': null
          'AmenityDescription':
            'Gardens': 0
            'ParkingSpaces': 0
            'ParkingTypes': '(Collection)'
            'Garages': 0
            'Acreage': 0
            'AcreageMeasurementUnitType': null
            'AccessibilityTypes': '(Collection)'
            'HeatingSources': '(Collection)'
            'ElectricitySupply': '(Collection)'
            'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'BroadbandConnectionTypes': '(Collection)'
            'DescriptionType':
              'DisplayName': 'Amenity'
              'SystemName': 'Amenity'
            'Name': null
            'Notes': null
          'FloodErosionDescription': null
          'RightsRestrictionsDescription': null
          'BranchDetails':
            'Id': 245201
            'Name': 'VitalSpace Estate Agents'
            'Description': null
            'ContactDetails':
              'Addresses': [ {
                'AddressType':
                  'DisplayName': 'Primary'
                  'SystemName': 'Primary'
                'Address':
                  'OrganizationName': null
                  'Number': null
                  'BuildingName': null
                  'Street': 'Eden Square'
                  'Town': 'Manchester'
                  'Locality': 'Urmston'
                  'County': ''
                  'Postcode': 'M41 5AA'
                  'Location':
                    'Latitude': 0
                    'Longitude': 0
                    'Altitude': 0
                'ContactOrder': 1
              } ]
              'ContactItems': [
                {
                  'ContactItemType':
                    'DisplayName': 'Email'
                    'SystemName': 'Email'
                  'Value': 'offers@vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Website'
                    'SystemName': 'Website'
                  'Value': 'http://www.vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Telephone'
                    'SystemName': 'Telephone'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Mobile'
                    'SystemName': 'Mobile'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'ExplicitSendEmailDetails'
                    'SystemName': 'ExplicitSendEmailDetails'
                  'Value': null
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': false
                }
              ]
          'PropertyType':
            'DisplayName': 'Terraced House'
            'SystemName': 'TerracedHouse'
          'Tags': [ { 'Name': 'hulme' } ]
          'Images': [
            {
              'IsPrimaryImage': true
              'Id': 52273258
              'Url': 'https://docs.rezi.cloud/E6QMFoy5L6oD0jvozy7PQgtSrcr1Js-9D1fibvwvt_s%3d/52273258.jpg?v=000000000d44c50f'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 1
            }
            {
              'IsPrimaryImage': false
              'Id': 52273252
              'Url': 'https://docs.rezi.cloud/W2QEXic8NJiQQ2EqUkbu0poxuaKRla8yIAHeQxFYMR4%3d/52273252.jpg?v=000000000d44c4d1'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 2
            }
            {
              'IsPrimaryImage': false
              'Id': 52273255
              'Url': 'https://docs.rezi.cloud/FiY7PX0Cp18MpE9yEwp7BXA0OMDGDeA7kSZTWo2vHrM%3d/52273255.jpg?v=000000000d44c4ef'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 3
            }
            {
              'IsPrimaryImage': false
              'Id': 52273260
              'Url': 'https://docs.rezi.cloud/_xirsyqspc5K_AvEaNXIKy8QzDC2ZGV55fVafK4gTdQ%3d/52273260.jpg?v=000000000d44c527'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 4
            }
            {
              'IsPrimaryImage': false
              'Id': 52273256
              'Url': 'https://docs.rezi.cloud/NNc7gs2VX0_RUjZ9ss7ByARsunxtQZJTmcoNYo2dTwE%3d/52273256.jpg?v=000000000d44c4f9'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 5
            }
            {
              'IsPrimaryImage': false
              'Id': 52273253
              'Url': 'https://docs.rezi.cloud/I-WCfmM1_0jT66r7pD6wxinh70HSwefeVaVl5vmJwOM%3d/52273253.jpg?v=000000000d44c4db'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 6
            }
            {
              'IsPrimaryImage': false
              'Id': 52273254
              'Url': 'https://docs.rezi.cloud/-QeCARyOl6akSfv3yduYhYnObd1d4NC4bPD56Jhw-vw%3d/52273254.jpg?v=000000000d44c4e5'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 7
            }
            {
              'IsPrimaryImage': false
              'Id': 52273257
              'Url': 'https://docs.rezi.cloud/Ihdih1-VCMT2vCatpYM4FbKAitg-tSCgIbNuQAdjinc%3d/52273257.jpg?v=000000000d44c504'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 8
            }
            {
              'IsPrimaryImage': false
              'Id': 52273251
              'Url': 'https://docs.rezi.cloud/0jhke0cTG8kVtHumgocnYTVq9YdLHcJ7QnkUEuhdafg%3d/52273251.jpg?v=000000000d44c4c7'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 9
            }
            {
              'IsPrimaryImage': false
              'Id': 52273248
              'Url': 'https://docs.rezi.cloud/7dGEzgTlZ2kuFPBum5ofdFhIfrY4bJdoyRahxDKAXew%3d/52273248.jpg?v=000000000d44c4a9'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 10
            }
            {
              'IsPrimaryImage': false
              'Id': 52273249
              'Url': 'https://docs.rezi.cloud/SbgON5gjDo4PHoVtGcqfSdWym8SYRCuNUJeY8incImA%3d/52273249.jpg?v=000000000d44c4b3'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 11
            }
            {
              'IsPrimaryImage': false
              'Id': 52273250
              'Url': 'https://docs.rezi.cloud/-jQgViCvUh_5vIkqyUqMtqhJENJUcca76kkOgZzFb6c%3d/52273250.jpg?v=000000000d44c4bd'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 12
            }
            {
              'IsPrimaryImage': false
              'Id': 52273259
              'Url': 'https://docs.rezi.cloud/yzAayXZbPyTpo9z1-5LKHUZXqdkyV6HoMQA3llFV8GQ%3d/52273259.jpg?v=000000000d44c51c'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 13
            }
            {
              'IsPrimaryImage': false
              'Id': 13059858
              'Url': 'https://docs.rezi.cloud/yskJ3AUGk9J66XchW0MCBWHfykrdh569d1ZJAMMNJvg%3d/13059858.jpg?v=000000000d44c2b2'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 14
            }
          ]
          'SummaryTextDescription': '<p>**VIDEO TOUR** - VITALSPACE ESTATE AGENTS are pleased to offer for sale this well presented, updated TWO DOUBLE BEDROOM property situated in a popular area of Hulme. Situated in a convenient location for all local amenities in Hulme, including ASDA Supermarket, with the City Centre and Universities only a mile away. In brief, the well presented accommodation comprises; a warm and welcoming entrance hallway, a newly fitted kitchen complete with a range of&nbsp;handleless wall and base units and a generously sized living room with double doors opening out into the rear south facing garden. To the first floor there are two double bedrooms and a three piece bathroom. Externally, an enclosed low maintenance garden can be found to the rear of the property with a paved patio area providing ample space for a table and chairs. A wooden gate leads through into a parking area where an allocated space can be found. Contact VitalSpace Estate Agents for further information or to arrange an internal inspection.</p>'
          'RoleType':
            'DisplayName': 'Selling'
            'SystemName': 'Selling'
          'Flags': [
            {
              'DisplayName': 'On Market'
              'SystemName': 'OnMarket'
            }
            {
              'DisplayName': 'Approved For Marketing on Websites'
              'SystemName': 'ApprovedForMarketingWebsite'
            }
            {
              'DisplayName': 'Approved For Marketing on Portals'
              'SystemName': 'ApprovedForMarketingPortals'
            }
            {
              'DisplayName': 'Approved For Marketing on Printed Media'
              'SystemName': 'ApprovedForMarketingPrint'
            }
            {
              'DisplayName': 'Offer Accepted'
              'SystemName': 'OfferAccepted'
            }
          ]
          'RoleStatus':
            'DisplayName': 'Offer Accepted'
            'SystemName': 'OfferAccepted'
          'EPC':
            'EPCType': null
            'EERCurrent': 0
            'EERPotential': 0
            'EIRCurrent': 0
            'EIRPotential': 0
            'EPARCurrent': 0
            'EPARPotential': 0
            'Image': null
          'DateInstructed': '2025-10-03T20:55:43'
          'LastUpdated': '2025-10-17T13:12:42.6842408'
          'ClosingDate': null
          'Price':
            'PriceValue': 200000
            'CurrencyCode': 'GBP'
            'PriceType': null
            'PriceQualifierType': null
            'PriceText': ''
            'AnnualGroundRent': 0
            'GroundRentReviewPeriodYears': 0
            'AnnualServiceCharge': 0
            'TenureUnexpiredYears': null
            'SharedOwnershipPercentage': null
            'SharedOwnershipRent': null
            'SharedOwnershipRentFrequency': null
          'Deposit': null
          'ViewPoints': []
          'OwningTeam':
            'Name': 'Aaron Taylor'
            'Title': 'Mr'
            'Email': 'aaron@vitalspace.co.uk'
            'Phone': '07964 558603'
          'Documents': [
            {
              'Id': 52273092
              'Url': 'https://docs.rezi.cloud/3ff1XLHPyhiUpm87q1X-SjDNmVU7OwuWOrYKShGEQis%3d/52273092.pdf?v=000000000d44c74f'
              'DocumentType':
                'DisplayName': 'Document'
                'SystemName': 'Document'
              'DocumentSubType':
                'DisplayName': 'Brochure'
                'SystemName': 'Brochure'
              'Order': 1
            }
            {
              'Id': 13060028
              'Url': 'https://docs.rezi.cloud/2qJM7oL0Vua-r3ZnaiED3q2Lg6GRaeNykvAgJOU1JpQ%3d/13060028.jpg?v=000000000d44c2bf'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Floorplan'
                'SystemName': 'Floorplan'
              'Order': 2
            }
            {
              'Id': 52273261
              'Url': 'https://www.youtube.com/embed/2JuCHT3-TKg?si=5lfR76KMnm51tSVD'
              'DocumentType':
                'DisplayName': 'Web Page Link'
                'SystemName': 'Link'
              'DocumentSubType':
                'DisplayName': 'Virtual Tour'
                'SystemName': 'VirtualTour'
              'Order': 3
            }
          ]
          'Fees': [ {
            'FeeId': null
            'Name': '1.25% + VAT'
            'FeeValueType':
              'DisplayName': 'Percentage'
              'SystemName': 'Percentage'
            'FeeCategoryType':
              'DisplayName': 'Commission'
              'SystemName': 'Commission'
            'FeeChargeType':
              'DisplayName': 'Applicable'
              'SystemName': 'Applicable'
            'FeeLiabilityType':
              'DisplayName': 'Vendor'
              'SystemName': 'Vendor'
            'FeeFrequency':
              'DisplayName': 'Flat Price'
              'SystemName': 'FlatPrice'
            'ApplyTax': true
            'VatValue': 0.2
            'DefaultValue': 1.25
            'ScaleableFees': []
            'AdditionalFees': []
            'Notes': null
            'TransactionType':
              'DisplayName': 'Sales'
              'SystemName': 'Sales'
          } ]
          'Descriptions': [
            {
              'Bedrooms': 2
              'Bathrooms': 1
              'Receptions': 1
              'Conservatories': 0
              'Extensions': 0
              'Others': 0
              'DescriptionType':
                'DisplayName': 'Room Count'
                'SystemName': 'RoomCount'
              'Name': null
              'Notes': null
            }
            {
              'AuthorityName': 'Manchester City Council'
              'TaxBand':
                'Id': 123001
                'Name': 'Band A'
                'SystemName': 'A'
              'TaxBandAmount': 0
              'DescriptionType':
                'DisplayName': 'Local Authority'
                'SystemName': 'LocalAuthority'
              'Name': null
              'Notes': null
            }
            {
              'Tags': [ { 'Name': 'hulme' } ]
              'DescriptionType':
                'DisplayName': 'Tag'
                'SystemName': 'Tag'
              'Name': 'Tags'
              'Notes': null
            }
            {
              'Text': '<p>**VIDEO TOUR** - VITALSPACE ESTATE AGENTS are pleased to offer for sale this well presented, updated TWO DOUBLE BEDROOM property situated in a popular area of Hulme. Situated in a convenient location for all local amenities in Hulme, including ASDA Supermarket, with the City Centre and Universities only a mile away. In brief, the well presented accommodation comprises; a warm and welcoming entrance hallway, a newly fitted kitchen complete with a range of&nbsp;handleless wall and base units and a generously sized living room with double doors opening out into the rear south facing garden. To the first floor there are two double bedrooms and a three piece bathroom. Externally, an enclosed low maintenance garden can be found to the rear of the property with a paved patio area providing ample space for a table and chairs. A wooden gate leads through into a parking area where an allocated space can be found. Contact VitalSpace Estate Agents for further information or to arrange an internal inspection.</p>'
              'DescriptionType':
                'DisplayName': 'Summary Text'
                'SystemName': 'SummaryText'
              'Name': 'Summary Text'
              'Notes': null
            }
            {
              'Text': '<p>**VIDEO TOUR** - VITALSPACE ESTATE AGENTS are pleased to offer for sale this well presented, updated TWO DOUBLE BEDROOM property situated in a popular area of Hulme. Situated in a convenient location for all local amenities in Hulme, including ASDA Supermarket, with the City Centre and Universities only a mile away. In brief, the well presented accommodation comprises; a warm and welcoming entrance hallway, a newly fitted kitchen complete with a range of handleless wall and base units and a generously sized living room with double doors opening out into the rear south facing garden. To the first floor there are two double bedrooms and a three piece bathroom. Externally, an enclosed low maintenance garden can be found to the rear of the property with a paved patio area providing ample space for a table and chairs. A wooden gate leads through into a parking area where an allocated space can be found. Contact VitalSpace Estate Agents for further information or to arrange an internal inspection.</p>'
              'DescriptionType':
                'DisplayName': 'Text'
                'SystemName': 'Text'
              'Name': 'Main Marketing'
              'Notes': null
            }
            {
              'Features': [
                {
                  'Order': 1
                  'Feature': 'Two double bedrooms'
                }
                {
                  'Order': 2
                  'Feature': 'Mid terrace property'
                }
                {
                  'Order': 3
                  'Feature': 'South facing rear garden'
                }
                {
                  'Order': 4
                  'Feature': 'Allocated car parking'
                }
                {
                  'Order': 5
                  'Feature': 'Excellent presentation'
                }
                {
                  'Order': 6
                  'Feature': 'Modern fitted kitchen'
                }
                {
                  'Order': 7
                  'Feature': 'Gas central heating'
                }
                {
                  'Order': 8
                  'Feature': 'Viewing essential'
                }
              ]
              'DescriptionType':
                'DisplayName': 'Feature'
                'SystemName': 'Feature'
              'Name': 'Features'
              'Notes': null
            }
            {
              'Gardens': 0
              'ParkingSpaces': 0
              'ParkingTypes': '(Collection)'
              'Garages': 0
              'Acreage': 0
              'AcreageMeasurementUnitType': null
              'AccessibilityTypes': '(Collection)'
              'HeatingSources': '(Collection)'
              'ElectricitySupply': '(Collection)'
              'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'BroadbandConnectionTypes': '(Collection)'
              'DescriptionType':
                'DisplayName': 'Amenity'
                'SystemName': 'Amenity'
              'Name': null
              'Notes': null
            }
            {
              'DescriptionType':
                'DisplayName': 'Charges'
                'SystemName': 'Charges'
              'Name': null
              'Notes': null
            }
            {
              'Text': '<p>EPC GRADE:- TBC</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'Council Tax Band'
              'Notes': null
            }
            {
              'PropertyType':
                'DisplayName': 'Terraced House'
                'SystemName': 'TerracedHouse'
              'StyleType':
                'DisplayName': 'Modern'
                'SystemName': 'Modern'
              'LeaseType':
                'DisplayName': 'Leasehold'
                'SystemName': 'Leasehold'
              'AgeType': null
              'DescriptionType':
                'DisplayName': 'Style and Age'
                'SystemName': 'StyleAge'
              'Name': null
              'Notes': null
            }
            {
              'Text': '<p>Leasehold 250 years granted in 1996. Service Charge: A service charge is payable which is &pound;660&nbsp;per annum. The charge includes up keep of the communal car park areas as well as buildings insurance. Payable to Scanlan\'s management.</p>\n<p>How long have you owned the property for? 6 years</p>\n<p>When was the property last rewired? Unknown</p>\n<p>Which way does the garden face? South facing rear garden</p>\n<p>Reasons for sale of property? Upsize</p>\n<p>If you would like to submit an offer on this property, please visit our website - https://www.vitalspace.co.uk/offer - and complete our online offer form.</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'FAQ'
              'Notes': null
            }
          ]
          'stc': true
          'NoRooms': 4
          'SearchField': 'Heron Street|Manchester|Hulme|M15 5PR|'
          'displayAddress': '12 Heron Street, Hulme, Manchester, M15 5PR'
          '_id': '69282d2cfeda7300c1aa645e'
        }
        {
          'RoleId': 29622430
          'PropertyId': 3818741
          'PropertyStyle':
            'Id': 49568
            'Name': 'Period'
            'SystemName': 'Period'
          'Address':
            'OrganizationName': ''
            'Number': '34'
            'BuildingName': ''
            'Street': 'Oak Grove'
            'Town': 'Manchester'
            'Locality': 'Urmston'
            'County': ''
            'Postcode': 'M41 0XU'
            'Location':
              'Latitude': 53.450415066924386
              'Longitude': -2.3469569437312177
              'Altitude': 0
          'RoomCountsDescription':
            'Bedrooms': 2
            'Bathrooms': 1
            'Receptions': 2
            'Conservatories': 0
            'Extensions': 0
            'Others': 0
            'DescriptionType':
              'DisplayName': 'Room Count'
              'SystemName': 'RoomCount'
            'Name': null
            'Notes': null
          'AmenityDescription':
            'Gardens': 1
            'ParkingSpaces': 1
            'ParkingTypes': '(Collection)'
            'Garages': 1
            'Acreage': 0
            'AcreageMeasurementUnitType': null
            'AccessibilityTypes': '(Collection)'
            'HeatingSources': '(Collection)'
            'ElectricitySupply': '(Collection)'
            'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'BroadbandConnectionTypes': '(Collection)'
            'DescriptionType':
              'DisplayName': 'Amenity'
              'SystemName': 'Amenity'
            'Name': null
            'Notes': null
          'FloodErosionDescription': null
          'RightsRestrictionsDescription': null
          'BranchDetails':
            'Id': 245201
            'Name': 'VitalSpace Estate Agents'
            'Description': null
            'ContactDetails':
              'Addresses': [ {
                'AddressType':
                  'DisplayName': 'Primary'
                  'SystemName': 'Primary'
                'Address':
                  'OrganizationName': null
                  'Number': null
                  'BuildingName': null
                  'Street': 'Eden Square'
                  'Town': 'Manchester'
                  'Locality': 'Urmston'
                  'County': ''
                  'Postcode': 'M41 5AA'
                  'Location':
                    'Latitude': 0
                    'Longitude': 0
                    'Altitude': 0
                'ContactOrder': 1
              } ]
              'ContactItems': [
                {
                  'ContactItemType':
                    'DisplayName': 'Email'
                    'SystemName': 'Email'
                  'Value': 'offers@vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Website'
                    'SystemName': 'Website'
                  'Value': 'http://www.vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Telephone'
                    'SystemName': 'Telephone'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Mobile'
                    'SystemName': 'Mobile'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'ExplicitSendEmailDetails'
                    'SystemName': 'ExplicitSendEmailDetails'
                  'Value': null
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': false
                }
              ]
          'PropertyType':
            'DisplayName': 'Terraced House'
            'SystemName': 'TerracedHouse'
          'Tags': [ { 'Name': 'urmston' } ]
          'Images': [
            {
              'IsPrimaryImage': true
              'Id': 52518223
              'Url': 'https://docs.rezi.cloud/YLQSqT1G-dteb7nWjLCct-lN-2kaGJxxq5owzJPu9QM%3d/52518223.jpg?v=000000000d4a83cb'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 1
            }
            {
              'IsPrimaryImage': false
              'Id': 52518412
              'Url': 'https://docs.rezi.cloud/MJ3sxmIjA-hGMw8B84yOz8juUMR7kjTsxP7WOcNO6w0%3d/52518412.jpg?v=000000000d4a83d7'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 2
            }
            {
              'IsPrimaryImage': false
              'Id': 52518608
              'Url': 'https://docs.rezi.cloud/vlicdIJypJAnOu9Y_ZK_LnjD34YNC1CoPbTHEzCW364%3d/52518608.jpg?v=000000000d4a83e1'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 3
            }
            {
              'IsPrimaryImage': false
              'Id': 52518413
              'Url': 'https://docs.rezi.cloud/hSOyUhoPLajDMiopRaicFXWGdL9Qh2PeN7Jizz1udlY%3d/52518413.jpg?v=000000000d4a83f5'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 4
            }
            {
              'IsPrimaryImage': false
              'Id': 52518609
              'Url': 'https://docs.rezi.cloud/NtWcvA8zhA8o5jo0MUjUMWHZQ4K-zf-mcZUJEvzMTk0%3d/52518609.jpg?v=000000000d4a83ff'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 5
            }
            {
              'IsPrimaryImage': false
              'Id': 52518414
              'Url': 'https://docs.rezi.cloud/QlSoatxbShN2SgKEnVmDQu1CsiIhS8G3Z0tqWYWgKN8%3d/52518414.jpg?v=000000000d4a840b'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 6
            }
            {
              'IsPrimaryImage': false
              'Id': 52518224
              'Url': 'https://docs.rezi.cloud/vCFmv0w_zE6ZuxZQFuw7c-UGl-JRLqADCxjdBFkoBDM%3d/52518224.jpg?v=000000000d4a83eb'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 7
            }
            {
              'IsPrimaryImage': false
              'Id': 52518225
              'Url': 'https://docs.rezi.cloud/rZp-9K6bXbddU1HWqehgALbyQ9aFS5ysOjqbJEUsmR8%3d/52518225.jpg?v=000000000d4a8415'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 8
            }
            {
              'IsPrimaryImage': false
              'Id': 52518610
              'Url': 'https://docs.rezi.cloud/wwsrAUHQWo2rXaXLcBll7ouEgWIuP1Bw06suMrccHek%3d/52518610.jpg?v=000000000d4a841f'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 9
            }
            {
              'IsPrimaryImage': false
              'Id': 52518316
              'Url': 'https://docs.rezi.cloud/mLXZcT107cRqntQs0DzHkzVwymrxXHMnJB1xHEOXV5A%3d/52518316.jpg?v=000000000d4a8429'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 10
            }
            {
              'IsPrimaryImage': false
              'Id': 52518507
              'Url': 'https://docs.rezi.cloud/q6qUhXK3oGutOFyyC1Yh4tbU_xlNFkSfcYcaSrK3W6c%3d/52518507.jpg?v=000000000d4a843d'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 11
            }
            {
              'IsPrimaryImage': false
              'Id': 52518317
              'Url': 'https://docs.rezi.cloud/rlWvdZciFlLM8HQ8qD1eoHpTzJ1zuPZ5F-zMD27Ek2c%3d/52518317.jpg?v=000000000d4a8433'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 12
            }
            {
              'IsPrimaryImage': false
              'Id': 52518611
              'Url': 'https://docs.rezi.cloud/RpJqt2kvpj7cKhL66P_GmuU_oTfZmqnTNdfrFE3RXwg%3d/52518611.jpg?v=000000000d4a8447'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 13
            }
            {
              'IsPrimaryImage': false
              'Id': 52518415
              'Url': 'https://docs.rezi.cloud/gjhmw3q11F1bFTmNd6kNG3vD7RkqFWS6y2IIFJK5Rw4%3d/52518415.jpg?v=000000000d4a845b'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 14
            }
            {
              'IsPrimaryImage': false
              'Id': 52517825
              'Url': 'https://docs.rezi.cloud/wvneFquGlz5KHWgAb_ckRhN7W7-YLBpCQRjOoViAaAg%3d/52517825.jpg?v=000000000d4a8451'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 15
            }
          ]
          'SummaryTextDescription': '<p>**WALK INTO URMSTON** - **CONVERTED LOFT&nbsp;SPACE &amp; UTILITY ROOM** - VITALSPACE ESTATE AGENTS are proud to offer for sale this EXTENDED TWO BEDROOM mid period terrace property situated in the heart of Urmston town centre. With the added benefit of a spacious loft room, in brief the accommodation comprises; a generously sized living room which leads through into a well proportioned dining kitchen beyond. A conveniently placed utility room can be found to the rear of the property with space for a variety of appliances. Stairs rise to the first floor level where a landing gives access into two good sized bedrooms and a well appointed three piece bathroom with a shower over bath combination. A pull down ladder from the landing provides access into a converted loft space, ideal for use as a study or home office. Externally to the rear of the property, an enclosed&nbsp;walled courtyard garden can be found providing an excellent space for a table and chairs during those summer months with a part gravel, part raised decked seating area. Situated in the centre of Urmston ideally placed to enjoy the ever growing selection of amenities including local shops, bars, restaurants, Urmston Grammar school as well as being within walking distance to Urmston train station. Offered for sale with no onward chain, an internal inspection is strongly recommended. Contact VitalSpace Estate Agents for further information.</p>'
          'RoleType':
            'DisplayName': 'Selling'
            'SystemName': 'Selling'
          'Flags': [
            {
              'DisplayName': 'On Market'
              'SystemName': 'OnMarket'
            }
            {
              'DisplayName': 'Approved For Marketing on Websites'
              'SystemName': 'ApprovedForMarketingWebsite'
            }
            {
              'DisplayName': 'Approved For Marketing on Portals'
              'SystemName': 'ApprovedForMarketingPortals'
            }
            {
              'DisplayName': 'Approved For Marketing on Printed Media'
              'SystemName': 'ApprovedForMarketingPrint'
            }
            {
              'DisplayName': 'Offer Accepted'
              'SystemName': 'OfferAccepted'
            }
          ]
          'RoleStatus':
            'DisplayName': 'Offer Accepted'
            'SystemName': 'OfferAccepted'
          'EPC':
            'EPCType':
              'DisplayName': 'England and Wales Residential'
              'SystemName': 'EnglandWalesResidential'
            'EERCurrent': 64
            'EERPotential': 76
            'EIRCurrent': 0
            'EIRPotential': 0
            'EPARCurrent': 0
            'EPARPotential': 0
            'Image':
              'Id': 53029725
              'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce64_pe76_ci0_pi0v2.png'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'EPC'
                'SystemName': 'EPC'
              'Order': 0
          'DateInstructed': '2025-10-17T10:17:29'
          'LastUpdated': '2025-11-26T16:19:02.2758908'
          'ClosingDate': null
          'Price':
            'PriceValue': 220000
            'CurrencyCode': 'GBP'
            'PriceType': null
            'PriceQualifierType': null
            'PriceText': ''
            'AnnualGroundRent': 0
            'GroundRentReviewPeriodYears': 0
            'AnnualServiceCharge': 0
            'TenureUnexpiredYears': null
            'SharedOwnershipPercentage': null
            'SharedOwnershipRent': null
            'SharedOwnershipRentFrequency': null
          'Deposit': null
          'ViewPoints': []
          'OwningTeam':
            'Name': 'Richard Antrobus'
            'Title': 'Mr'
            'Email': 'richard@vitalspace.co.uk'
            'Phone': '07977 473111'
          'Documents': [
            {
              'Id': 52545782
              'Url': 'https://docs.rezi.cloud/HonjDDteL_EoOO-0fYGTmhYZRPhlPeUeZmC7NgvBEVA%3d/52545782.pdf?v=000000000d4b4457'
              'DocumentType':
                'DisplayName': 'Document'
                'SystemName': 'Document'
              'DocumentSubType':
                'DisplayName': 'Brochure'
                'SystemName': 'Brochure'
              'Order': 1
            }
            {
              'Id': 52518227
              'Url': 'https://docs.rezi.cloud/BdnhedMD7wpUFYH4bQpjD1hF1PbJeWCq7C6dsgktS5A%3d/52518227.jpg?v=000000000d4a84d1'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Floorplan'
                'SystemName': 'Floorplan'
              'Order': 2
            }
            {
              'Id': 53029725
              'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce64_pe76_ci0_pi0v2.png'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'EPC'
                'SystemName': 'EPC'
              'Order': 3
            }
            {
              'Id': 52518530
              'Url': 'https://www.youtube.com/embed/AlHeF7DWiRs?si=DW9cg2LiyldGLACo'
              'DocumentType':
                'DisplayName': 'Web Page Link'
                'SystemName': 'Link'
              'DocumentSubType':
                'DisplayName': 'Virtual Tour'
                'SystemName': 'VirtualTour'
              'Order': 4
            }
          ]
          'Fees': [ {
            'FeeId': null
            'Name': '1.0% + VAT'
            'FeeValueType':
              'DisplayName': 'Percentage'
              'SystemName': 'Percentage'
            'FeeCategoryType':
              'DisplayName': 'Commission'
              'SystemName': 'Commission'
            'FeeChargeType':
              'DisplayName': 'Applicable'
              'SystemName': 'Applicable'
            'FeeLiabilityType':
              'DisplayName': 'Vendor'
              'SystemName': 'Vendor'
            'FeeFrequency':
              'DisplayName': 'Flat Price'
              'SystemName': 'FlatPrice'
            'ApplyTax': true
            'VatValue': 0.2
            'DefaultValue': 1
            'ScaleableFees': []
            'AdditionalFees': []
            'Notes': null
            'TransactionType':
              'DisplayName': 'Sales'
              'SystemName': 'Sales'
          } ]
          'Descriptions': [
            {
              'Text': '<p>**WALK INTO URMSTON** - **CONVERTED LOFT&nbsp;SPACE &amp; UTILITY ROOM** - VITALSPACE ESTATE AGENTS are proud to offer for sale this EXTENDED TWO BEDROOM mid period terrace property situated in the heart of Urmston town centre. With the added benefit of a spacious loft room, in brief the accommodation comprises; a generously sized living room which leads through into a well proportioned dining kitchen beyond. A conveniently placed utility room can be found to the rear of the property with space for a variety of appliances. Stairs rise to the first floor level where a landing gives access into two good sized bedrooms and a well appointed three piece bathroom with a shower over bath combination. A pull down ladder from the landing provides access into a converted loft space, ideal for use as a study or home office. Externally to the rear of the property, an enclosed&nbsp;walled courtyard garden can be found providing an excellent space for a table and chairs during those summer months with a part gravel, part raised decked seating area. Situated in the centre of Urmston ideally placed to enjoy the ever growing selection of amenities including local shops, bars, restaurants, Urmston Grammar school as well as being within walking distance to Urmston train station. Offered for sale with no onward chain, an internal inspection is strongly recommended. Contact VitalSpace Estate Agents for further information.</p>'
              'DescriptionType':
                'DisplayName': 'Summary Text'
                'SystemName': 'SummaryText'
              'Name': 'Summary Text'
              'Notes': null
            }
            {
              'Text': '<p>**WALK INTO URMSTON** - **CONVERTED LOFT SPACE &amp; UTILITY ROOM** - VITALSPACE ESTATE AGENTS are proud to offer for sale this EXTENDED TWO BEDROOM mid period terrace property situated in the heart of Urmston town centre. With the added benefit of a spacious loft room, in brief the accommodation comprises; a generously sized living room which leads through into a well proportioned dining kitchen beyond. A conveniently placed utility room can be found to the rear of the property with space for a variety of appliances. Stairs rise to the first floor level where a landing gives access into two good sized bedrooms and a well appointed three piece bathroom with a shower over bath combination. A pull down ladder from the landing provides access into a converted loft space, ideal for use as a study or home office. Externally to the rear of the property, an enclosed walled courtyard garden can be found providing an excellent space for a table and chairs during those summer months with a part gravel, part raised decked seating area. Situated in the centre of Urmston ideally placed to enjoy the ever growing selection of amenities including local shops, bars, restaurants, Urmston Grammar school as well as being within walking distance to Urmston train station. Offered for sale with no onward chain, an internal inspection is strongly recommended. Contact VitalSpace Estate Agents for further information.</p>'
              'DescriptionType':
                'DisplayName': 'Text'
                'SystemName': 'Text'
              'Name': 'Main Marketing'
              'Notes': null
            }
            {
              'Features': [
                {
                  'Order': 1
                  'Feature': 'Two bedrooms'
                }
                {
                  'Order': 2
                  'Feature': 'Mid terrace property'
                }
                {
                  'Order': 3
                  'Feature': 'Walk into Urmston'
                }
                {
                  'Order': 4
                  'Feature': 'Converted loft space'
                }
                {
                  'Order': 5
                  'Feature': 'Useful utility room'
                }
                {
                  'Order': 6
                  'Feature': 'Gas central heating'
                }
                {
                  'Order': 7
                  'Feature': 'uPVC double glazing'
                }
                {
                  'Order': 8
                  'Feature': 'Ideal first home'
                }
                {
                  'Order': 9
                  'Feature': 'Enclosed rear courtyard'
                }
                {
                  'Order': 10
                  'Feature': 'Viewing recommended'
                }
              ]
              'DescriptionType':
                'DisplayName': 'Feature'
                'SystemName': 'Feature'
              'Name': 'Features'
              'Notes': null
            }
            {
              'Tags': [ { 'Name': 'urmston' } ]
              'DescriptionType':
                'DisplayName': 'Tag'
                'SystemName': 'Tag'
              'Name': 'Tags'
              'Notes': null
            }
            {
              'PropertyType':
                'DisplayName': 'Terraced House'
                'SystemName': 'TerracedHouse'
              'StyleType':
                'DisplayName': 'Period'
                'SystemName': 'Period'
              'LeaseType':
                'DisplayName': 'Freehold'
                'SystemName': 'Freehold'
              'AgeType': null
              'DescriptionType':
                'DisplayName': 'Style and Age'
                'SystemName': 'StyleAge'
              'Name': null
              'Notes': null
            }
            {
              'Bedrooms': 2
              'Bathrooms': 1
              'Receptions': 2
              'Conservatories': 0
              'Extensions': 0
              'Others': 0
              'DescriptionType':
                'DisplayName': 'Room Count'
                'SystemName': 'RoomCount'
              'Name': null
              'Notes': null
            }
            {
              'Text': '<p>How long have you owned the property for? 13 years</p>\n<p>When was the roof last replaced? Yes, approx 2012</p>\n<p>How old is the boiler and when was it last inspected? Gas central heating</p>\n<p>When was the property last rewired? No</p>\n<p>Which way does the garden face? East facing rear garden</p>\n<p>Are there any extensions and if so when were they built? Loft (not to regulations)</p>\n<p>Reasons for sale of property? Relocate</p>\n<p>If you would like to submit an offer on this property, please visit our website - https://www.vitalspace.co.uk/offer - and complete our online offer form.</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'FAQ'
              'Notes': null
            }
            {
              'Gardens': 1
              'ParkingSpaces': 1
              'ParkingTypes': '(Collection)'
              'Garages': 1
              'Acreage': 0
              'AcreageMeasurementUnitType': null
              'AccessibilityTypes': '(Collection)'
              'HeatingSources': '(Collection)'
              'ElectricitySupply': '(Collection)'
              'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'BroadbandConnectionTypes': '(Collection)'
              'DescriptionType':
                'DisplayName': 'Amenity'
                'SystemName': 'Amenity'
              'Name': null
              'Notes': null
            }
            {
              'AuthorityName': 'Trafford Borough Council'
              'TaxBand':
                'Id': 123002
                'Name': 'Band B'
                'SystemName': 'B'
              'TaxBandAmount': 0
              'DescriptionType':
                'DisplayName': 'Local Authority'
                'SystemName': 'LocalAuthority'
              'Name': null
              'Notes': null
            }
            {
              'Text': '<p>EPC GRADE:- TBC</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'Council Tax Band'
              'Notes': null
            }
          ]
          'stc': true
          'NoRooms': 5
          'SearchField': 'Oak Grove|Manchester|Urmston|M41 0XU|'
          'displayAddress': '34 Oak Grove, Urmston, Manchester, M41 0XU'
          '_id': '69282d2cfeda7300c1aa6465'
        }
        {
          'RoleId': 29655274
          'PropertyId': 2248073
          'PropertyStyle':
            'Id': 49568
            'Name': 'Period'
            'SystemName': 'Period'
          'Address':
            'OrganizationName': ''
            'Number': '13'
            'BuildingName': ''
            'Street': 'Haddon Street'
            'Town': 'Manchester'
            'Locality': 'Stretford'
            'County': ''
            'Postcode': 'M32 0JR'
            'Location':
              'Latitude': 53.4563412842
              'Longitude': -2.3041364696
              'Altitude': 0
          'RoomCountsDescription':
            'Bedrooms': 2
            'Bathrooms': 1
            'Receptions': 2
            'Conservatories': 0
            'Extensions': 0
            'Others': 0
            'DescriptionType':
              'DisplayName': 'Room Count'
              'SystemName': 'RoomCount'
            'Name': null
            'Notes': null
          'AmenityDescription':
            'Gardens': 1
            'ParkingSpaces': 0
            'ParkingTypes': '(Collection)'
            'Garages': 0
            'Acreage': 0
            'AcreageMeasurementUnitType': null
            'AccessibilityTypes': '(Collection)'
            'HeatingSources': '(Collection)'
            'ElectricitySupply': '(Collection)'
            'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
            'BroadbandConnectionTypes': '(Collection)'
            'DescriptionType':
              'DisplayName': 'Amenity'
              'SystemName': 'Amenity'
            'Name': null
            'Notes': null
          'FloodErosionDescription': null
          'RightsRestrictionsDescription': null
          'BranchDetails':
            'Id': 245201
            'Name': 'VitalSpace Estate Agents'
            'Description': null
            'ContactDetails':
              'Addresses': [ {
                'AddressType':
                  'DisplayName': 'Primary'
                  'SystemName': 'Primary'
                'Address':
                  'OrganizationName': null
                  'Number': null
                  'BuildingName': null
                  'Street': 'Eden Square'
                  'Town': 'Manchester'
                  'Locality': 'Urmston'
                  'County': ''
                  'Postcode': 'M41 5AA'
                  'Location':
                    'Latitude': 0
                    'Longitude': 0
                    'Altitude': 0
                'ContactOrder': 1
              } ]
              'ContactItems': [
                {
                  'ContactItemType':
                    'DisplayName': 'Email'
                    'SystemName': 'Email'
                  'Value': 'offers@vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Website'
                    'SystemName': 'Website'
                  'Value': 'http://www.vitalspace.co.uk'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Telephone'
                    'SystemName': 'Telephone'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'Mobile'
                    'SystemName': 'Mobile'
                  'Value': '0161 747 7807'
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': true
                }
                {
                  'ContactItemType':
                    'DisplayName': 'ExplicitSendEmailDetails'
                    'SystemName': 'ExplicitSendEmailDetails'
                  'Value': null
                  'Notes': null
                  'ContactOrder': 1
                  'AllowContact': false
                }
              ]
          'PropertyType':
            'DisplayName': 'Terraced House'
            'SystemName': 'TerracedHouse'
          'Tags': [ { 'Name': 'stretford' } ]
          'Images': [
            {
              'IsPrimaryImage': true
              'Id': 16868522
              'Url': 'https://docs.rezi.cloud/YMZKmsm8cdgaJmqnLuTCewDwrrjJq0-51KNetfpAAvk%3d/16868522.jpg?v=000000000d4e9d69'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 1
            }
            {
              'IsPrimaryImage': false
              'Id': 52699326
              'Url': 'https://docs.rezi.cloud/QhcHeYinTqp0znYP5MAVpiobCc2eG9RpNp2Lm5Am4Tk%3d/52699326.jpg?v=000000000d4e9f3b'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 2
            }
            {
              'IsPrimaryImage': false
              'Id': 52699327
              'Url': 'https://docs.rezi.cloud/LJbU2tHXNR6HFPXoXCI9WN5NPCqinqBv3bMV9ds1A-8%3d/52699327.jpg?v=000000000d4e9f4f'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 3
            }
            {
              'IsPrimaryImage': false
              'Id': 52699328
              'Url': 'https://docs.rezi.cloud/OcE1cuJcVHnD9_neQNCJxt_T6HDanxUcqm0EX6ZQTTs%3d/52699328.jpg?v=000000000d4e9f59'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 4
            }
            {
              'IsPrimaryImage': false
              'Id': 52699601
              'Url': 'https://docs.rezi.cloud/VnaHMPaQGMkCNBaxHtAj3INPyGe6qpmKcvb4gzZ17XY%3d/52699601.jpg?v=000000000d4e9f12'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 5
            }
            {
              'IsPrimaryImage': false
              'Id': 52699325
              'Url': 'https://docs.rezi.cloud/wTob2CtRimNjFHWte2B1LL8xLhHhF0cAYuFr4CmQeYI%3d/52699325.jpg?v=000000000d4e9efc'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 6
            }
            {
              'IsPrimaryImage': false
              'Id': 52698453
              'Url': 'https://docs.rezi.cloud/8xIQmQAkiB5gvI0DQo7eIqqIQN1ikbb-L9ullH7Ypnk%3d/52698453.jpg?v=000000000d4e9f45'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 7
            }
            {
              'IsPrimaryImage': false
              'Id': 52697900
              'Url': 'https://docs.rezi.cloud/NnJY2WDMz4HB9DQ73zwg6-mgqM8RJ42scR26UTUnomk%3d/52697900.jpg?v=000000000d4e9ef2'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 8
            }
            {
              'IsPrimaryImage': false
              'Id': 52699602
              'Url': 'https://docs.rezi.cloud/ButpeyoPkEQ2JiNCCVfaH2PYr6Qm8CqniCaXvJLWKBo%3d/52699602.jpg?v=000000000d4e9f27'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 9
            }
            {
              'IsPrimaryImage': false
              'Id': 52699509
              'Url': 'https://docs.rezi.cloud/usFlDsPa9OIcMMZl8tJhyKsXbmpY1cgnkuTgOeAIqro%3d/52699509.jpg?v=000000000d4e9ec0'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 10
            }
            {
              'IsPrimaryImage': false
              'Id': 52698940
              'Url': 'https://docs.rezi.cloud/PTTRs-ndLZ-IcBXUUYvuKfuTYhsOYKBhHfe4T-EqMF4%3d/52698940.jpg?v=000000000d4e9ed4'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 11
            }
            {
              'IsPrimaryImage': false
              'Id': 52699324
              'Url': 'https://docs.rezi.cloud/HHfrDOMypJQuZVVs9KYpmxsl2MQ6oFexzDpxxnI5POg%3d/52699324.jpg?v=000000000d4e9ede'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 12
            }
            {
              'IsPrimaryImage': false
              'Id': 52699508
              'Url': 'https://docs.rezi.cloud/moDss-LcjJx1J_QAZXdVv_Py3WOSo3QnVemKBKzFijc%3d/52699508.jpg?v=000000000d4e9eac'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 13
            }
            {
              'IsPrimaryImage': false
              'Id': 52699323
              'Url': 'https://docs.rezi.cloud/fRU1t92bPGEYLvUKEN_9TsUbrtBDS7ZWTR8dqCFU4iw%3d/52699323.jpg?v=000000000d4e9eb6'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 14
            }
            {
              'IsPrimaryImage': false
              'Id': 52698941
              'Url': 'https://docs.rezi.cloud/eTK8vZp0hKVDAUo_bV19gBmVkOdInC_V-GU0ShiHCkw%3d/52698941.jpg?v=000000000d4e9ee8'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 15
            }
            {
              'IsPrimaryImage': false
              'Id': 52699510
              'Url': 'https://docs.rezi.cloud/r_0LYJr3PIHrHX6nupaT5HvO1eO64ElbD5udCPNpBsw%3d/52699510.jpg?v=000000000d4e9f1d'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 16
            }
            {
              'IsPrimaryImage': false
              'Id': 52698454
              'Url': 'https://docs.rezi.cloud/O_lXKGvUDJZARBs05L985Rl4cCHpbGGh46Cg8FQhduo%3d/52698454.jpg?v=000000000d4e9f79'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 17
            }
            {
              'IsPrimaryImage': false
              'Id': 52698455
              'Url': 'https://docs.rezi.cloud/zWhIWbpCsuJy4ST7TjFY2YDwRDlvHrcLUjhlg99qF1U%3d/52698455.jpg?v=000000000d4e9f83'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 18
            }
            {
              'IsPrimaryImage': false
              'Id': 52699329
              'Url': 'https://docs.rezi.cloud/kbtocb5E1jt3Ffzm5bgEpYSxnX3dSgYi-178nH3Tb5A%3d/52699329.jpg?v=000000000d4e9f8d'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 19
            }
            {
              'IsPrimaryImage': false
              'Id': 16868523
              'Url': 'https://docs.rezi.cloud/35G6fdvvySJbTGgYMpo209R7sxag6rgWn5D839Fffpc%3d/16868523.jpg?v=000000000d4e9d6a'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Photo'
                'SystemName': 'Photo'
              'Order': 20
            }
          ]
          'SummaryTextDescription': '<p>**USEFUL LOFT ROOM** - **VIDEO TOUR** - **ATTENTION FIRST TIME BUYERS** - VITALSPACE ESTATE AGENTS are delighted to offer for sale a spacious TWO BEDROOM PERIOD MID TERRACE property on the ever popular and conveniently located Haddon Street in Stretford. In brief this attractive, deceptively spacious property comprises; a welcoming entrance hallway, a spacious living room which opens into a well proportioned dining room and a large kitchen. To the first floor, a shaped landing provides entry into TWO GENEROUSLY SIZED BEDROOMS alongside a contemporary three piece family bathroom. A pull down ladder can be found from the second bedroom which provides entry into a converted loft room, ideal for use as a home office or study. This property benefits from gas central heating system and uPVC double glazing. Externally, to the rear of the property there is a good sized enclosed walled courtyard garden. Ideally located with great transport links including the M60 motorway network and metro link also just a short commute to Manchester city centre, Media city, the Trafford centre and Salford Quays. In a ready to move in condition and tastefully decorated throughout. Contact VitalSpace Estate Agents for further information or to arrange an internal inspection.</p>'
          'RoleType':
            'DisplayName': 'Selling'
            'SystemName': 'Selling'
          'Flags': [
            {
              'DisplayName': 'On Market'
              'SystemName': 'OnMarket'
            }
            {
              'DisplayName': 'Approved For Marketing on Websites'
              'SystemName': 'ApprovedForMarketingWebsite'
            }
            {
              'DisplayName': 'Approved For Marketing on Portals'
              'SystemName': 'ApprovedForMarketingPortals'
            }
            {
              'DisplayName': 'Approved For Marketing on Printed Media'
              'SystemName': 'ApprovedForMarketingPrint'
            }
            {
              'DisplayName': 'Offer Accepted'
              'SystemName': 'OfferAccepted'
            }
          ]
          'RoleStatus':
            'DisplayName': 'Offer Accepted'
            'SystemName': 'OfferAccepted'
          'EPC':
            'EPCType':
              'DisplayName': 'England and Wales Residential'
              'SystemName': 'EnglandWalesResidential'
            'EERCurrent': 68
            'EERPotential': 87
            'EIRCurrent': 0
            'EIRPotential': 0
            'EPARCurrent': 0
            'EPARPotential': 0
            'Image':
              'Id': 52699847
              'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce68_pe87_ci0_pi0v2.png'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'EPC'
                'SystemName': 'EPC'
              'Order': 0
          'DateInstructed': '2025-10-28T15:11:52'
          'LastUpdated': '2025-11-11T12:23:49.4775162'
          'ClosingDate': null
          'Price':
            'PriceValue': 275000
            'CurrencyCode': 'GBP'
            'PriceType': null
            'PriceQualifierType': null
            'PriceText': ''
            'AnnualGroundRent': 0
            'GroundRentReviewPeriodYears': 0
            'AnnualServiceCharge': 0
            'TenureUnexpiredYears': null
            'SharedOwnershipPercentage': null
            'SharedOwnershipRent': null
            'SharedOwnershipRentFrequency': null
          'Deposit': null
          'ViewPoints': []
          'OwningTeam':
            'Name': 'Richard Antrobus'
            'Title': 'Mr'
            'Email': 'richard@vitalspace.co.uk'
            'Phone': '07977 473111'
          'Documents': [
            {
              'Id': 52746536
              'Url': 'https://docs.rezi.cloud/T0af0oCNxRR87CZzeiYMbPcp1tLFjufEGE_qX4aaVoQ%3d/52746536.pdf?v=000000000d501ce7'
              'DocumentType':
                'DisplayName': 'Document'
                'SystemName': 'Document'
              'DocumentSubType':
                'DisplayName': 'Brochure'
                'SystemName': 'Brochure'
              'Order': 1
            }
            {
              'Id': 16868543
              'Url': 'https://docs.rezi.cloud/orlDVcNxWQAWXdrltUMF-2g005gZ1CT--kXFgDMjLjw%3d/16868543.jpg?v=000000000d4e9d74'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'Floorplan'
                'SystemName': 'Floorplan'
              'Order': 2
            }
            {
              'Id': 52699753
              'Url': 'https://dezrezcorelive.blob.core.windows.net/systempublic/epc_ce68_pe87_ci0_pi0v2.png'
              'DocumentType':
                'DisplayName': 'Image'
                'SystemName': 'Image'
              'DocumentSubType':
                'DisplayName': 'EPC'
                'SystemName': 'EPC'
              'Order': 3
            }
            {
              'Id': 52698999
              'Url': 'https://www.youtube.com/embed/BKM4jyFIUxM?si=2mA5ToYXofhI9eRC'
              'DocumentType':
                'DisplayName': 'Web Page Link'
                'SystemName': 'Link'
              'DocumentSubType':
                'DisplayName': 'Virtual Tour'
                'SystemName': 'VirtualTour'
              'Order': 4
            }
          ]
          'Fees': [ {
            'FeeId': null
            'Name': '£2500 + VAT'
            'FeeValueType':
              'DisplayName': 'Absolute'
              'SystemName': 'Absolute'
            'FeeCategoryType':
              'DisplayName': 'Commission'
              'SystemName': 'Commission'
            'FeeChargeType':
              'DisplayName': 'Applicable'
              'SystemName': 'Applicable'
            'FeeLiabilityType':
              'DisplayName': 'Vendor'
              'SystemName': 'Vendor'
            'FeeFrequency':
              'DisplayName': 'Flat Price'
              'SystemName': 'FlatPrice'
            'ApplyTax': true
            'VatValue': 0.2
            'DefaultValue': 2500
            'ScaleableFees': []
            'AdditionalFees': []
            'Notes': null
            'TransactionType':
              'DisplayName': 'Sales'
              'SystemName': 'Sales'
          } ]
          'Descriptions': [
            {
              'Tags': [ { 'Name': 'stretford' } ]
              'DescriptionType':
                'DisplayName': 'Tag'
                'SystemName': 'Tag'
              'Name': 'Tags'
              'Notes': null
            }
            {
              'Bedrooms': 2
              'Bathrooms': 1
              'Receptions': 2
              'Conservatories': 0
              'Extensions': 0
              'Others': 0
              'DescriptionType':
                'DisplayName': 'Room Count'
                'SystemName': 'RoomCount'
              'Name': null
              'Notes': null
            }
            {
              'AuthorityName': 'Trafford Council '
              'TaxBand':
                'Id': 123001
                'Name': 'Band A'
                'SystemName': 'A'
              'TaxBandAmount': 0
              'DescriptionType':
                'DisplayName': 'Local Authority'
                'SystemName': 'LocalAuthority'
              'Name': null
              'Notes': null
            }
            {
              'Gardens': 1
              'ParkingSpaces': 0
              'ParkingTypes': '(Collection)'
              'Garages': 0
              'Acreage': 0
              'AcreageMeasurementUnitType': null
              'AccessibilityTypes': '(Collection)'
              'HeatingSources': '(Collection)'
              'ElectricitySupply': '(Collection)'
              'WaterSupply': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'Sewerage': 'Dezrez.Core.DataContracts.Search.EnumSearchDataContract'
              'BroadbandConnectionTypes': '(Collection)'
              'DescriptionType':
                'DisplayName': 'Amenity'
                'SystemName': 'Amenity'
              'Name': null
              'Notes': null
            }
            {
              'Text': '<p>**USEFUL LOFT ROOM** - **ATTENTION FIRST TIME BUYERS** - VITALSPACE ESTATE AGENTS are delighted to offer for sale a spacious TWO BEDROOM PERIOD MID TERRACE property on the ever popular and conveniently located Haddon Street in Stretford. In brief this attractive, deceptively spacious property comprises; a welcoming entrance hallway, a spacious living room which opens into a well proportioned dining room and a large kitchen. To the first floor, a shaped landing provides entry into TWO GENEROUSLY SIZED BEDROOMS alongside a contemporary three piece family bathroom. A pull down ladder can be found from the second bedroom which provides entry into a converted loft room, ideal for use as a home office or study. This property benefits from gas central heating system and uPVC double glazing. Externally, to the rear of the property there is a good sized enclosed walled courtyard garden. Ideally located with great transport links including the M60 motorway network and metro link also just a short commute to Manchester city centre, Media city, the Trafford centre and Salford Quays. In a ready to move in condition and tastefully decorated throughout. Contact VitalSpace Estate Agents for further information or to arrange an internal inspection.</p>'
              'DescriptionType':
                'DisplayName': 'Text'
                'SystemName': 'Text'
              'Name': 'Main Marketing'
              'Notes': null
            }
            {
              'Text': '<p>How long have you owned the property for? 4 years +</p>\n<p>When was the roof last replaced? Yes, 2000</p>\n<p>How old is the boiler and when was it last inspected? Combination boiler installed in 2022</p>\n<p>When was the property last rewired? Re-wired in 2015 (pre ownership)</p>\n<p>Which way does the garden face? East facing rear garden</p>\n<p>Are there any extensions and if so when were they built? N/A</p>\n<p>Reasons for sale of property? Upsize</p>\n<p>If you would like to submit an offer on this property, please visit our website - www.vitalspace.co.uk/offer - and complete our online offer form.</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'FAQ'
              'Notes': null
            }
            {
              'Text': '<p>EPC GRADE:- D</p>'
              'DescriptionType':
                'DisplayName': 'Custom Text'
                'SystemName': 'CustomText'
              'Name': 'Council Tax Band'
              'Notes': null
            }
            {
              'Text': '<p>**USEFUL LOFT ROOM** - **VIDEO TOUR** - **ATTENTION FIRST TIME BUYERS** - VITALSPACE ESTATE AGENTS are delighted to offer for sale a spacious TWO BEDROOM PERIOD MID TERRACE property on the ever popular and conveniently located Haddon Street in Stretford. In brief this attractive, deceptively spacious property comprises; a welcoming entrance hallway, a spacious living room which opens into a well proportioned dining room and a large kitchen. To the first floor, a shaped landing provides entry into TWO GENEROUSLY SIZED BEDROOMS alongside a contemporary three piece family bathroom. A pull down ladder can be found from the second bedroom which provides entry into a converted loft room, ideal for use as a home office or study. This property benefits from gas central heating system and uPVC double glazing. Externally, to the rear of the property there is a good sized enclosed walled courtyard garden. Ideally located with great transport links including the M60 motorway network and metro link also just a short commute to Manchester city centre, Media city, the Trafford centre and Salford Quays. In a ready to move in condition and tastefully decorated throughout. Contact VitalSpace Estate Agents for further information or to arrange an internal inspection.</p>'
              'DescriptionType':
                'DisplayName': 'Summary Text'
                'SystemName': 'SummaryText'
              'Name': 'Summary Text'
              'Notes': null
            }
            {
              'Features': [
                {
                  'Order': 1
                  'Feature': 'Two Double Bedrooms'
                }
                {
                  'Order': 2
                  'Feature': 'Mid Period Terrace'
                }
                {
                  'Order': 3
                  'Feature': 'Gas Central Heating'
                }
                {
                  'Order': 4
                  'Feature': 'uPVC double glazing'
                }
                {
                  'Order': 5
                  'Feature': 'Ideal First Time Home'
                }
                {
                  'Order': 6
                  'Feature': 'Deceptively Spacious'
                }
                {
                  'Order': 7
                  'Feature': 'Useful Loft Room'
                }
                {
                  'Order': 8
                  'Feature': 'Convenient Location'
                }
                {
                  'Order': 9
                  'Feature': 'Immaculate condition'
                }
                {
                  'Order': 10
                  'Feature': 'Viewing Recommended'
                }
              ]
              'DescriptionType':
                'DisplayName': 'Feature'
                'SystemName': 'Feature'
              'Name': 'Features'
              'Notes': null
            }
            {
              'PropertyType':
                'DisplayName': 'Terraced House'
                'SystemName': 'TerracedHouse'
              'StyleType':
                'DisplayName': 'Period'
                'SystemName': 'Period'
              'LeaseType':
                'DisplayName': 'Leasehold'
                'SystemName': 'Leasehold'
              'AgeType': null
              'DescriptionType':
                'DisplayName': 'Style and Age'
                'SystemName': 'StyleAge'
              'Name': null
              'Notes': null
            }
            {
              'DescriptionType':
                'DisplayName': 'Charges'
                'SystemName': 'Charges'
              'Name': null
              'Notes': null
            }
          ]
          'stc': true
          'NoRooms': 5
          'SearchField': 'Haddon Street|Manchester|Stretford|M32 0JR|'
          'displayAddress': '13 Haddon Street, Stretford, Manchester, M32 0JR'
          '_id': '69282d2cfeda7300c1aa6478'
        }
      ]
    res.json property