Spine = require('spine')
$     = require('jqueryify')
Main = require("controllers/main")

class App extends Spine.Controller

  constructor: ->
    super
    main = new Main(el: $("body"))

module.exports = App
