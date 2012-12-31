posts = []
config =
  max_posts: 2

# load JSON data
loadJSON = (url, callback) ->
  $.ajax
    url: url
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

# show a page
show = (slug) ->
  slug ?= 'asdf'
  console.log "slug = #{slug}"

# wait until the DOM is parsed and ready
$ ->

  # load posts index
  loadJSON 'posts/index.json', (data) ->
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
    max = if posts.length > config.max_posts then config.max_posts else posts.length
    $('#posts').append "<li><a href=\"#{posts[i].slug}\">#{posts[i].title}</a> <span class=\"date\">#{posts[i].date}</span></li>" for i in [0...max]

    # set up and start the router
    router = Davis () ->
      @configure (config) -> config.generateRequestOnPageLoad = true
      @get '/', (request) -> show null
      @get '/latest', (request) -> show null
      @get '/about', (request) -> show 'about'
      @get '/:post', (request) -> show request.params.post
    router.start()
