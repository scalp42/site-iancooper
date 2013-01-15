$(function() {

    // load the Google Maps API
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'http://maps.google.com/maps/api/js?sensor=false&callback=demo139airports_ready';
    document.body.appendChild(script);
    
    // callback for when the API is loaded
    window.demo139airports_ready = function() {
	
	var map = new google.maps.Map(document.getElementById('139airports'), {
	    zoom: 4,
	    center: new google.maps.LatLng(37.997, -95.801),
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	
	var airports = new google.maps.FusionTablesLayer({
	    suppressInfoWindows: true,
	    map: map,
	    query: {
		select: 'Latitude',
		from: '1dBmChEdPydgC_Ijad5jkDzS6TEjH0MMvuKB0g6A'
	    },
	    styles: [ { markerOptions: { iconName: 'large_red' } } ]
	});
	
    }
});
