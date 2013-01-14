# Google Maps + Fusion Tables

Here's some JavaScript code to show [the locations of all part 139 certificated airports](https://www.google.com/fusiontables/DataSource?docid=1dBmChEdPydgC_Ijad5jkDzS6TEjH0MMvuKB0g6A) on a map:

    #javascript
    // load the Google Maps API
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'http://maps.google.com/maps/api/js?sensor=false&callback=maps_loaded';
    document.body.appendChild(script);

    // callback for when the API is loaded
    function maps_loaded() {
    }

<div id="139airports"></div>