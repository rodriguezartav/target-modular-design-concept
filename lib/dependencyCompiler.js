(function() {
  var DependencyCompiler, DependencyModule, Utils, fs, npath;

  fs = require('fs');

  DependencyModule = require("./dependencyModule");

  npath = require('path');

  Utils = require("./utils");

  /*
    Convert referened dependencies from node_modules to CommonJS modules for the Browser
    
    After resolve() is called it stores an array of DependencyModules, later while generating the text from
    Template.eco each module's compile() method is called.
  */


  DependencyCompiler = (function() {
    function DependencyCompiler(paths) {
      if (paths == null) {
        paths = [];
      }
      this.paths = paths;
    }

    DependencyCompiler.prototype.resolve = function() {
      var path;
      this.firstModules || (this.firstModules = (function() {
        var _i, _len, _ref, _results;
        _ref = this.paths;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          path = _ref[_i];
          _results.push(new DependencyModule(path));
        }
        return _results;
      }).call(this));
      return this.modules = this.deepResolve(this.firstModules);
    };

    DependencyCompiler.prototype.deepResolve = function(modules, result, search) {
      var module, _i, _len;
      if (modules == null) {
        modules = [];
      }
      if (result == null) {
        result = [];
      }
      if (search == null) {
        search = {};
      }
      for (_i = 0, _len = modules.length; _i < _len; _i++) {
        module = modules[_i];
        if (!(!search[module.filename])) {
          continue;
        }
        search[module.filename] = true;
        result.push(module);
        this.deepResolve(module.modules(), result, search);
      }
      return result;
    };

    return DependencyCompiler;

  })();

  module.exports = DependencyCompiler;

}).call(this);
