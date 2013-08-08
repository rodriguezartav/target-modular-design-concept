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
    @css = ""
    
  compile: ->
    for module in @modules
      try
        compiler = Compilers.style[module.ext]
        callback = (err,css) =>
          throw err if err
          @css += css
        compiler module.path , callback
      catch error
        console.error err if err
    @css = @css.replace(/(\r\n|\n|\r)/gm,"")  

  resolve: ->
    @resolvedModules = []
    for path in @paths
      resolvedPath = npath.resolve(path)
      @resolvedModules = @resolvedModules.concat(@walk(resolvedPath))
    
    #flatten gets an array of arrays and converts it into an array of objects
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
        result.push( { path: child , ext: ext } ) if ext == "css" or ext == "less" # or ext == "scss" or ext == "sass" or ext = "styl
    result
    
module.exports = StyleCompiler
