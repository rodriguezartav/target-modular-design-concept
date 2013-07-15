fs           = require('fs')
DependencyModule = require("./dependencyModule")
npath        = require('path')
Utils = require("./utils")

###
  Convert referened dependencies from node_modules to CommonJS modules for the Browser
  
  After resolve() is called it stores an array of DependencyModules, later while generating the text from
  Template.eco each module's compile() method is called.
  
###
class DependencyCompiler

  constructor: (paths = []) -> 
    @paths = paths
    
  resolve: ->
    @firstModules or= (new DependencyModule(path) for path in @paths)
    @modules = @deepResolve(@firstModules)

  # Private
  deepResolve: (modules = [], result = [], search = {}) ->
    for module in modules when not search[module.filename]
      search[module.filename] = true
      result.push(module)
      @deepResolve(
        module.modules(),
        result
        search
      )
    result

module.exports = DependencyCompiler