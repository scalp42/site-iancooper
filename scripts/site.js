// Generated by CoffeeScript 1.4.0
var addemails, convertgist, convertimg, find, load, markup, posts, replaceall, routing, sanitize, show, time_zones;

posts = [];

time_zones = {
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
};

moment.meridiem = function(hour) {
  return ['a.m.', 'p.m.'][Math.floor(hour / 12)];
};

convertimg = function(img) {
  var dimensions, div, ratio, url;
  img = $(img);
  url = img.attr('src');
  dimensions = url.match(/\/w([0-9]+)-h([0-9]+)-/);
  if (dimensions != null) {
    console.dir(dimensions);
    ratio = dimensions[2] / dimensions[1];
    console.log(ratio);
    div = $(document.createElement('div'));
    div.css({
      width: '100%',
      backgroundImage: "url(" + url + ")",
      backgroundSize: 'cover',
      backgroundRepeat: 'no-repeat',
      backgroundPosition: '50% 50%'
    });
    img.replaceWith(div);
    $(window).resize(function() {
      return div.css('height', "" + (div.width() * ratio) + "px");
    });
    return $(window).trigger('resize');
  }
};

convertgist = function(gist) {
  var id;
  id = gist.href.replace(/^gist\:/i, '');
  return $(gist).replaceWith("<b>" + id + "</b><script type=\"text/javascript\" src=\"https://gist.github.com/" + id + ".js\"></script>");
};

sanitize = function(data) {
  return data.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
};

replaceall = function(text, replacements) {
  var r, _i, _len;
  for (_i = 0, _len = replacements.length; _i < _len; _i++) {
    r = replacements[_i];
    text = text.replace(r[0], r[1]);
  }
  return text;
};

markup = markdown.toHTML;

load = function(url, type, callback) {
  return $.ajax({
    url: url,
    dataType: type,
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
  var article, container, date, time, tz;
  if (!post.html) {
    console.dir("loading posts/" + post.file);
    return load("posts/" + post.file, 'text', function(data) {
      var index;
      index = _.indexOf(posts, post);
      if (/\.md$/.test(post.file)) {
        posts[index].html = markup(data);
      } else {
        posts[index].html = data;
      }
      console.dir("markdown -> html saved in cache");
      return show(posts[index]);
    });
  } else {
    console.dir("using cached html for " + post.slug);
    container = $('#post');
    container.empty();
    date = post.moment.format('MMMM D, YYYY');
    time = post.moment.format('h:mm a');
    tz = time_zones[post.moment.format('ZZ')][post.moment.isDST() ? 1 : 0];
    if (!tz) {
      tz = post.moment.format('ZZ');
    }
    article = $(document.createElement('article'));
    article.append("<header><h1>" + post.title + "</h1><h2>" + date + " @ " + time + " " + tz + "</h2></header>");
    article.append("<section>" + post.html + "</section>");
    $('section > h1', article).first().remove();
    container.append(article);
    $('img[src$="#stretch-me"]', container).each(function() {
      return convertimg(this);
    });
    $('a[href^="gist:"]', container).each(function() {
      return convertgist(this);
    });
    return addemails(container);
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

addemails = function(context) {
  if (context == null) {
    context = $('body');
  }
  return $('a[href="#email"]').attr('href', 'mailto:me+website@iancooper.name');
};

$(function() {
  addemails();
  $('nav > header > h1').css('cursor', 'pointer').click(function(event) {
    event.preventDefault();
    return self.location.href = 'http://iancooper.name/';
  });
  return load('posts/index.json', 'json', function(data) {
    var i, max, max_recent, now, post, _i, _j, _len, _ref;
    posts = [];
    _ref = data.posts;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      post = _ref[_i];
      post.moment = moment(post.date, 'YYYY-MM-DDTHH:mmZZ');
      post.date = post.moment.format('D MMM YYYY');
      post.dateValue = post.moment.valueOf();
      post.html = null;
      posts.push(post);
    }
    posts.sort(function(a, b) {
      return b.dateValue - a.dateValue;
    });
    max_recent = $('#posts').attr('data-max-recent');
    max = posts.length > max_recent ? max_recent : posts.length;
    now = moment();
    for (i = _j = 0; 0 <= max ? _j < max : _j > max; i = 0 <= max ? ++_j : --_j) {
      if (posts[i].status === 'published' && now >= posts[i].moment) {
        $('#posts').append("<li><a href=\"" + posts[i].slug + "\">" + posts[i].title + " <span class=\"date\">" + posts[i].date + "</span></a></li>");
      } else {
        i--;
      }
    }
    return routing({
      fn: {
        latest: function(request) {
          var _k, _ref1, _results;
          now = moment();
          _results = [];
          for (i = _k = 0, _ref1 = posts.length; 0 <= _ref1 ? _k <= _ref1 : _k >= _ref1; i = 0 <= _ref1 ? ++_k : --_k) {
            if (posts[i].status === 'published' && now >= posts[i].moment) {
              request.redirect("/" + posts[i].slug);
              break;
            } else {
              _results.push(void 0);
            }
          }
          return _results;
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
