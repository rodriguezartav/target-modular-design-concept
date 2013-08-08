fs           = require('fs')
AppModule = require("./appModule")
npath        = require('path')
Utils = require("./utils")

###
  Convert paths in /app folder to CommonJS modules for the Browser
  
  After resolve() is called it stores an array of AppModules, later while generating the text from
  Template.eco each module's compile() method is called.
  
###
class AppCompiler
  
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
        module = new AppModule(child, parent)
        result.push(module) if module.valid()
    result
    
module.exports = AppCompiler
