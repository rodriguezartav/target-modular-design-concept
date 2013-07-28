module.exports = (grunt) ->

  
  grunt.initConfig
    less:
      development:
        options:
          paths: ["./css","./css/bootstrap"],
          yuicompress: true
        ,
        files:
          "./public/application.css": "./css/index.less"

    watch:
      css:
        files: ['./css/*.less','./css/**/*.less']
        tasks: 'less'

  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-watch');


  grunt.registerTask('default', ['','less']);   
