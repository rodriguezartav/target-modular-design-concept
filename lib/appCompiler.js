(function() {
  var AppCompiler, AppModule, Utils, fs, npath;

  fs = require('fs');

  AppModule = require("./appModule");

  npath = require('path');

  Utils = require("./utils");

  /*
    Convert paths in /app folder to CommonJS modules for the Browser
    
    After resolve() is called it stores an array of AppModules, later while generating the text from
    Template.eco each module's compile() method is called.
  */


  AppCompiler = (function() {
    function AppCompiler(paths) {
      if (paths == null) {
        paths = [];
      }
      this.paths = paths;
    }

    AppCompiler.prototype.resolve = function() {
      var path, resolvedPath, _i, _len, _ref;
      this.resolvedModules = [];
      _ref = this.paths;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        path = _ref[_i];
        resolvedPath = npath.resolve(path);
        this.resolvedModules = this.resolvedModules.concat(this.walk(resolvedPath));
      }
      return this.modules = Utils.flatten(this.resolvedModules);
    };

    AppCompiler.prototype.walk = function(path, parent, result) {
      var child, exists, module, stat, _i, _len, _ref;
      if (parent == null) {
        parent = path;
      }
      if (result == null) {
        result = [];
      }
      exists = fs.existsSync(path);
      if (!exists) {
        return;
      }
      _ref = fs.readdirSync(path);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child = npath.join(path, child);
        stat = fs.statSync(child);
        if (stat.isDirectory()) {
          this.walk(child, parent, result);
        } else {
          module = new AppModule(child, parent);
          if (module.valid()) {
            result.push(module);
          }
        }
      }
      return result;
    };

    return AppCompiler;

  })();

  module.exports = AppCompiler;

}).call(this);
