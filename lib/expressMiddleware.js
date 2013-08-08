(function() {
  var Middleware;

  Middleware = (function() {
    function Middleware() {}

    Middleware.compileJavascript = function(fileName) {};

    Middleware.compileCss = function() {};

    return Middleware;

  })();

  module.exports = function(paths) {
    return function(req, res, next) {
      if (req.path === path.javascript) {
        res.send(Middleware.compileJavascript(req.path));
      }
      if (req.path === path.css) {
        res.send(Middleware.compileJavascript(req.path));
      }
      return next();
    };
  };

}).call(this);
