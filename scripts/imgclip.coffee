###
# imgclip.coffee
#
# Ian Cooper
# 15 Jan 2013
#
# http://iancooper.name/clipboard-access-in-javascript
###

$ ->

  showImage = (data) ->
    $('#clipboard').css 'background-image', "url(#{window.URL.createObjectURL data})"

  if window.Clipboard
    window.addEventListener 'paste', (event) ->
      if event.clipboardData and event.clipboardData.items
        for item in event.clipboardData.items
          showImage item.getAsFile() if item.type.indexOf('image/') is 0
