# Clipboard Access in JavaScript

The [Clipboard API](http://www.w3.org/TR/clipboard-apis/) (still a draft) provides a way for us to use clipboard data within JavaScript.  We're still limited in that we can't peek at the clipboard any time that we want, but we can respond to the `paste` event and obtain the clipboard contents at that time.

Let's start by checking to see if our browser supports the Clipboard API:

    #javascript
    // check for clipboard support
    if (window.Clipboard)

<script type="text/javascript" src="/scripts/imgclip.js"></script>
<div id="clipboard"></div>