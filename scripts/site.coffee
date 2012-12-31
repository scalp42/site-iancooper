url = (path) -> "https://raw.github.com/icooper/site-iancooper/gh-pages/#{url}"

loadArticles = (callback) ->
  $.ajax
    url: url 'articles/index.json'
    dataType: 'json'
    success: (data) ->
      callback data

loadArticles (articles) -> console.dir articles
