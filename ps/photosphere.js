// Generated by CoffeeScript 1.4.0
var album, hash, height, params, photo, url, user, width;

hash = window.location.hash.replace('#', '').split('/');

if (hash.length === 3 || hash.length === 5) {
  user = hash[0], album = hash[1], photo = hash[2], width = hash[3], height = hash[4];
} else if (hash.length >= 1 && (hash[0] === 'http:' || hash[0] === 'https:')) {
  user = hash[hash.length - 4];
  album = hash[hash.length - 2];
  photo = hash[hash.length - 1];
}

if (hash != null) {
  if (!((width != null) && (height != null))) {
    width = $(window).width();
    height = $(window).height();
  }
  url = "https://picasaweb.google.com/data/feed/api/user/" + user + "/albumid/" + album + "/photoid/" + photo;
  params = {
    v: '4',
    'full-exif': 'true',
    alt: 'json'
  };
  $.getJSON(url, params, function(data, textStatus, jqXHR) {
    var croppedsize, displaysize, fullsize, imageurl, offset, _ref;
    if ((((_ref = data.feed) != null ? _ref.exif$tags : void 0) != null) && _.some(data.feed.gphoto$streamId, function(i) {
      return i.$t === 'photosphere';
    })) {
      imageurl = data.feed.media$group.media$content[0].url;
      fullsize = [data.feed.exif$tags.exif$FullPanoWidthPixels.$t, data.feed.exif$tags.exif$FullPanoHeightPixels.$t].join(',');
      croppedsize = [data.feed.exif$tags.exif$CroppedAreaImageWidthPixels.$t, data.feed.exif$tags.exif$CroppedAreaImageHeightPixels.$t].join(',');
      offset = [data.feed.exif$tags.exif$CroppedAreaLeftPixels.$t, data.feed.exif$tags.exif$CroppedAreaTopPixels.$t].join(',');
      displaysize = [width, height].join(',');
      $('body').append($('<g:panoembed />').attr('imageurl', imageurl).attr('fullsize', fullsize).attr('croppedsize', croppedsize).attr('offset', offset).attr('displaysize', displaysize));
      return gapi.panoembed.go();
    }
  });
}
