window.posts = []

loadJSON = (callback) ->
  $.ajax
    url: 'posts/index.json'
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

$ ->
  loadJSON (data) ->
    window.posts = []
    for post in data.posts
      post.moment = moment post.date, 'YYYY-MM-DDTHH:mmZ'
      post.date = post.moment.format 'd MMM YYYY'
      post.dateValue = post.moment.valueOf()
      window.posts.push post

    window.posts.sort (a, b) -> b.dateValue - a.dateValue

    for post in window.posts
      $('#posts').append "<li><a href=\"#{post.slug}\">#{post.title}</a> <span class=\"date\">#{post.date}</span></li>"
