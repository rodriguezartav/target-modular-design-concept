(function() {
  var AppCompiler, AppModule, Compiler, Compilers, DependencyCompiler, DependencyModule, StyleCompiler, Template, Utils, basename, dirname, eco, extname, fs, join, npath, resolve, sep, _ref;

  npath = require('path');

  fs = require('fs');

  _ref = require('path'), join = _ref.join, extname = _ref.extname, dirname = _ref.dirname, basename = _ref.basename, resolve = _ref.resolve, sep = _ref.sep;

  eco = require("eco");

  Template = require("./template");

  Compilers = require("./compilers");

  AppModule = require("./appModule");

  AppCompiler = require("./appCompiler");

  DependencyModule = require("./dependencyModule");

  DependencyCompiler = require("./dependencyCompiler");

  StyleCompiler = require("./styleCompiler");

  Utils = require("./utils");

  Compiler = (function() {
    function Compiler() {}

    Compiler.generateFile = function(appPaths, lessVariablesPath, dependencyPaths) {
      var compiledFile, error, module, modules, _i, _len;
      if (lessVariablesPath == null) {
        lessVariablesPath = "";
      }
      if (dependencyPaths == null) {
        dependencyPaths = [];
      }
      compiledFile = "";
      this.generateAppModules(appPaths);
      this.generateDepedencyModules(dependencyPaths);
      this.generateStyleModules(appPaths, lessVariablesPath);
      modules = this.dependency.modules.concat(this.app.modules);
      for (_i = 0, _len = modules.length; _i < _len; _i++) {
        module = modules[_i];
        try {
          module.compilation = module.compile();
        } catch (_error) {
          error = _error;
          console.log("**************************");
          console.log(module.filename);
          console.error(error);
          console.log("**************************");
          return "console.error('R2 Compiler Error: [ " + error + " ] in " + module.filename + "')";
        }
      }
      compiledFile += Template({
        identifier: null,
        modules: modules,
        styleModules: this.style.css
      });
      return compiledFile;
    };

    Compiler.generateStyleModules = function(paths, lessVariablesPath) {
      this.style = new StyleCompiler(paths, lessVariablesPath);
      this.style.resolve();
      return this.style.compile();
    };

    Compiler.generateDepedencyModules = function(paths) {
      this.dependency = new DependencyCompiler(paths);
      this.dependency.resolve();
      return this.dependency.modules;
    };

    Compiler.generateAppModules = function(paths) {
      this.app = new AppCompiler(paths);
      this.app.resolve();
      return this.app.modules;
    };

    return Compiler;

  })();

  Compiler.AppCompiler = AppCompiler;

  Compiler.DependencyCompiler = DependencyCompiler;

  Compiler.StyleCompiler = StyleCompiler;

  Compiler.Template = Template;

  module.exports = Compiler;

}).call(this);
