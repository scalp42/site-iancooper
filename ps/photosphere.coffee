# split hash
hash = window.location.hash.replace('#', '').split '/'

# make sure we have the right number of parameters
if hash.length is 3 or hash.length is 5

  # parse hash
  [user, album, photo, width, height] = hash

# figure it out based on G+ photo page url
else if hash.length >= 1 and (hash[0] is 'http:' or hash[0] is 'https:')

  user = hash[hash.length - 4]
  album = hash[hash.length - 2]
  photo = hash[hash.length - 1]

# if we figured it out
if hash?

  # set default width and height
  unless width? and height?
    width = $(window).width()
    height = $(window).height()

  # compose URL
  url = "https://picasaweb.google.com/data/feed/api/user/#{user}/albumid/#{album}/photoid/#{photo}"

  # query parameters
  params =
    v: '4'
    'full-exif': 'true'
    alt: 'json'

  # get image information
  $.getJSON url, params, (data) ->

    console.dir data.feed

    if data.feed?.exif$tags? and _.some(data.feed.gphoto$streamId, (i) -> i.$t is 'photosphere')

      imageurl = data.feed.media$group.media$content[0].url

      fullsize = [
        data.feed.exif$tags.exif$FullPanoWidthPixels.$t
        data.feed.exif$tags.exif$FullPanoHeightPixels.$t
      ].join ','

      croppedsize = [
        data.feed.exif$tags.exif$CroppedAreaImageWidthPixels.$t
        data.feed.exif$tags.exif$CroppedAreaImageHeightPixels.$t
      ].join ','

      offset = [
        data.feed.exif$tags.exif$CroppedAreaLeftPixels.$t
        data.feed.exif$tags.exif$CroppedAreaTopPixels.$t
      ].join ','

      displaysize = [
        width
        height
      ].join ','

      $('body').append $('<g:panoembed />')
        .attr('imageurl', imageurl)
        .attr('fullsize', fullsize)
        .attr('croppedsize', croppedsize)
        .attr('offset', offset)
        .attr('displaysize', displaysize)

      gapi.panoembed.go()

      mixpanel.track 'photosphere show'
        title: data.feed.title.$t
        url: imageurl
        credit: data.feed.media$group.media$credit[0].$t
        description: data.feed.media$group.media$description.$t
