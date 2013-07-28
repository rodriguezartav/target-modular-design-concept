(function() {
  var Compiler, assert, should;

  assert = require("assert");

  should = require("should");

  Compiler = require(process.cwd() + "/lib/index");

  describe("Compile Depedencies", function() {
    return it("it should compile  Dependecies", function() {
      var depedency;
      depedency = new Compiler.DependencyCompiler(['spine']);
      depedency.resolve();
      return depedency.modules.length.should.be.above(1);
    });
  });

}).call(this);
