$(function() {

    var pasteHandler = function(event) {
	// check for clipboard data
	if (event.clipboardData && event.clipboardData.items) {
	    
	    // loop through the clipboard items
	    for (var i = 0; i < event.clipboardData.items.length; i++) {
		
		// the current item
		var item = event.clipboardData.items[i];

		// check for image data
		if (item.type.indexOf('image/') === 0) {
		    
		    // get the data as an object URL
		    var objURL = window.URL.createObjectURL(item.getAsFile());
		    
		    // create an image object from the object URL
		    var image = new Image();
		    image.src = objURL;

		    // add the image to the document
		    document.body.appendChild(image);
		}
	    }
	}
    }

    // check for clipboard support
    if (window.Clipboard) {
	window.addEventListener('paste', pasteHandler);
	console.log('clipboard access is supported in this browser');
    } else {
	console.log('clipboard access IS NOT supported in this browser');
    }
});
