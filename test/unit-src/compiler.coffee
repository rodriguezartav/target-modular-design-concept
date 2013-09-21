assert = require("assert")

should = require("should")

Compiler = require(process.cwd() + "/lib/index")

describe "Compile JS from paths" , ->
  maps = {
    "mobile" : appPaths: ["test/fixtures/app/shared","test/fixtures/app/screens/small"]   ,  dependencyPaths: ["jqueryify","spine"] 
    "web"    : appPaths: ["test/fixtures/app/shared","test/fixtures/app/screens/large"]      ,  dependencyPaths: ["jqueryify","spine"]
    "touch"  : appPaths: [] , dependencyPaths: ["spine"]
    "click"  : appPaths : [] , dependencyPaths: ["jqueryify","spine"]
    "socialBar" : appPaths: ["test/fixtures/app/components/socialBar"] , dependencyPaths: []
    "socialBars" : appPaths: ["test/fixtures/app/components/socialBar","test/fixtures/app/components/socialBar2"] , dependencyPaths: []

  }

  it "should compile just touch resources" , ->
     str = Compiler.generateFile(maps["mobile"].appPaths , maps["mobile"].dependencyPaths)
     str.indexOf("controllers/main").should.not.be.equal(-1)

   it "should compile css resources" , ->
      str = Compiler.generateFile(maps["mobile"].appPaths , maps["mobile"].dependencyPaths)
      str.indexOf('var css=""').should.be.equal(-1)

  it "should compile just socialBar" , ->
    str = Compiler.generateFile(maps["socialBar"].appPaths , maps["socialBar"].dependencyPaths)
    str.indexOf("components/socialBar/").should.not.be.equal(-1)
     
  it "should compile css of both socialBars" , ->
    str = Compiler.generateFile(maps["socialBars"].appPaths , maps["socialBars"].dependencyPaths)
    str.indexOf(".test").should.not.be.equal(-1)
    str.indexOf(".test2").should.not.be.equal(-1)
     
