(function() {
  var Compiler, assert, should;

  assert = require("assert");

  should = require("should");

  Compiler = require(process.cwd() + "/lib/index");

  describe("Compile App", function() {
    it("it should compile an App", function() {
      var app, appPath;
      appPath = "./test/fixtures/app/screens/small";
      app = new Compiler.AppCompiler([appPath]);
      app.resolve();
      return app.modules.length.should.be.above(1);
    });
    return it("it should compile two Apps", function() {
      var app, appPath1, appPath2;
      appPath1 = "./test/fixtures/app/screens/large";
      appPath2 = "./test/fixtures/app/shared";
      app = new Compiler.AppCompiler([appPath1, appPath2]);
      app.resolve();
      return app.modules.length.should.be.above(3);
    });
  });

}).call(this);
