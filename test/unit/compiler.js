(function() {
  var Compiler, assert, should;

  assert = require("assert");

  should = require("should");

  Compiler = require(process.cwd() + "/lib/index");

  describe("Compile JS from paths", function() {
    var maps;
    maps = {
      "mobile": {
        appPaths: ["test/fixtures/app/shared", "test/fixtures/app/screens/small"],
        dependencyPaths: ["jqueryify", "spine"]
      },
      "web": {
        appPaths: ["test/fixtures/app/shared", "test/fixtures/app/screens/large"],
        dependencyPaths: ["jqueryify", "spine"]
      },
      "touch": {
        dependencyPaths: ["spine"]
      },
      "click": {
        dependencyPaths: ["jqueryify", "spine"]
      },
      "socialBar": {
        appPaths: ["test/fixtures/app/components/socialBar"]
      }
    };
    it("should compile just touch resources", function() {
      var index, str;
      str = Compiler.generateFile(maps["mobile"]);
      index = str.indexOf("controllers/main");
      return str.indexOf("controllers/main").should.be.equal(-1);
    });
    return it("should compile just socialBar", function() {
      var index, str;
      str = Compiler.generateFile(maps["click"]);
      index = str.indexOf("controllers/main");
      return str.indexOf("controllers/main").should.be.equal(-1);
    });
  });

}).call(this);
