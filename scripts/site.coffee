loadArticles = (callback) ->
  $.ajax
    url: 'articles/index.json'
    dataType: 'json'
    success: (data) ->
      callback data

loadArticles (articles) -> console.dir articles
