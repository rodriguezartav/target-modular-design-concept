(function() {
  var compilers, eco, fs, less;

  fs = require('fs');

  eco = require('eco');

  less = require('less');

  compilers = {};

  /*
    Helper Object to easily call a compile method according to file extension
  */


  compilers.coffee = function(path) {
    var cs, err;
    try {
      cs = require('coffee-script');
      try {
        return cs.compile(fs.readFileSync(path, 'utf8'), {
          filename: path,
          literate: false
        });
      } catch (_error) {
        err = _error;
        err.message = "Coffeescript Error: " + err.message;
        err.path = "Coffeescript Path:  " + path;
        if (err.location) {
          err.path = err.path + ":" + (err.location.first_line + 1);
        }
        throw err;
      }
    } catch (_error) {
      err = _error;
    }
  };

  compilers.js = function(path) {
    return fs.readFileSync(path, 'utf8');
  };

  compilers.eco = function(path) {
    var content;
    content = eco.precompile(fs.readFileSync(path, 'utf8'));
    return "var content = " + content + ";\nmodule.exports = content;";
  };

  compilers.jeco = function(path) {
    var content;
    content = eco.precompile(fs.readFileSync(path, 'utf8'));
    return "module.exports = function(values, data){ \n  var $  = jQuery, result = $();\n  values = $.makeArray(values);\n  data = data || {};\n  for(var i=0; i < values.length; i++) {\n    var value = $.extend({}, values[i], data, {index: i});\n    var elem  = $((" + content + ")(value));\n    elem.data('item', value);\n    $.merge(result, elem);\n  }\n  return result;\n};";
  };

  require.extensions['.jeco'] = require.extensions['.eco'];

  compilers.style = {
    css: function(path, callback) {
      var contents;
      contents = fs.readFileSync(path, 'utf8');
      return callback(false, contents);
    },
    less: function(path, callback) {
      var contents;
      contents = fs.readFileSync(path, 'utf8');
      return less.render(contents, callback);
    }
  };

  module.exports = compilers;

}).call(this);
