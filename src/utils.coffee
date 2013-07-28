Module = require('module')
npath        = require('path')
{join, extname, dirname, basename, resolve, sep} = require('path')

###
  Helper Methods used in compiling Modules for the browser
###

class Utils
  
  @isAbsolute = (path) -> /^\//.test(path)

  @flatten = (array, results = []) ->
    for item in array
      if Array.isArray(item)
        Utils.flatten(item, results)
      else
        results.push(item)
    results

  @toArray = (value = []) ->
    if Array.isArray(value) then value else [value]
    
    
  @nodeModulePaths = (filename) ->
    Module._nodeModulePaths(dirname(filename))
    
  @modulerize = (id, filename = id) ->
    ext = npath.extname(filename)
    moduleName = join(dirname(id), basename(id, ext))
    moduleName.replace(/\\/g, '/')
    
    
    
module.exports = Utils