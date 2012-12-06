
class Site
  constructor: (user, repo) ->
    @gh = new GitHub user, repo
    @articles = { }
    if Modernizr.localstorage
      @cache = window.localStorage
    else
      @cache = no

  articles: (callback) ->
    if @articles.length is 0
      @gh.tree 'gh-pages', (data) =>
        found is no
        for item in data.tree and found is no
          if item.path is 'articles'
            found = yes
            @gh.tree item.sha, (data) =>
              for
    else
      callback @articles

class GitHub
  warn = (f, url, args) ->
    console.warn "GitHub.#{f}(): could not retrieve '#{url}'."
    console.dir args

  constructor: (user, repo) ->
    @api = "https://api.github.com/repos/#{user}/#{repo}/git"
    @www = "https://github.com/#{user}/#{repo}/blob/gh-pages"
    @warn = GitHub.warn

  tree: (id, callback) ->
    url = "#{@api}/trees/#{id}"
    $.ajax
      url: url
      dataType: 'jsonp'
      error: => @warn 'tree', url, arguments
      success: (data) => callback data.tree

  blob: (id, callback) ->
    url = "#{@api}/blobs/#{id}"
    $.ajax
      url: url
      dataType: 'jsonp'
      error: => @warn 'blob', url, arguments
      success: (data) =>
        data.content = window.atob data.content if data.encoding is 'base64'
        callback data

  data: (url, callback) ->
    url = "#{@www}/#{url}"
    $.ajax
      url: url
      dataType: 'html'
      error: => @warn 'blob', url, arguments
      success: callback

site = new Site

articles = site.articles()
console.dir articles
