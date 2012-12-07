class Site
  constructor: (user, repo) ->
    @gh = new GitHub user, repo
    @articles = []

  parseName = (name) ->
    parts = name.match /^([0-9]{4}-[0-9]{2}-[0-9]{2})-([0-9]{2})([0-9]{2})-(.+)\.([a-z]{2,4})$/i
    console.dir parts
    if parts isnt null
      date = moment "#{parts[1]}T#{parts[2]}:#{parts[3]}" 'YYYY-MM-DDTHH:mm'
      {
        date: date
        slug: parts[4]
        type: parts[5]
        url: parts[0]
      }
    else
      false

  loadArticles: (callback) ->
    if @articles.length is 0
      @gh.tree 'gh-pages', (data) =>
        console.dir data
        found = no
        for item in data.tree
          if item.path is 'articles' and found is no
            found = yes
            @gh.tree item.sha, (data) =>
              for article in data.tree
                if article.type is 'blob'
                  attr = parseName article.path
                  if typeof attr is 'object'
                    @articles.push attr
              callback @articles
    else
      callback @articles

class GitHub
  warn = (f, url, args) ->
    console.warn "GitHub.#{f}(): could not retrieve '#{url}'."
    console.dir args

  constructor: (user, repo) ->
    @api = "https://api.github.com/repos/#{user}/#{repo}/git"
    @www = "https://raw.github.com/#{user}/#{repo}/gh-pages"
    @warn = GitHub.warn

  tree: (id, callback) ->
    url = "#{@api}/trees/#{id}"
    $.ajax
      url: url
      dataType: 'jsonp'
      error: => @warn 'tree', url, arguments
      success: (data) => callback data.data

  blob: (id, callback) ->
    url = "#{@api}/blobs/#{id}"
    $.ajax
      url: url
      dataType: 'jsonp'
      error: => @warn 'blob', url, arguments
      success: (data) =>
        data.data.content = window.atob data.content if data.encoding is 'base64'
        callback data.data

  raw: (url, callback) ->
    url = "#{@www}/#{url}"
    $.ajax
      url: url
      dataType: 'html'
      error: => @warn 'blob', url, arguments
      success: callback

site = new Site 'icooper', 'site-iancooper'
site.loadArticles (articles) -> console.dir articles
