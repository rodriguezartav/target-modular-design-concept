###*
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
###

###!
* Module dependencies.
###
npath        = require('path')
fs           = require('fs')
{join, extname, dirname, basename, resolve, sep} = require('path')
Utils = require("./utils")
Compilers = require("./compilers")

class AppModule

  ###*
   * Initializer and sets the filename and id of the module, this is a recursive function
   *
   * @param {filename} js
   * @param {parent} js
   * @api public
   ###
  constructor: (@filename, @parent) ->
    @ext = npath.extname(@filename).slice(1)
    @details="{}"
    @id  = Utils.modulerize(@filename.replace(npath.join(@parent, npath.sep), ''))
    
    if fs.existsSync(@parent + "/component.json")
      fileContents = fs.readFileSync(@parent + "/component.json")
      componentInfo = JSON.parse fileContents
      @details = fileContents
      @id =  componentInfo.namespace + "/" + componentInfo.name + "/" + @id

  ###*
   * Compiles the contents of the file
   *
   * @return {String}
   * @api public
   ###
  compile: ->
    Compilers[@ext]?(@filename)

  valid: ->
    return true if Compilers[@ext]
    return false
    
module.exports = AppModule