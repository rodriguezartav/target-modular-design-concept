assert = require("assert")

should = require("should")


Compiler = require(process.cwd() + "/lib/index")


describe "Compile Depedencies" , ->

  it "it should compile  Dependecies" , ->
    depedency = new Compiler.DependencyCompiler(['spine'])
    depedency.resolve()
    depedency.modules.length.should.be.above(1)