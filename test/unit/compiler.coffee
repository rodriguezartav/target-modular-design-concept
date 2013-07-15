assert = require("assert")

should = require("should")

compilers = require(process.cwd() + "/compiler/compilers")

compiler = require(process.cwd() + "/compiler/index")

describe 'Compilers', ->
  
  it 'it should compile a .coffee file', ->
    compilers.coffee(process.cwd() + "/app/index.coffee")

  it 'it should compile a .js file', ->
    compilers.coffee(process.cwd() + "/app/lib/test.js")
    
  it 'it should compile a .less file', ->
    compilers.coffee(process.cwd() + "/app/views/test2.less")

  it 'it should compile a .eco file', ->
    compilers.coffee(process.cwd() + "/app/views/test.eco")
    
describe "Compile App" , ->
  it "it should compile an App" , ->
    appPath = process.cwd() + "/app/web"
    app = new compiler.AppCompiler([appPath])
    app.resolve()
    app.modules.length.should.be.above(0)

  it "it should compile an App" , ->
    appPath = process.cwd() + "/app/web"
    app = new compiler.AppCompiler([appPath])
    app.resolve()
    text = compiler.Template(identifier: null, modules:app.modules)
    text.length.should.be.above(0) 

  it "it should compile two Apps" , ->
    appPath1 = process.cwd() + "/app/web"
    appPath2 = process.cwd() + "/app/shared"
    app = new compiler.AppCompiler([appPath1,appPath2])
    app.resolve()
    text = compiler.Template(identifier: null, modules:app.modules)
    text.length.should.be.above(0)

describe "Generate Correct App" , ->
  it "it should compilt app from width" , ->
    options = compiler.optionsFromQuery({width: "799"})
    str = compiler.generateFile( options )
    str.length.should.be.above(1700) 


describe "Compile Depedencies" , ->

  it "it should compile  Dependecies" , ->
    depedency = new compiler.DependencyCompiler(['spine'])
    depedency.resolve()
    text = compiler.Template(identifier: null, modules:depedency.modules)
    text.length.should.be.above(0) 

describe "render app" , ->
  it "should render the platform and depedencies" , ->
    renderedFile = compiler.generateFile(appPaths: ["app/shared"], dependencyPaths: ['jqueryify'])
    renderedFile.length.should.be.above(100000) 

  it "should render just the mobile app" , ->
    renderedFile = compiler.generateFile(appPaths: ["app/mobile"])
    renderedFile.length.should.be.above(1000) 









