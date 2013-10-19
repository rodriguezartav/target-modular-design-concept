npath        = require('path')
fs           = require('fs')
{join, extname, dirname, basename, resolve, sep} = require('path')
eco = require("eco")

Template = require("./template")
Compilers = require("./compilers")
AppModule = require("./appModule")
AppCompiler = require("./appCompiler")
DependencyModule = require("./dependencyModule")
DependencyCompiler = require("./dependencyCompiler")
StyleCompiler = require("./styleCompiler")

Utils = require("./utils")

#Notice: This is not the Grunt Task, just the Compiler used by the Grunt Task

class Compiler

  @generateFile: (appPaths,lessVariablesPath="" ,dependencyPaths=[]) ->
    compiledFile = ""
    @generateAppModules(appPaths)
    @generateDepedencyModules(dependencyPaths)
    @generateStyleModules(appPaths, lessVariablesPath )
    modules = @dependency.modules.concat(@app.modules)
    
    for module in modules
      try
        module.compilation = module.compile();
      catch error
        console.log("**************************")
        console.error(module.filename);
        console.error(error)
        console.log("**************************")

        return "console.error('R2 Compiler Error: [ " + error + " ] in " + module.filename + "')"

    compiledFile += Template(identifier: null, modules: modules, styleModules: @style.css )
    compiledFile

  @generateStyleModules: (paths, lessVariablesPath) ->
    @style = new StyleCompiler(paths, lessVariablesPath)
    @style.resolve()
    @style.compile() #compiled here because of callback style of less compiler

  @generateDepedencyModules: (paths) ->
    @dependency = new DependencyCompiler(paths)
    @dependency.resolve()
    @dependency.modules
    
  @generateAppModules: (paths) -> 
    @app = new AppCompiler(paths)
    @app.resolve()
    @app.modules

Compiler.AppCompiler = AppCompiler
Compiler.DependencyCompiler = DependencyCompiler
Compiler.StyleCompiler = StyleCompiler
Compiler.Template = Template
module.exports = Compiler
