npath        = require('path')
fs           = require('fs')
{join, extname, dirname, basename, resolve, sep} = require('path')
Utils = require("./utils")
Compilers = require("./compilers")

###
  App Wrapper Class for performing operations on each referenced dependency
###
class AppModule

  mtime = (path) ->
    fs.statSync(path).mtime.valueOf()

  constructor: (@filename, @parent) ->
    @ext = npath.extname(@filename).slice(1)
    @id  = Utils.modulerize(@filename.replace(npath.join(@parent, npath.sep), ''))

  compile: ->
    Compilers[@ext](@filename)

  valid: ->
    !!Compilers[@ext]
    
module.exports = AppModule