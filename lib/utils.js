(function() {
  var Module, Utils, basename, dirname, extname, join, npath, resolve, sep, _ref;

  Module = require('module');

  npath = require('path');

  _ref = require('path'), join = _ref.join, extname = _ref.extname, dirname = _ref.dirname, basename = _ref.basename, resolve = _ref.resolve, sep = _ref.sep;

  /*
    Helper Methods used in compiling Modules for the browser
  */


  Utils = (function() {
    function Utils() {}

    Utils.isAbsolute = function(path) {
      return /^\//.test(path);
    };

    Utils.flatten = function(array, results) {
      var item, _i, _len;
      if (results == null) {
        results = [];
      }
      for (_i = 0, _len = array.length; _i < _len; _i++) {
        item = array[_i];
        if (Array.isArray(item)) {
          Utils.flatten(item, results);
        } else {
          results.push(item);
        }
      }
      return results;
    };

    Utils.toArray = function(value) {
      if (value == null) {
        value = [];
      }
      if (Array.isArray(value)) {
        return value;
      } else {
        return [value];
      }
    };

    Utils.nodeModulePaths = function(filename) {
      return Module._nodeModulePaths(dirname(filename));
    };

    Utils.modulerize = function(id, filename) {
      var ext, moduleName;
      if (filename == null) {
        filename = id;
      }
      ext = npath.extname(filename);
      moduleName = join(dirname(id), basename(id, ext));
      return moduleName.replace(/\\/g, '/');
    };

    return Utils;

  })();

  module.exports = Utils;

}).call(this);
