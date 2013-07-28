assert = require("assert")

should = require("should")


Compiler = require(process.cwd() + "/lib/index")

describe "Compile App" , ->
  it "it should compile an App" , ->
    appPath = "./test/fixtures/app/screens/small"
    app = new Compiler.AppCompiler([appPath])
    app.resolve()
    app.modules.length.should.be.above(1)

  it "it should compile two Apps" , ->
    appPath1 = "./test/fixtures/app/screens/large"
    appPath2 = "./test/fixtures/app/shared"
    app = new Compiler.AppCompiler([appPath1,appPath2])
    app.resolve()
    app.modules.length.should.be.above(3)

     
