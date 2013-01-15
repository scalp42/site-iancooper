// Generated by CoffeeScript 1.4.0
/*
# imgclip.coffee
#
# Ian Cooper
# 15 Jan 2013
#
# http://iancooper.name/clipboard-access-in-javascript
*/

$(function() {
  var showImage;
  showImage = function(data) {
    return $('#clipboard').css('background-image', window.URL.createObjectURL(data));
  };
  if (window.Clipboard) {
    return window.addEventListener('paste', function(event) {
      var item, _i, _len, _ref, _results;
      if (event.clipboardData && event.clipboardData.items) {
        _ref = event.clipboardData.items;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item.type.indexOf('image/') === 0) {
            _results.push(showImage(item.getAsFile()));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    });
  }
});
