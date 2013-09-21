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
        appPaths: [],
        dependencyPaths: ["spine"]
      },
      "click": {
        appPaths: [],
        dependencyPaths: ["jqueryify", "spine"]
      },
      "socialBar": {
        appPaths: ["test/fixtures/app/components/socialBar"],
        dependencyPaths: []
      },
      "socialBars": {
        appPaths: ["test/fixtures/app/components/socialBar", "test/fixtures/app/components/socialBar2"],
        dependencyPaths: []
      }
    };
    it("should compile just touch resources", function() {
      var str;
      str = Compiler.generateFile(maps["mobile"].appPaths, maps["mobile"].dependencyPaths);
      return str.indexOf("controllers/main").should.not.be.equal(-1);
    });
    it("should compile css resources", function() {
      var str;
      str = Compiler.generateFile(maps["mobile"].appPaths, maps["mobile"].dependencyPaths);
      return str.indexOf('var css=""').should.be.equal(-1);
    });
    it("should compile just socialBar", function() {
      var str;
      str = Compiler.generateFile(maps["socialBar"].appPaths, maps["socialBar"].dependencyPaths);
      return str.indexOf("components/socialBar/").should.not.be.equal(-1);
    });
    return it("should compile css of both socialBars", function() {
      var str;
      str = Compiler.generateFile(maps["socialBars"].appPaths, maps["socialBars"].dependencyPaths);
      str.indexOf(".test").should.not.be.equal(-1);
      return str.indexOf(".test2").should.not.be.equal(-1);
    });
  });

}).call(this);
