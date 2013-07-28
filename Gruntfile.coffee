module.exports = (grunt) ->

  
  grunt.initConfig
    coffee:
      sourceFiles:
        expand: true,
        flatten: true,
        cwd: './src',
        src: ['*.coffee'],
        dest: './lib/',
        ext: '.js'

      testFiles:
        expand: true,
        flatten: true,
        cwd: './test/unit/src',
        src: ['*.coffee'],
        dest: './test/unit/',
        ext: '.js'

    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/unit/*.js']
        
    watch:
      test:
        files: ["./test/unit/src/*.coffee"]
        tasks: "testFiles"

      source:
        files: ["./src/*.coffee"]
        tasks: ["sourceFiles"]

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-mocha-test');
  
  grunt.registerTask('default', ['coffee','mochaTest']);   
