(function() {
  var Compilers, DependencyModule, Module, Utils, basename, detective, dirname, extname, fs, join, npath, resolve, sep, _ref,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  npath = require('path');

  fs = require('fs');

  Module = require("module");

  Utils = require("./utils");

  Compilers = require("./compilers");

  detective = require('fast-detective');

  _ref = require('path'), join = _ref.join, extname = _ref.extname, dirname = _ref.dirname, basename = _ref.basename, resolve = _ref.resolve, sep = _ref.sep;

  /*
    Dependency Wrapper Class for performing operations on each referenced dependency
  */


  DependencyModule = (function() {
    var mtime;

    DependencyModule.extensions = ['js', 'coffee'];

    DependencyModule.modulePaths = Module._nodeModulePaths(process.cwd());

    DependencyModule.invalidDirs = ['/', '.'];

    DependencyModule.repl = {
      id: 'repl',
      filename: join(process.cwd(), 'repl'),
      paths: DependencyModule.modulePaths
    };

    /**
    * Initialized a Module with filepath and parent if recursive
    *
    * @return {array}
    * @api public
    */


    function DependencyModule(filePath, parent) {
      var _ref1;
      _ref1 = this.resolveRequireCall(filePath, parent), this.id = _ref1[0], this.filename = _ref1[1];
      this.ext = extname(this.filename).slice(1);
      this.mtime = mtime(this.filename);
      this.paths = Utils.nodeModulePaths(this.filename);
    }

    /**
    * Compiles the contents of the module file if it has not changed or been compiled before
    *
    * @return {string}
    * @api public
    */


    DependencyModule.prototype.compile = function() {
      if (!this._compile || this.changed()) {
        this.mtime = mtime(this.filename);
        this._compile = Compilers[this.ext](this.filename);
      }
      return this._compile;
    };

    /**
    * Resolves the module dependencies if the file has not changed or been resolved before
    *
    * @return {array}
    * @api public
    */


    DependencyModule.prototype.modules = function() {
      if (!this._modules || this.changed()) {
        this._modules = this.resolve();
      }
      return this._modules;
    };

    /**
    * gets the file last modified time
    *
    * @return {int}
    * @api private
    */


    mtime = function(path) {
      return fs.statSync(path).mtime.valueOf();
    };

    /**
    * Checks if the file has changed comparing the modified time with the checked modified time
    *
    * @return {boolean}
    * @api private
    */


    DependencyModule.prototype.changed = function() {
      return this.mtime !== mtime(this.filename);
    };

    /**
    * Creates a new Dependency Module for each call to require
    *
    * @return {array}
    * @api private
    */


    DependencyModule.prototype.resolve = function() {
      var path, _i, _len, _ref1, _results;
      _ref1 = this.callsToRequire();
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        path = _ref1[_i];
        _results.push(new this.constructor(path, this));
      }
      return _results;
    };

    /**
    * Find calls to require()
    *
    * @return {array}
    * @api private
    */


    DependencyModule.prototype.callsToRequire = function() {
      if (this.valid()) {
        return detective(this.compile());
      } else {
        return [];
      }
    };

    DependencyModule.prototype.valid = function() {
      var _ref1;
      if (_ref1 = this.ext, __indexOf.call(this.constructor.extensions, _ref1) >= 0) {
        return true;
      }
      return false;
    };

    /**
    * Resolves a `require()` call. Pass in the name of the module where the call was made, and the path that was required.
    *
    * @return {array} - [moduleName, scriptPath]
    * @api private
    */


    DependencyModule.prototype.resolveRequireCall = function(request, parent) {
      var dir, filename, id, index, paths, _, _ref1;
      if (parent == null) {
        parent = DependencyModule.repl;
      }
      _ref1 = Module._resolveLookupPaths(request, parent), _ = _ref1[0], paths = _ref1[1];
      filename = Module._findPath(request, paths);
      if (!filename) {
        throw new Error("Cannot find module: " + request + ". Have you run `npm install .` ?");
      }
      dir = filename;
      while (__indexOf.call(DependencyModule.invalidDirs, dir) < 0 && __indexOf.call(DependencyModule.modulePaths, dir) < 0) {
        dir = dirname(dir);
      }
      if (__indexOf.call(DependencyModule.invalidDirs, dir) >= 0) {
        index = filename.lastIndexOf("" + sep + request);
        if (index > 0) {
          dir = filename.substring(0, index);
          DependencyModule.modulePaths.push(dir);
        } else {
          throw new Error("Load path not found for " + filename);
        }
      }
      id = filename.replace("" + dir + sep, '');
      return [Utils.modulerize(id, filename), filename];
    };

    return DependencyModule;

  })();

  module.exports = DependencyModule;

}).call(this);
