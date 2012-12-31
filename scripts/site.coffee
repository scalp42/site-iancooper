posts = []
time_zones =
    # UTC       ST     DT
    '-1000': [ 'HAST', no ]
    '-0900': [ 'AKST', 'HADT' ]
    '-0800': [ 'PST',  'AKDT' ]
    '-0700': [ 'MST',  'PDT'  ]
    '-0600': [ 'CST',  'MDT'  ]
    '-0500': [ 'EST',  'CDT'  ]
    '-0400': [ 'AST',  'EDT'  ]
    '-0330': [ 'NST',  no     ]
    '-0300': [ no,    'ADT'   ]
    '-0230': [ no,    'NDT'   ]

# set my preferred am/pm format
moment.meridiem = (hour) -> ['a.m.', 'p.m.'][Math.floor hour / 12]

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
  unless post.html
    console.dir "loading posts/#{post.file}"
    load "posts/#{post.file}", no, (markdown) ->
      index = _.indexOf posts, post
      posts[index].html = markup markdown
      console.dir "markdown -> html saved in cache"
      show posts[index]
  else
    console.dir "using cached html for #{post.slug}"
    $('#post').empty()
    date = post.moment.format 'MMMM D, YYYY'
    time = post.moment.format 'h:mm a'
    tz = time_zones[post.moment.format 'ZZ'][if post.moment.isDST() then 1 else 0]
    tz = post.moment.format 'ZZ' unless tz
    article = $ document.createElement 'article'
    article.append "<header><h1>#{post.title}</h1><h2>#{date} @ #{time} #{tz}</h2></header>"
    article.append "<section>#{post.html}</section>"
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
      post.date = post.moment.format 'D MMM YYYY'
      post.dateValue = post.moment.valueOf()
      post.html = null
      posts.push post

    # sort posts from newest to oldest
    posts.sort (a, b) -> b.dateValue - a.dateValue

    # display the last few posts in a list
    max_recent = $('#posts').attr 'data-max-recent'
    max = if posts.length > max_recent then max_recent else posts.length
    $('#posts').append "<li><a href=\"#{posts[i].slug}\">#{posts[i].title} <span class=\"date\">#{posts[i].date}</span></a></li>" for i in [0...max]

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