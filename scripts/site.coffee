posts = []
max_posts = 2

load = (url, callback) ->
  $.ajax
    url: url
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data



# set up the router
router = Davis () ->
  @configure (config) ->
    config.generateRequestOnPageLoad = true
  @get '/', (request) -> show null
  @get '/latest', (request) -> show null
  @get '/about', (request) -> show 'about'
  @get '/:post', (request) -> show request.params.post

$ ->

  # load posts index
  load 'posts/index.json', (data) ->
    posts = []

    # format post dates
    for post in data.posts
      post.moment = moment post.date, 'YYYY-MM-DDTHH:mmZ'
      post.date = post.moment.format 'd MMM YYYY'
      post.dateValue = post.moment.valueOf()
      post.data = null
      posts.push post

    # sort posts from newest to oldest
    posts.sort (a, b) -> b.dateValue - a.dateValue

    # display the last few posts in a list
    for i in [0...(if posts.length > max_posts then max_posts else posts.length)]
      post = posts[i]
      $('#posts').append "<li><a href=\"#{post.slug}\">#{post.title}</a> <span class=\"date\">#{post.date}</span></li>"

    # start router once we've loaded this
    router.start()
