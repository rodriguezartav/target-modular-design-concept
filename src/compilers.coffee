fs = require('fs')
eco = require 'eco'
less = require 'less'

compilers = {}



###
  Helper Object to easily call a compile method according to file extension  
###

compilers.coffee= (path) ->
  try
    cs = require 'coffee-script'
    try
      cs.compile(fs.readFileSync(path, 'utf8'), filename: path, literate: false)
    catch err
      err.message = "Coffeescript Error: " + err.message
      err.path    = "Coffeescript Path:  " + path
      err.path = err.path + ":" + (err.location.first_line + 1) if err.location
      throw err
  catch err

compilers.js= (path) ->
  fs.readFileSync path, 'utf8'

compilers.eco = (path) ->
  content = eco.precompile fs.readFileSync path, 'utf8'
  # TODO: wrap this in a function to be able to call jQuery
  # and store the module.id and values in the data attribute,
  # then have some way of calling replace with the same view
  # and function call with livereload
  """
  var content = #{content};
  module.exports = content;
  """

compilers.jeco = (path) -> 
  content = eco.precompile fs.readFileSync path, 'utf8'
  """
  module.exports = function(values, data){ 
    var $  = jQuery, result = $();
    values = $.makeArray(values);
    data = data || {};
    for(var i=0; i < values.length; i++) {
      var value = $.extend({}, values[i], data, {index: i});
      var elem  = $((#{content})(value));
      elem.data('item', value);
      $.merge(result, elem);
    }
    return result;
  };
  """

require.extensions['.jeco'] = require.extensions['.eco']
# require.extensions['.eco'] in eco package contains the function


compilers.style =
  css: (path, lessVariablesPath, callback) ->
    contents  = fs.readFileSync path, 'utf8'
    callback(false,contents)

  less: (path,lessVariablesPath, callback) ->
    lessVariablesContents = if lessVariablesPath.length > 5 then fs.readFileSync lessVariablesPath, 'utf8' else ""
    contents = fs.readFileSync path, 'utf8'
    
    less.render contents, callback

module.exports = compilers