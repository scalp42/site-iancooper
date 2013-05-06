# get a Picasa data feed in JSON format
get_feed = (query, params, callback) ->
  params ?= {}
  params['alt'] = 'json'
  params['v'] = '4'
  params['max-results'] = 10000
  api_url = "https://picasaweb.google.com/data/feed/api/#{query}"
  $.getJSON api_url, params, (data, textStatus, jqXHR) ->
    console.dir
      api_url: api_url
      params: params
      data: data
      textStatus: textStatus
      jqXHR: jqXHR
    callback data

# get a list of shared albums for a user
get_albums = (user) ->
  get_feed "user/#{user}", { kind: 'album' }, (data) ->
    # nada

# get a list of photos in an album
get_photos = (user, album) ->
  get_feed "user/#{user}/albumid/#{album}", { kind: 'photo' }, (data) ->
    # nada

# get photo info
get_photo = (photo) ->
  get_feed "user/#{user}/albumid/#{album}/photoid/#{photo}", { 'full-exif': 'true' }, (data) ->
    # nada

# url scheme: 113959581740686372414/5874893911160313649/5874894047737619506/800/480
[ user, album, photo, width, height ] = window.location.hash.replace('#', '').split '/'

# set default width and height
width ?= 640
height ?= 480

console.dir
  user: user
  album: album
  photo: photo
  width: width
  height: height

get_albums user
get_photos user, album
get_photo user, album, photo