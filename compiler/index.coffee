npath        = require('path')
fs           = require('fs')
{join, extname, dirname, basename, resolve, sep} = require('path')
eco = require("eco")

Template = require(process.cwd() + "/compiler/template")
Compilers = require("./compilers")
AppModule = require("./appModule")
AppCompiler = require("./appCompiler")
DependencyModule = require("./dependencyModule")
DependencyCompiler = require("./dependencyCompiler")
Utils = require("./utils")

class Compiler
  
  @dependencyGroupMap = {
      "forTouch" : ["jqueryify","spine"] #jqueryify-mobile
      "forClick" : ["jqueryify","spine"]
  }

  @widthsMap = {
    "0,800" : appPaths: ["app/shared","app/mobile"] , dependencyPaths: ["jqueryify","spine"] #jqueryify-mobile
    "800,5000" : appPaths: ["app/shared","app/web"] , dependencyPaths: ["jqueryify","spine"]
  }
  
  @middleware: (req, res, next) =>
    options = Compiler.optionsFromQuery(req.query)
    str = @generateFile( options )
    res.charset = 'utf-8'
    res.header("Content-type", "text/css");
    res.send str

  @widthToMap: (width) ->
    resultOptions = {apps: [] , dependencies: []}
    for key,option of @widthsMap
      intKeys = []
      intKeys.push parseInt(keyItem) for keyItem in key.split(",")
      throw "To use Widths Map, two keys sould be provided as key. ie: 0,800" if intKeys.length != 2
      resultOptions = option if width > intKeys[0] and width <= intKeys[1]
    resultOptions

  @optionsFromQuery: (query) =>
    options = {}
    options.dependencyPaths = query['dependencies'].split(",") if query['dependencies']
    options.appPaths = query['apps'].split(",") if query['apps']

    dependencyGroup = query['dependencyGroup']
    width = query["width"]
    if dependencyGroup then options.dependencyPaths = @dependencyGroupMap[dependencyGroup]
    if width and parseInt width then options = @widthToMap(parseInt(width))
    options
  
  @generateFile: (options) ->
    @dependency = new DependencyCompiler(options.dependencyPaths)
    @dependency.resolve()
    @app = new AppCompiler(options.appPaths)
    @app.resolve()
    modules = @dependency.modules.concat(@app.modules)
    Template(identifier: null, modules: modules)




Compiler.AppCompiler = AppCompiler
Compiler.DependencyCompiler = DependencyCompiler
Compiler.Template = Template
module.exports = Compiler
