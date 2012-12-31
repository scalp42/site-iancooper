posts = []
config =
  max_posts: 3

# convert markdown to html
markup = (markdown) ->
  window.Converter ?= new Markdown.Converter()
  window.Converter.makeHtml markdown

# load data
load = (url, json, callback) ->
  json ?= no
  $.ajax
    url: url
    dataType: if json then 'json' else 'text'
    error: () -> console.dir arguments
    success: (data) -> callback data

# find a post by slug
find = (slug) ->
  _.find posts, (post) -> post.slug is slug

# show a post
show = (post) ->
  $('#post').empty()
  load "posts/#{post.file}", no, (markdown) ->
    date = post.moment.format 'MMMM d, YYYY'
    time = post.moment.format 'h:mm A ZZ'
    article = $ document.createElement 'article'
    article.append "<header><h1>#{post.title}</h1><h2>#{date} @ #{time}</h2></header>"
    article.append "<section>#{markup markdown}</section>"
    $('section > h1', article).first().remove()
    $('#post').append article

# set up the routes
routing = (map) ->
  router = new Davis () ->
    @configure (config) ->
      config.generateRequestOnPageLoad = yes
      config.handleRouteNotFound = yes
    @bind 'routeNotFound', (request) -> request.redirect '/'
    for route in map.routes
      @get route.pattern, map.fn[route.fn]

# wait until the DOM is parsed and ready
$ ->

  # load posts index
  load 'posts/index.json', yes, (data) ->
    posts = []

    # format post dates
    for post in data.posts
      post.moment = moment post.date, 'YYYY-MM-DDTHH:mmZZ'
      post.date = post.moment.format 'd MMM YYYY'
      post.dateValue = post.moment.valueOf()
      post.data = null
      posts.push post

    # sort posts from newest to oldest
    posts.sort (a, b) -> b.dateValue - a.dateValue

    # display the last few posts in a list
    max = if posts.length > config.max_posts then config.max_posts else posts.length
    $('#posts').append "<li><a href=\"#{posts[i].slug}\">#{posts[i].title}</a> <span class=\"date\">#{posts[i].date}</span></li>" for i in [0...max]

    # set up the routing
    routing
      fn:
        # show the latest post
        latest: (request) -> request.redirect "/#{posts[0].slug}"

        # show the selected post
        selected: (request) ->
          post = find request.params.post
          if post?
            show post
          else
            request.redirect "/latest"

      # pattern-route map
      routes: [
        { pattern: '/', fn: 'latest' }
        { pattern: '/latest', fn: 'latest' }
        { pattern: 'latest', fn: 'latest' }
        { pattern: '/:post', fn: 'selected' }
        { pattern: ':post', fn: 'selected' }
      ]