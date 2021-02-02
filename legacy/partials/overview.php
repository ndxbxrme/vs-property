   <div class="container">
    <h2><span>{{ Properties.current().Address.Street }}, {{ Properties.current().Address.Locality }}</span></h2>
    <section class="description row">
      <div class="col-sm-8 col-md-8 overview-left">

        <!-- Description -->
        <h3>Description</h3>
        <div ng-bind-html="Properties.current()['Main Marketing'].Text"></div>

        <!-- Mobile Property Menu -->
        <div class="mob-menu">
            <ul class="mob-prop-nav">
                <li ng-show="Properties.current().RoleType.SystemName == 'Letting'"><a href="/new-tenancy-application/" class="medium orange button"><i class="fa fa-fw fa-pencil-square-o"></i> Apply to Rent</a></li>

                <li><a href="#view-prop" fancybox="" id="inline" class="medium purple button fancybox"><i class="fa fa-fw fa-calendar-plus-o"></i>  Arrange Viewing</a></li>
                <li ng-show="Properties.current().RoleType.SystemName == 'Selling'"><a href="/conveyancing" class="medium orange button"><i class="fa fa-fw fa-pencil-square-o"></i>  Conveyancing Quote</a></li>

                <!-- Form Modal -->
                <div style="display:none" class="fancybox-hidden">
                    <div id="view-prop">
                        <h2 class="col-sm-12"><i class="fa fa-phone"></i> Arrange a Viewing</h2>
                        <p>One of our team will be able to help you find your future home</p>
                                  <div class="form">
                                    <iframe ng-src="{{getFormUrl()}}" scrolling="no" style="min-height:400px"></iframe>
                                  </div>
                                  <div class="view-details">
                                      <p>i am interested in...</p>
                            <img ng-src="{{ makeImageUrl(Properties.current().Images[0].Url,320) }}" width="100%"/>
                            <p class="address">{{ Properties.current().Address.Street }}<br> {{ Properties.current().Address.Locality }}</p>

                            <p>Alternatively, contact our office</p>
                            <ul class="branch-details">
                                <li>Urmston Branch</li>
                                <li>Tel: <a href="tel:0161 747 7807">0161 747 7807</a></li>
                                <li>Email: <a href="mailto:urmston@vitalspace.co.uk">urmston@vitalspace.co.uk</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <li ng-show="hasDocument('Floorplan')" ui-sref-active="active"><a href="" ui-sref="layout(getPropertyUrlData())" data-toggle="tooltip" title="Floorplan" class="medium grey button">
                        <i class="fa fa-object-group fa-fw"></i>
                        <span>Floorplan</span></a></li>
                <li ng-show="hasDocument('Virtual Tour')" title="play Video Walkthrough"><a href="{{ getTrustedUrl( getDocument('Virtual Tour').Url) }}" class="medium grey button">
                        <i class="fa fa-video-camera fa-fw"></i>
                        <span>Video Walkthrough</span></a>
                </li>
                <li ui-sref-active="active"><a href="" ui-sref="maps(getPropertyUrlData())" data-toggle="tooltip" title="Maps" class="medium grey button">
                        <i class="fa fa-map-o fa-fw"></i>
                        <span>Maps</span></a></li>
                <li ui-sref-active="active"><a href="" ui-sref="schools(getPropertyUrlData())" data-toggle="tooltip" title="Schools" class="medium grey button">
                        <i class="fa fa-graduation-cap fa-fw"></i>
                        <span>Schools</span></a></li>
                <li ui-sref-active="active"><a href="" ui-sref="transport(getPropertyUrlData())" data-toggle="tooltip" title="Transport" class="medium grey button">
                        <i class="fa fa-road fa-fw"></i>
                        <span>Transport</span></a></li>
                <li ng-show="hasDocument('Brochure')" ui-sref-active="active"><a href="" ui-sref="brochure(getPropertyUrlData())" data-toggle="tooltip" title="Brochure" class="medium grey button">
                        <i class="fa fa-file-pdf-o fa-fw"></i>
                        <span>Brochure</span></a></li>
                <li ui-sref-active="active"><a href="" ui-sref="taxbands(getPropertyUrlData())" data-toggle="tooltip" title="Council Tax" class="medium grey button">
                        <i class="fa fa-gbp fa-fw"></i>
                        <span>Council Tax</span></a></li>
              </ul>
        </div>

        <!-- More Info -->
        <section class="row">
          <div class="col-sm-12 col-md-8">
            <h4>More Information</h4>
            <ul class="more-info">
              <li>Property Status: <strong><span class="orange">{{ Properties.current().RoleStatus.DisplayName }}</span></strong></li>
              <li ng-if="Properties.current().RoleType.SystemName == 'Selling'">Lease Type: <strong><span class="orange">{{ getDescription('StyleAge').LeaseType.DisplayName }}</span></strong></li>
              <li ng-if="Properties.current().RoleType.SystemName == 'Letting'">Available Date: <strong><span class="orange">{{ Properties.current().AvailableDate | date : 'd-MMM-yy'}}</span></strong></li>
              <li ng-show="hasDescription('Furnishing')">Furnishing: <strong><span class="orange">{{ getDescription('Furnishing').FurnishLevel.DisplayName }}</span></strong></li>
              <li ng-show="hasDescription('LocalAuthority')">Local Authority: <strong><span class="orange">{{ getDescription('LocalAuthority').AuthorityName }}</span></strong></li>
              <li ng-show="hasDescription('LocalAuthority')">Council Tax Band: <strong><span class="orange">{{ getDescription('LocalAuthority').TaxBand.Name }}</span></strong></li>
              <li ng-show="hasAllowances('Pets')">Pets Allowed: <strong><span class="orange">{{ getAllowances('Pets').Value.DisplayName }}</span></strong></li>
            </ul>
          </div>
        </section>

        <section class="col-sm-12 col-md-10 cta">

        <!-- Arrange Booking -->
          <h4>Interested in this property?</h4>

          <p>Call our Urmston branch for further information.</p>
          <ul class="contact-info">
            <li>Telephone: <strong><span class="orange phoneno"><a href="tel:0161 747 7807">0161 747 7807</a></span></strong></li>
            <li>Email: <strong><span class="orange"><a href="mailto:urmston@vitalspace.co.uk">urmston@vitalspace.co.uk</a></span></strong></li>
          </ul>

          

		<div class="mob-hide">
		<a ng-show="Properties.current().RoleType.SystemName == 'Letting'" href="/new-tenancy-application/" class="medium orange button mob-hide rentbut"><i class="fa fa-pencil-square-o"></i> Apply to Rent</a>
        <a ng-show="Properties.current().RoleType.SystemName == 'Selling'" href="/conveyancing" class="medium orange button mob-hide conveybut"><i class="fa fa-pencil-square-o"></i> Conveyancing Quote</a>
          <a href="#view-prop" fancybox="" id="inline" class="medium purple button fancybox viewingbut"><i class="fa fa-calendar-plus-o"></i>  Arrange Viewing</a>
<!--          <a class="map-pin" ng-href="/area-guides/{{ Properties.current().Address.Locality | slugify}}-estate-agents">View Area Guide</a>-->

          <!-- Form Modal -->
            <div style="display:none" class="fancybox-hidden">
                <div id="view-prop">
                    <h2 class="col-sm-12"><i class="fa fa-phone"></i> Arrange a Viewing</h2>
                    <p>One of our team will be able to help you find your future home</p>
                                      <div class="form">
                                        <iframe ng-src="{{getFormUrl()}}" scrolling="no" style="min-height:400px"></iframe>
                                      </div>
                                      <div class="view-details">
                                          <p>i am interested in...</p>
                                <img ng-src="{{ makeImageUrl(Properties.current().Images[0].Url,320) }}" width="100%"/>
                                <p class="address">{{ Properties.current().Address.Street }}<br> {{ Properties.current().Address.Locality }}</p>

                                <p>Alternatively, contact our office</p>
                                <ul class="branch-details">
                                    <li>Urmston Branch</li>
                                    <li>Tel: <a href="tel:0161 747 7807">0161 747 7807</a></li>
                                    <li>Email: <a href="mailto:urmston@vitalspace.co.uk">urmston@vitalspace.co.uk</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
               </div>
            </section>


      </div>
	      <div class="col-sm-4 col-md-4 mob-hide">
	        <!-- Summary -->
	        <h3>Summary</h3>
	        <ul class="rooms">
	            <li ng-show="hasDescription('RoomCount')"><img src="/public/img/int/icons/bed-icon.png" alt="Bedroom Icon"/>{{ getDescription('RoomCount').Bedrooms }}</li>
	            <li ng-show="hasDescription('RoomCount')"><img class="bath" src="/public/img/int/icons/bath-icon.png" alt="bathroom Icon"/>{{ getDescription('RoomCount').Bathrooms }}</li>
	            <li ng-show="hasDescription('RoomCount')"><img src="/public/img/int/icons/reception-icon.png" alt="Reception Icon"/>{{ getDescription('RoomCount').Receptions }}</li>
	        </ul>
	        <!-- Features -->
	        <h3>Features</h3>
	        <ul class="boxed">
	          <li ng-repeat="feature in Properties.current()['Features'].Features"><i class="fa fa-check-circle-o"></i> {{ feature.Feature | titleCase }}</li>
	        </ul>
	        <!-- Similar Properties -->
	        <div class="prop-similar" ng-controller="PropSimilar">
				<h3>Similar Properties</h3>
				<similar-properties properties="Properties.current().similar"></similar-properties>
			</div>

	      </div>

    </section>
</div>
