// Generated by CoffeeScript 1.4.0
var GitHub, Site, site;

Site = (function() {
  var parseName;

  function Site(user, repo) {
    this.gh = new GitHub(user, repo);
    this.articles = [];
  }

  parseName = function(name) {
    var date, parts;
    parts = name.match(/^(([0-9]{4})-([0-9]{2})-([0-9]{2}))-([0-9]{2})([0-9]{2})-(.+)\.([a-z]{2,4})$/i);
    console.dir(parts);
    if (parts !== null) {
      date = moment("" + parts[2] + "-" + parts[3] + "-" + parts[4] + "T");
      return {
        date: date,
        slug: parts[5],
        type: parts[6],
        url: parts[0]
      };
    }
  };

  Site.prototype.loadArticles = function(callback) {
    var _this = this;
    if (this.articles.length === 0) {
      return this.gh.tree('gh-pages', function(data) {
        var found, item, _i, _len, _ref, _results;
        console.dir(data);
        found = false;
        _ref = data.tree;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item.path === 'articles' && found === false) {
            found = true;
            _results.push(_this.gh.tree(item.sha, function(data) {
              var article, attr, _j, _len1, _ref1;
              _ref1 = data.tree;
              for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                article = _ref1[_j];
                if (article.type === 'blob') {
                  attr = parseName(article.path);
                  if (typeof attr === 'object') {
                    _this.articles.push(attr);
                  }
                }
              }
              return callback(_this.articles);
            }));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    } else {
      return callback(this.articles);
    }
  };

  return Site;

})();

GitHub = (function() {
  var warn;

  warn = function(f, url, args) {
    console.warn("GitHub." + f + "(): could not retrieve '" + url + "'.");
    return console.dir(args);
  };

  function GitHub(user, repo) {
    this.api = "https://api.github.com/repos/" + user + "/" + repo + "/git";
    this.www = "https://raw.github.com/" + user + "/" + repo + "/gh-pages";
    this.warn = GitHub.warn;
  }

  GitHub.prototype.tree = function(id, callback) {
    var url,
      _this = this;
    url = "" + this.api + "/trees/" + id;
    return $.ajax({
      url: url,
      dataType: 'jsonp',
      error: function() {
        return _this.warn('tree', url, arguments);
      },
      success: function(data) {
        return callback(data.data);
      }
    });
  };

  GitHub.prototype.blob = function(id, callback) {
    var url,
      _this = this;
    url = "" + this.api + "/blobs/" + id;
    return $.ajax({
      url: url,
      dataType: 'jsonp',
      error: function() {
        return _this.warn('blob', url, arguments);
      },
      success: function(data) {
        if (data.encoding === 'base64') {
          data.data.content = window.atob(data.content);
        }
        return callback(data.data);
      }
    });
  };

  GitHub.prototype.raw = function(url, callback) {
    var _this = this;
    url = "" + this.www + "/" + url;
    return $.ajax({
      url: url,
      dataType: 'html',
      error: function() {
        return _this.warn('blob', url, arguments);
      },
      success: callback
    });
  };

  return GitHub;

})();

site = new Site('icooper', 'site-iancooper');

site.loadArticles(function(articles) {
  return console.dir(articles);
});
