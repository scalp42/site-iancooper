window.posts = []

loadJSON = (callback) ->
  $.ajax
    url: 'articles/index.json'
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

$ ->
  loadJSON (data) ->
    window.posts = []
    for post in data.posts
      post.moment = moment post.date, "YYYY-MM-DDTHH:mmZ"
      window.posts.push post
    console.dir window.posts
