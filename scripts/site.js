// Generated by CoffeeScript 1.4.0
var loadArticles;

loadArticles = function(callback) {
  return $.ajax({
    url: 'articles/index.json',
    dataType: 'json',
    success: function(data) {
      return callback(data);
    },
    error: function() {
      return console.dir(arguments);
    }
  });
};

$(function() {
  return loadArticles(function(articles) {
    return console.dir(articles);
  });
});
