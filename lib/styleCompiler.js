(function() {
  var Compilers, StyleCompiler, Utils, fs, npath;

  fs = require('fs');

  npath = require('path');

  Utils = require("./utils");

  Compilers = require("./compilers");

  /*
    Convert paths in /app folder to CommonJS modules for the Browser
    
    After resolve() is called it stores an array of AppModules, later while generating the text from
    Template.eco each module's compile() method is called.
  */


  StyleCompiler = (function() {
    function StyleCompiler(paths, lessVariablesPath) {
      if (paths == null) {
        paths = [];
      }
      this.paths = paths;
      this.lessVariablesPath = lessVariablesPath;
      this.css = "";
    }

    StyleCompiler.prototype.compile = function() {
      var callback, compiler, module, _i, _len, _ref,
        _this = this;
      _ref = this.modules;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        module = _ref[_i];
        compiler = Compilers.style[module.ext];
        callback = function(err, css) {
          if (err) {
            throw err;
          }
          return _this.css += css;
        };
        compiler(module.path, this.lessVariablesPath, callback);
      }
      return this.css = this.css.replace(/(\r\n|\n|\r)/gm, "");
    };

    StyleCompiler.prototype.resolve = function() {
      var path, resolvedPath, _i, _len, _ref;
      this.resolvedModules = [];
      _ref = this.paths;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        path = _ref[_i];
        resolvedPath = npath.resolve(path);
        if (!fs.existsSync(resolvedPath)) {
          console.error("PATH DOES NOT EXIST " + resolvedPath);
          throw "PATH DOES NOT EXIST " + resolvedPath;
        }
        this.resolvedModules = this.resolvedModules.concat(this.walk(resolvedPath));
      }
      return this.modules = Utils.flatten(this.resolvedModules);
    };

    StyleCompiler.prototype.walk = function(path, parent, result) {
      var child, exists, ext, stat, _i, _len, _ref;
      if (parent == null) {
        parent = path;
      }
      if (result == null) {
        result = [];
      }
      exists = fs.existsSync(path);
      if (!exists) {
        return [];
      }
      _ref = fs.readdirSync(path);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        child = npath.join(path, child);
        stat = fs.statSync(child);
        if (stat.isDirectory()) {
          this.walk(child, parent, result);
        } else {
          ext = npath.extname(child).slice(1);
          if (ext === "css" || ext === "less") {
            result.push({
              path: child,
              ext: ext
            });
          }
        }
      }
      return result;
    };

    return StyleCompiler;

  })();

  module.exports = StyleCompiler;

}).call(this);
