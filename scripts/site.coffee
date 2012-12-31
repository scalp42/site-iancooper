window.index = []

loadJSON = (callback) ->
  $.ajax
    url: 'articles/index.json'
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

$ ->
  loadJSON (data) -> console.dir data.articles
