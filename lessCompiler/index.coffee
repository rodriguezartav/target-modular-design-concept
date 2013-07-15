fs = require('fs')
Less = require('less')

class LessCompiler
  
  @middleware: (req,res) ->
    @compile [req.query["path"]] , (content) =>
      res.header("Content-type", "text/css");
      res.charset = 'utf-8'
      res.send content
  
  @compile: (paths,callback,mimified=false) ->
    try
      path = paths[0] + "index.less"
      parser = new(Less.Parser)( { paths: paths , filename: 'index.less' } )
      fs.readFile path, "utf8" , (err, data) =>
        if err 
          console.error err
          callback("",false)
        parser.parse data, (err, css) ->
          if err
            console.error err
            callback("",false)
          else  
            content = css.toCSS()
            content = content.replace(/(\s)+/g, "$1") if mimified
            callback(content,true)
    catch err
      callback "",false

module.exports = LessCompiler