npath        = require('path')
fs           = require('fs')
Module = require("module")
Utils = require("./utils")
Compilers = require("./compilers")
detective = require('fast-detective')
{join, extname, dirname, basename, resolve, sep} = require('path')


###
  Dependency Wrapper Class for performing operations on each referenced dependency
###
class DependencyModule

  @extensions: ['js', 'coffee']
  @modulePaths = Module._nodeModulePaths(process.cwd())
  @invalidDirs = ['/', '.']

  @repl =
    id: 'repl'
    filename: join(process.cwd(), 'repl')
    paths: DependencyModule.modulePaths

  constructor: (filePath, parent) ->
    [@id, @filename] = @resolveRequireCall(filePath, parent)
    @ext   = extname(@filename).slice(1)
    @mtime = mtime(@filename)
    @paths = Utils.nodeModulePaths(@filename)

  compile: ->
    if not @_compile or @changed()
      @mtime    = mtime(@filename)
      @_compile = Compilers[@ext](@filename)
    @_compile

  modules: ->
    if not @_modules or @changed()
      @_modules = @resolve()
    @_modules

  mtime = (path) ->
    fs.statSync(path).mtime.valueOf()

  changed: ->
    @mtime isnt mtime(@filename)

  resolve: ->
    for path in @callsToRequire()
      new @constructor(path, @)

  # Find calls to require()
  callsToRequire: ->
    if @valid()
      detective(@compile())
    else []

  valid: ->
    return true if @ext in @constructor.extensions
    return false
      
  # Resolves a `require()` call. Pass in the name of the module where
  # the call was made, and the path that was required.
  # Returns an array of: [moduleName, scriptPath]
  resolveRequireCall: (request, parent = DependencyModule.repl) ->
    [_, paths]  = Module._resolveLookupPaths(request, parent)
    filename    = Module._findPath(request, paths)
    throw new Error("Cannot find module: #{request}. Have you run `npm install .` ?") unless filename

    # Find package root relative to localModules folder
    dir = filename
    while dir not in DependencyModule.invalidDirs and dir not in DependencyModule.modulePaths
      dir = dirname(dir)

    # make sure we have a valid directory path
    if dir in DependencyModule.invalidDirs
      # possibly a linked module?
      index = filename.lastIndexOf("#{sep}#{request}")
      if index > 0 
        dir = filename.substring(0,index)
        DependencyModule.modulePaths.push(dir)
      else
        throw new Error("Load path not found for #{filename}")

    # create the id/scriptPath array
    id = filename.replace("#{dir}#{sep}", '')
    [Utils.modulerize(id, filename), filename]
    
module.exports = DependencyModule