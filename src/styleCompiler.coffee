fs           = require('fs')
npath        = require('path')
Utils = require("./utils")
Compilers = require("./compilers")


###
  Convert paths in /app folder to CommonJS modules for the Browser
  
  After resolve() is called it stores an array of AppModules, later while generating the text from
  Template.eco each module's compile() method is called.
  
###
class StyleCompiler
  
  constructor: (paths = []) ->
    @paths = paths
    
  resolve: ->
    @resolvedModules = []
    for path in @paths
      resolvedPath = npath.resolve(path)
      @resolvedModules = @resolvedModules.concat(@walk(resolvedPath))
    
    @modules = Utils.flatten @resolvedModules

  walk: (path, parent = path, result = []) ->
    exists = fs.existsSync(path)
    return unless exists
    
    for child in fs.readdirSync(path)
      child = npath.join(path, child)
      stat  = fs.statSync(child)
      if stat.isDirectory()
        @walk(child, parent, result)
      else
        ext = npath.extname(child).slice(1)
        compiledModule = Compilers[ext](child) if ext == "css" or ext == "less"
        result.push(compiledModule) if compiledModule
    result
    
module.exports = StyleCompiler
