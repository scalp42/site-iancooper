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

# find a post by slug
find = (slug) ->
  _.find posts, (post) -> post.slug is slug

# show a page
show = (slug) ->
  slug ?= posts[0].slug
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

    # redirect to the latest post
    latest = (request) -> request.redirect "/#{posts[0].slug}"

    # set up the request router
    router = Davis () ->

      # set router options
      @configure (config) ->
        config.generateRequestOnPageLoad = yes
        config.handleRouteNotFound = yes

      # go to the latest page
      @bind 'routeNotFound', latest
      @get '/', latest
      @get '/latest', latest

      # show the about page
      @get '/about', (request) -> show 'about'

      # show selected post
      @get '/:post', (request) ->
        post = find request.params.post
        show post

    # start the router
    router.start()
