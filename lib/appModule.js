/**
* # App Module
* 
*  Module for performing operations on each module located in path
*
*     var compiler = require('Compiler')
*     var appModule = require('Compiler.appModule')
*
* Dox
* Copyright (c) 2010 TJ Holowaychuk <tj@vision-media.ca>
* MIT Licensed
*/


/*!
* Module dependencies.
*/


(function() {
  var AppModule, Compilers, Utils, basename, dirname, extname, fs, join, npath, resolve, sep, _ref;

  npath = require('path');

  fs = require('fs');

  _ref = require('path'), join = _ref.join, extname = _ref.extname, dirname = _ref.dirname, basename = _ref.basename, resolve = _ref.resolve, sep = _ref.sep;

  Utils = require("./utils");

  Compilers = require("./compilers");

  AppModule = (function() {
    /**
     * Initializer and sets the filename and id of the module, this is a recursive function
     *
     * @param {filename} js
     * @param {parent} js
     * @api public
    */

    function AppModule(filename, parent) {
      this.filename = filename;
      this.parent = parent;
      this.ext = npath.extname(this.filename).slice(1);
      this.id = Utils.modulerize(this.filename.replace(npath.join(this.parent, npath.sep), ''));
    }

    /**
     * Compiles the contents of the file
     *
     * @return {String}
     * @api public
    */


    AppModule.prototype.compile = function() {
      var _name;
      return typeof Compilers[_name = this.ext] === "function" ? Compilers[_name](this.filename) : void 0;
    };

    AppModule.prototype.valid = function() {
      if (Compilers[this.ext]) {
        return true;
      }
      return false;
    };

    return AppModule;

  })();

  module.exports = AppModule;

}).call(this);
