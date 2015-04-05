module.exports = (grunt) ->
  grunt.initConfig
    pkg: require('./package.json')
    
    browserify:
      options:
        transform: ['coffeeify']
        browserifyOptions:
          extensions: ['.coffee']
      content_scripts:
        src: 'src/content_scripts/index.coffee'
        dest: 'dist/content_scripts.js'
      background:
        src: 'src/background/index.coffee'
        dest: 'dist/background.js'
    
    copy:
      manifest:
        src: 'src/manifest.json'
        dest: 'dist/manifest.json'
    
    uglify:
      dist:
        expand: true
        cwd: 'dist'
        src: '*.js'
        dest: 'dist'
    
    crx:
      dist:
        src: ['dist']
        dest: '<%= pkg.name %>.crx'
    
    watch:
      'browserify:content_scripts':
        files: 'src/content_scripts/**/*.coffee'
        tasks: ['browserify:content_scripts']
      
      'browserify:background':
        files: 'src/background/**/*.coffee'
        tasks: ['browserify:background']
      
      'copy:manifest':
        files: 'src/manifest.json'
        tasks: ['copy:manifest']
  
  grunt.registerTask 'compile', ['copy', 'browserify']
  grunt.registerTask 'build', ['compile', 'userdata', 'uglify', 'crx']
  grunt.registerTask 'default', ['compile', 'watch']
  
  grunt.loadTasks('tasks')
  
  require('load-grunt-tasks')(grunt)
