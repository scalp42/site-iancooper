var config, find, load, markup, posts, routing, show;
posts = [];
config = {
  max_posts: 3,
  time_zones: {
    '-1000': ['HAST', false],
    '-0900': ['AKST', 'HADT'],
    '-0800': ['PST', 'AKDT'],
    '-0700': ['MST', 'PDT'],
    '-0600': ['CST', 'MDT'],
    '-0500': ['EST', 'CDT'],
    '-0400': ['AST', 'EDT'],
    '-0330': ['NST', false],
    '-0300': [false, 'ADT'],
    '-0230': [false, 'NDT']
  }
};
moment.meridiem = function(hour) {
  return ['a.m.', 'p.m.'][Math.floor(hour / 12)];
};
markup = function(markdown) {
  var _ref;
    if ((_ref = window.Converter) != null) {
    _ref;
  } else {
    window.Converter = new Markdown.Converter();
  };
  return window.Converter.makeHtml(markdown);
};
load = function(url, json, callback) {
    if (json != null) {
    json;
  } else {
    json = false;
  };
  return $.ajax({
    url: url,
    dataType: json ? 'json' : 'text',
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
show = function(post) {
  var article, date, time, tz;
  if (!post.html) {
    console.dir("loading posts/" + post.file);
    return load("posts/" + post.file, false, function(markdown) {
      var index;
      index = _.indexOf(posts, post);
      posts[index].html = markup(markdown);
      console.dir("markdown -> html saved in cache");
      return show(posts[index]);
    });
  } else {
    console.dir("using cached html for " + post.slug);
    $('#post').empty();
    date = post.moment.format('MMMM d, YYYY');
    time = post.moment.format('h:mm a');
    tz = config.time_zones[post.moment.format('ZZ')][post.moment.isDST() ? 1 : 0];
    if (!tz) {
      tz = post.moment.format('ZZ');
    }
    article = $(document.createElement('article'));
    article.append("<header><h1>" + post.title + "</h1><h2>" + date + " @ " + time + " " + tz + "</h2></header>");
    article.append("<section>" + post.html + "</section>");
    $('section > h1', article).first().remove();
    return $('#post').append(article);
  }
};
routing = function(map) {
  var router;
  return router = new Davis(function() {
    var route, _i, _len, _ref, _results;
    this.configure(function(config) {
      config.generateRequestOnPageLoad = true;
      return config.handleRouteNotFound = true;
    });
    this.bind('routeNotFound', function(request) {
      return request.redirect('/');
    });
    _ref = map.routes;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      route = _ref[_i];
      _results.push(this.get(route.pattern, map.fn[route.fn]));
    }
    return _results;
  });
};
$(function() {
  return load('posts/index.json', true, function(data) {
    var i, max, post, _i, _len, _ref;
    posts = [];
    _ref = data.posts;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      post = _ref[_i];
      post.moment = moment(post.date, 'YYYY-MM-DDTHH:mmZZ');
      post.date = post.moment.format('d MMM YYYY');
      post.dateValue = post.moment.valueOf();
      post.html = null;
      posts.push(post);
    }
    posts.sort(function(a, b) {
      return b.dateValue - a.dateValue;
    });
    max = posts.length > config.max_posts ? config.max_posts : posts.length;
    for (i = 0; 0 <= max ? i < max : i > max; 0 <= max ? i++ : i--) {
      $('#posts').append("<li><a href=\"" + posts[i].slug + "\">" + posts[i].title + " <span class=\"date\">" + posts[i].date + "</span></a></li>");
    }
    return routing({
      fn: {
        latest: function(request) {
          return request.redirect("/" + posts[0].slug);
        },
        selected: function(request) {
          post = find(request.params.post);
          if (post != null) {
            return show(post);
          } else {
            return request.redirect("/latest");
          }
        }
      },
      routes: [
        {
          pattern: '/',
          fn: 'latest'
        }, {
          pattern: '/latest',
          fn: 'latest'
        }, {
          pattern: 'latest',
          fn: 'latest'
        }, {
          pattern: '/:post',
          fn: 'selected'
        }, {
          pattern: ':post',
          fn: 'selected'
        }
      ]
    });
  });
});