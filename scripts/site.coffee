window.posts = []

loadJSON = (url, callback) ->
  $.ajax
    url: url
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

$ ->

  # load posts index
  loadJSON 'posts/index.json', (data) ->
    window.posts = []

    # format post dates
    for post in data.posts
      post.moment = moment post.date, 'YYYY-MM-DDTHH:mmZ'
      post.date = post.moment.format 'd MMM YYYY'
      post.dateValue = post.moment.valueOf()
      window.posts.push post

    # sort posts from newest to oldest
    window.posts.sort (a, b) -> b.dateValue - a.dateValue

    # display the last 4 posts in a list
    for i in [0...(if window.posts.length > 4 then 4 else window.posts.length)]
      post = window.posts[i]
      $('#posts').append "<li><a href=\"#{post.slug}\">#{post.title}</a> <span class=\"date\">#{post.date}</span></li>"
