# Clipboard Access in JavaScript

The [Clipboard API](http://www.w3.org/TR/clipboard-apis/) (still a draft) provides a way for us to use clipboard data within JavaScript.  We're still limited in that we can't peek at the clipboard any time that we want, but we can respond to the `paste` event and obtain the clipboard contents at that time.  In this post, I'm specifically looking for image data.

Let's start by checking to see if our browser supports the Clipboard API.  If it does<span id="clipboard-support"></span>, then we'll register an event listener for the `paste` event.

    #javascript
    // check for clipboard support
    if (window.Clipboard) {
        window.addEventListener('paste', pasteHandler);
    }

Let's look at the event handler now.  We'll start by checking to see if there's any clipboard data available:

    #javascript
    var pasteHandler = function(event) {
        // check for incoming clipboard data
        if (event.clipboardData && event.clipboardData.items) {

Now that we've established that there is clipboard data available, we'll get the clipboard contents and look through it to see if there's any image data.  The `type` property of a clipboard item will give us the MIME type of the clipboard contents, so we'll use anything that starts with `image/`.

    #javascript
            // loop through the clipboard items
            for (var i = 0; i < event.clipboardData.items.length; i++) {
    
                // the current item
                var item = event.clipboardData.items[i];
                
                // check to see if it's an image
                if (item.type.indexOf('image') === 0) {

<script type="text/javascript" src="/scripts/imgclip.js"></script>
<div id="clipboard"></div>