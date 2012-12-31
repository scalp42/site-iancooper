window.posts = []
window.config =
  max_posts: 2

# load JSON data
load = (url, callback) ->
  $.ajax
    url: url
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

# show a page
show = (slug) ->
  slug ?= 'asdf'
  console.log "slug = #{slug}"

# set up the router
window.router = Davis () ->
  @get '/', (request) -> show null
  @get '/latest', (request) -> show null
  @get '/about', (request) -> show 'about'
  @get '/:post', (request) -> show request.params.post

$ ->

  # load posts index
  load 'posts/index.json', (data) ->
    window.posts = []

    # format post dates
    for post in data.posts
      post.moment = moment post.date, 'YYYY-MM-DDTHH:mmZ'
      post.date = post.moment.format 'd MMM YYYY'
      post.dateValue = post.moment.valueOf()
      post.data = null
      window.posts.push post

    # sort posts from newest to oldest
    window.posts.sort (a, b) -> b.dateValue - a.dateValue

    # display the last few posts in a list
    max = if window.posts.length > window.config.max_posts then window.config.max_posts else window.posts.length
    $('#posts').append "<li><a href=\"#{window.posts[i].slug}\">#{window.posts[i].title}</a> <span class=\"date\">#{window.posts[i].date}</span></li>" for i in [0...max]

    # start router once we've loaded this
    window.router.configure (config) ->
      config.generateRequestOnPageLoad = true
    window.router.start()
