# Google Maps + Fusion Tables

Let's say that we'd like to show the locations of all [14 CFR part 139 certificated airports](http://www.faa.gov/airports/airport_safety/part139_cert/?p1=what) on a map.  We've separated the airports into two categories: public use (green markers) and private use (red markers).

<div id="139airports" style="width: 100%; height: 500px"></div>
<script type="text/javascript" src="scripts/139airports.js"></script>

I used some [freely-available data from the FAA](http://www.faa.gov/airports/airport_safety/airportdata_5010/) and put it in a [Google Fusion Table](https://www.google.com/fusiontables/DataSource?docid=1dBmChEdPydgC_Ijad5jkDzS6TEjH0MMvuKB0g6A) data store.  Now we can use a [Fusion Tables layer](https://developers.google.com/maps/documentation/javascript/layers#FusionTables) from [the Google Maps API](https://developers.google.com/maps/documentation/javascript/) to show the right markers in the right places.  Here's the code.

    #javascript
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
            info = '&lt;strong&gt;' +
                   event.row.FacilityName.value + ' (' +
                   event.row.LocationID.value + ')&lt;/strong&gt;&lt;br /&gt;' +
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

_You can also see the [code on GitHub](https://github.com/icooper/site-iancooper/blob/gh-pages/scripts/139airports.js).  Feel free to use it as you'd like! Please keep in mind, though, that code samples are provided as-is and with no guarantees by myself or my employer._
