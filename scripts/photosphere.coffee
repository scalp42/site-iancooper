# split hash
hash = window.location.hash.replace('#', '').split '/'

# make sure we have the right number of parameters
if hash.length is 3 or hash.length is 5

  # parse hash
  [user, album, photo, width, height] = hash

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
  $.getJSON url, params, (data, textStatus, jqXHR) ->
    console.dir
      url: url
      params: params
      data: data
      textStatus: textStatus
      jqXHR: jqXHR

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
