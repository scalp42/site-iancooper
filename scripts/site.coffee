url = (path) -> "https://raw.github.com/icooper/site-iancooper/gh-pages/#{url}"

loadArticles = (callback) ->
  $.ajax
    url: url 'articles/index.json'
    dataType: 'json'

loadArticles (articles) -> console.dir articles
