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

# stretch images
convertimg = (img) ->
  img = $ img
  url = img.attr 'src'
  dimensions = url.match /\/w([0-9]+)-h([0-9]+)-/
  if dimensions?
    console.dir dimensions
    ratio = dimensions[2] / dimensions[1]
    console.log ratio
    div = $ document.createElement 'div'
    div.css
      width: '100%'
      backgroundImage: "url(#{url})"
      backgroundSize: 'cover'
      backgroundRepeat: 'no-repeat'
      backgroundPosition: '50% 50%'
    img.replaceWith div
    $(window).resize () -> div.css 'height', "#{div.width() * ratio}px"
    $(window).trigger 'resize'

# include gists
convertgist = (gist) ->
  gist = $ gist
  file = gist.attr 'alt'
  id = gist.attr('src').match /^gist\:([0-9a-z]+)$/i
  if id?
    load "https://api.github.com/gists/#{id[1]}", 'jsonp', (data) ->
      if data.data.files?
        pre = $(document.createElement 'pre')
        content = sanitize data.data.files[file].content
        content = vglize content if /\.rpf$/.test file
        pre.html content
        gist.parent().replaceWith pre
      else
        gist.replaceWith "<a href=\"https://gist.github.com/#{id[1]}#file-#{file.replace /\./g, '-'}\"><code>#{file}</code></a>"

# escape tags and ampersands
sanitize = (data) ->
  data.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace />/g, '&gt;'

# multiple regex replacements
replaceall = (text, replacements) ->
  for r in replacements
    text = text.replace r[0], r[1]
  text

# stupid keyword highlighting for VGL
vglize = (code) ->
  replaceall " #{code} ", [
    [ /(\W)([A-Z_]+)(\W)/g, '$1<span class="vgl-keyword">$2</span>$3' ]
    [ /^\s/, '' ]
    [ /\s$/, '' ]
  ]

# convert markdown to html
markup = (markdown) ->
  window.Converter ?= new Markdown.Converter()
  window.Converter.makeHtml markdown

# load data
load = (url, type, callback) ->
  $.ajax
    url: url
    dataType: type
    error: () -> console.dir arguments
    success: (data) -> callback data

# find a post by slug
find = (slug) ->
  _.find posts, (post) -> post.slug is slug

# show a post
show = (post) ->
  unless post.html
    console.dir "loading posts/#{post.file}"
    load "posts/#{post.file}", 'text', (data) ->
      index = _.indexOf posts, post

      # check extension to determine file format
      if /\.md$/.test post.file
        # convert from markdown
        posts[index].html = markup data
      else
        # assume post is already html
        posts[index].html = data

      console.dir "markdown -> html saved in cache"
      show posts[index]
  else
    console.dir "using cached html for #{post.slug}"
    container = $ '#post'
    container.empty()
    date = post.moment.format 'MMMM D, YYYY'
    time = post.moment.format 'h:mm a'
    tz = time_zones[post.moment.format 'ZZ'][if post.moment.isDST() then 1 else 0]
    tz = post.moment.format 'ZZ' unless tz
    article = $ document.createElement 'article'
    article.append "<header><h1>#{post.title}</h1><h2>#{date} @ #{time} #{tz}</h2></header>"
    article.append "<section>#{post.html}</section>"
    $('section > h1', article).first().remove()
    container.append article

    # process special tags
    $('img[src$="#stretch-me"]', container).each () -> convertimg @
    $('img[src^="gist:"]', container).each () -> convertgist @

    # add email links
    addemails container

# set up the routes
routing = (map) ->
  router = new Davis () ->
    @configure (config) ->
      config.generateRequestOnPageLoad = yes
      config.handleRouteNotFound = yes
    @bind 'routeNotFound', (request) -> request.redirect '/'
    for route in map.routes
      @get route.pattern, map.fn[route.fn]

# add email links
addemails = (context) ->
  context ?= $ 'body'
  $('a[href="#email"]').attr 'href', 'mailto:me+website@iancooper.name'

# wait until the DOM is parsed and ready
$ ->

  # add email links
  addemails()

  # make the site title clickable
  $('nav > header > h1').css('cursor', 'pointer').click (event) ->
    event.preventDefault()
    self.location.href = 'http://iancooper.name/'

  # load posts index
  load 'posts/index.json', 'json', (data) ->
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
    now = moment()
    for i in [0...max]

      # only show published posts from the past, no future or non-published posts
      if posts[i].status is 'published' and now >= posts[i].moment
        $('#posts').append "<li><a href=\"#{posts[i].slug}\">#{posts[i].title} <span class=\"date\">#{posts[i].date}</span></a></li>"
      else
        i--

    # set up the routing
    routing
      fn:
        # show the latest post
        latest: (request) ->
          now = moment()
          for i in [0..posts.length]
            if posts[i].status is 'published' and now >= posts[i].moment
              request.redirect "/#{posts[i].slug}"
              break

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