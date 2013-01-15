$(function() {

    // load the Google Maps API
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'http://maps.google.com/maps/api/js?sensor=false&callback=demo139airports_ready';
    document.body.appendChild(script);
    
    // callback for when the API is loaded
    window.demo139airports_ready = function() {
	
	// create the map, centered on the continental US
	var map = new google.maps.Map(document.getElementById('139airports'), {
	    zoom: 4,
	    center: new google.maps.LatLng(37.997, -95.801),
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	
	// create a layer for private airports
	var airports = new google.maps.FusionTablesLayer({
	    suppressInfoWindows: true,
	    map: map,
	    query: {
		select: 'Latitude',
		from: '1dBmChEdPydgC_Ijad5jkDzS6TEjH0MMvuKB0g6A'
	    },
	    styles: [ {
		where: "Use = 'PR'", // private use airports
		markerOptions: { iconName: 'large_red' } 
	    }, {
		where: "Use = 'PU'", // public use airports
		markerOptions: { iconName: 'large_green' }
	    } ]
	});

	// define a click handler to the icons
	google.maps.event.addListener(airports, 'click', function(event) {

	    // get the location of the click
	    var location = new google.maps.LatLng(event.row.Latitude.value,
						  event.row.Longitude.value);
	    
	    // put together some text to go in the info window
	    info = '<strong>' +
		   event.row.FacilityName.value + ' (' +
		   event.row.LocationID.value + ')</strong><br />' +
		   event.row.City.value + ', ' +
		   event.row.State.value

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
