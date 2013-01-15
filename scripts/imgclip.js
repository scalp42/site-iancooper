$(function() {

    var pasteHandler = function(event) {
	// check for clipboard data
	if (event.clipboardData && event.clipboardData.items) {
	    
	    // loop through the clipboard items
	    for (var i = 0; i < event.clipboardData.items.length; i++) {
		
		// the current item
		var item = event.clipboardData.items[i];

		// check for image data
		if (item.type.indexOf("image/") === 0) {
		    
		    // get the image data
		    var blob = item.getAsFile();
		    
		    // create a URL
		    var source = window.URL.createObjectURL(blob);
		    
		    // show the image
		    var image = document.createElement('img');
		    image.src = source;
		    document.getElementById('clipboard').appendChild(image);
		}
	    }
	}
    }

    // check for clipboard support
    if (window.Clipboard) {
	window.addEventListener("paste", pasteHandler);
	$('#clipboard-support').text(' (and your browser does)');
    } else {
	$('#clipboard-support').text(" (and your browser doesn't; sorry)");
    }
});
