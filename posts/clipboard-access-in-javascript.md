# Clipboard Access in JavaScript

The [Clipboard API](http://www.w3.org/TR/clipboard-apis/) (still a draft) provides a way for us to use clipboard data within JavaScript.  We're still limited in that we can't peek at the clipboard any time that we want, but we can respond to the `paste` event and obtain the clipboard contents at that time.  In this post, I'm specifically looking for image data.

Let's start by checking to see if our browser supports the Clipboard API.  If it does, then we'll register an event listener for the `paste` event.

    #javascript
    // check for clipboard support
    if (window.Clipboard) {
        window.addEventListener('paste', pasteHandler);
    }

Let's look at the event handler now.  We'll start by checking to see if there's any clipboard data available:

    #javascript
    // our paste event handler
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
                if (item.type.indexOf('image/') === 0) {

The clipboard item object has a `getAsFile()` function that will return the image data.  We can't use this data directly, but we can turn it into an object URL using the [`window.URL.createObject` function](https://developer.mozilla.org/en-US/docs/DOM/window.URL.createObjectURL).  Once we have the object URL, we can display the image:

    #javascript
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

So let's give it a try!  Copy some image data to the clipboard, and then switch back to this browser window and press `Ctrl-V` or `Command-V` (or whatever the usual "paste" shortcut is for your operating system).  You should see the image appear below:

<style type="text/css">
  #clipboard {
    width: 100%;
    height: 300px;
    border-width: 4px;
    border-style: dashed;
    border-color: #ccc;
    background-position: center center;
    background-repeat: no-repeat;
  }
</style>
<div id="clipboard"></div>

_The above code is available [in this gist](https://gist.github.com/42eafd1b00a18c824b97).  Feel free to use it as you'd like!  Please keep in mind, though, that code samples are provided as-is and with no guarantees by myself or my employer._

<script type="text/javascript" src="/scripts/imgclip.js"></script>