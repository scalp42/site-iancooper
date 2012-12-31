posts = []
max_posts = 2

loadJSON = (url, callback) ->
  $.ajax
    url: url
    dataType: 'json'
    error: () -> console.dir arguments
    success: (data) -> callback data

# set up davis app
app = Davis () ->
  @get '/:post', (request) -> alert request.params.post

$ ->

  # start davis
  app.start()

  # load posts index
  loadJSON 'posts/index.json', (data) ->
    posts = []

    # format post dates
    for post in data.posts
      post.moment = moment post.date, 'YYYY-MM-DDTHH:mmZ'
      post.date = post.moment.format 'd MMM YYYY'
      post.dateValue = post.moment.valueOf()
      post.data = null
      posts.push post

    # sort posts from newest to oldest
    posts.sort (a, b) -> b.dateValue - a.dateValue

    # display the last few posts in a list
    for i in [0...(if posts.length > max_posts then max_posts else posts.length)]
      post = posts[i]
      $('#posts').append "<li><a href=\"#{post.slug}\">#{post.title}</a> <span class=\"date\">#{post.date}</span></li>"
