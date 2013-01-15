$(function() {

    var pasteHandler = function(event) {
	// check for clipboard data
	if (event.clipboardData) {
	    
	    // get the clipboard contents
	    var items = event.clipboardData.items;
	    if (items) {
		
		console.dir(items);

		// loop through the clipboard items
		for (var i = 0; i < items.length; i++) {
		    
		    // check for image data
		    if (items[i].type.indexOf("image") !== -1) {

			// get the image data
			var blob = items[i].getAsFile();

			// create a URL
			var source = window.URL.createObjectURL(blob);

			// show the image
			var image = document.createElement('img');
			img.src = source;
			document.getElementById('clipboard').appendChild(image);
		    }
		}
		
	    }
	}
    }

    // check for clipboard support
    if (window.Clipboard) {
	window.addEventListener("paste", pasteHandler);
    }
});
