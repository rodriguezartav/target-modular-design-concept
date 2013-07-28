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


class Compiler

  @generateFile: (appPaths,dependencyPaths=[]) ->
    compiledFile = ""
    @generateAppModules(appPaths)
    @generateDepedencyModules(dependencyPaths)
    @generateStyleModules(appPaths)
    modules = @dependency.modules.concat(@app.modules)
    compiledFile += Template(identifier: null, modules: modules, styleModules: @style.modules.join("").replace(/(\r\n|\n|\r)/gm,""))
    compiledFile

  @generateStyleModules: (paths)->
    @style = new StyleCompiler(paths)
    @style.resolve()

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
