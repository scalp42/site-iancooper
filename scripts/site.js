// Generated by CoffeeScript 1.4.0
var config, find, loadJSON, posts, show;

posts = [];

config = {
  max_posts: 2
};

loadJSON = function(url, callback) {
  return $.ajax({
    url: url,
    dataType: 'json',
    error: function() {
      return console.dir(arguments);
    },
    success: function(data) {
      return callback(data);
    }
  });
};

find = function(slug) {
  return _.find(posts, function(post) {
    return post.slug === slug;
  });
};

show = function(slug) {
  if (slug == null) {
    slug = posts[0].slug;
  }
  return console.log("slug = " + slug);
};

$(function() {
  return loadJSON('posts/index.json', function(data) {
    var i, latest, max, post, router, selected, _i, _j, _len, _ref;
    posts = [];
    _ref = data.posts;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      post = _ref[_i];
      post.moment = moment(post.date, 'YYYY-MM-DDTHH:mmZ');
      post.date = post.moment.format('d MMM YYYY');
      post.dateValue = post.moment.valueOf();
      post.data = null;
      posts.push(post);
    }
    posts.sort(function(a, b) {
      return b.dateValue - a.dateValue;
    });
    max = posts.length > config.max_posts ? config.max_posts : posts.length;
    for (i = _j = 0; 0 <= max ? _j < max : _j > max; i = 0 <= max ? ++_j : --_j) {
      $('#posts').append("<li><a href=\"" + posts[i].slug + "\">" + posts[i].title + "</a> <span class=\"date\">" + posts[i].date + "</span></li>");
    }
    latest = function(request) {
      return request.redirect("/" + posts[0].slug);
    };
    selected = function(request) {
      console.dir(request.params[0]);
      return post = find(request.params[0]);
    };
    router = Davis(function() {
      this.configure(function(config) {
        config.generateRequestOnPageLoad = true;
        return config.handleRouteNotFound = true;
      });
      this.bind('routeNotFound', latest);
      this.get('/', latest);
      this.get('/latest', latest);
      this.get('/about', function(request) {
        return show('about');
      });
      this.get('/:post', selected);
      return this.get(':post', selected);
    });
    return router.start();
  });
});
