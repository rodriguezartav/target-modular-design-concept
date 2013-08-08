class Middleware

  @compileJavascript: (fileName) ->


  @compileCss: ->
    

module.exports = (paths)  ->
  return (req, res, next) ->
    if req.path == path.javascript
      res.send Middleware.compileJavascript(req.path)

    if req.path == path.css
      res.send Middleware.compileJavascript(req.path)

    return next()