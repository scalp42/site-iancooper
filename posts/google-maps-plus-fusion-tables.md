# Google Maps + Fusion Tables

Let's say that we'd like to show [the locations of all part 139 certificated airports](https://www.google.com/fusiontables/DataSource?docid=1dBmChEdPydgC_Ijad5jkDzS6TEjH0MMvuKB0g6A) on a map.  We've separated the airports into two categories: public use (green markers) and private use (red markers).

<div id="139airports" style="width: 100%; height: 500px"></div>

Here's the code that was used:

    #javascript
    // load the Google Maps API
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'http://maps.google.com/maps/api/js?sensor=false&callback=maps_loaded';
    document.body.appendChild(script);

    // callback for when the API is loaded
    function maps_loaded() {
    }

<script type="text/javascript" src="scripts/139airports.js"></script>
