loadArticles = (callback) ->
  $.ajax
    url: 'articles/index.json'
    dataType: 'json'
    success: (data) -> callback data
    error: -> console.dir arguments

$ -> loadArticles (articles) -> console.dir articles
