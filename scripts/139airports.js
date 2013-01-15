$(function() {

    // load the Google Maps API
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'http://maps.google.com/maps/api/js?sensor=false&callback=demo139airports_ready';
    document.body.appendChild(script);
    
    // callback for when the API is loaded
    window.demo139airports_ready = function() {
	
	// create the map
	var map = new google.maps.Map(document.getElementById('139airports'), {
	    zoom: 4,
	    center: new google.maps.LatLng(37.997, -95.801),
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	
	// create the FusionTables layer and add it to the map
	var airports = new google.maps.FusionTablesLayer({
	    suppressInfoWindows: true,
	    map: map,
	    query: {
		select: 'Latitude',
		from: '1dBmChEdPydgC_Ijad5jkDzS6TEjH0MMvuKB0g6A'
	    },
	    styles: [ { markerOptions: { iconName: 'large_red' } } ]
	});

	// add a click handler to the icons
	google.maps.event.addListener(airports, 'click', function(event) {

	    console.dir(event);

	    // get the location of the click
	    var location = new google.maps.LatLng(event.row.Latitude.value,
						  event.row.Longitude.value);
	    
	    // put together some text to go in the info window
	    info = 'Airport ID: <strong>' +
		   event.row.LocationID.value + '</strong><hr />' +
		   event.row.FacilityName.value + '<br />' +
		   event.row.City.value + ', ' +
		   event.row.State.value + '<hr />'
	           'Elevation: ' + event.row.Elevation.value + ' MSL<br />' + 
		   'Sectional Chart: ' + event.row.ChartName.value

	    // create the info window
	    infowindow = new google.maps.InfoWindow({
		content: info,
		position: location,
		pixelOffset: event.pixelOffset
	    });

	    // add a click listener so we can close the info window
	    google.maps.event.addListener(infowindow, 'closeclick', function() {
		infowindow.close()
	    });

	    // show the info window
	    infowindow.open(map);
	});
    }
});
