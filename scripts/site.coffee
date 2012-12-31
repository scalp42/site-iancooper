window.index = []

loadJSON = (callback) ->
  $.ajax
    url: 'articles/index.json'
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

$ ->
  loadJSON (data) ->
    window.index = []
    for article in data.articles
      article.moment = moment article.date, "YYYY-MM-DDTHH:mm"
      window.index.push article
    console.dir window.index
