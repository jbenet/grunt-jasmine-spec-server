module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    coffee:
      default:
        src: 'coffee/**/*.coffee'
        dest: 'js'
        options:
          preserve_dirs: true
          base_path: 'coffee'

    jasmineSpecServer:
      src: 'js/src/**/*.js'
      specs: 'js/specs/**/*.js'

    watch:
      files: 'coffee'
      tasks: 'coffee'

    clean:
      js: 'js'

  # Load tasks
  grunt.loadNpmTasks 'grunt-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-jasmine-spec-server'

  # Register tasks
  grunt.registerTask 'default', ['coffee', 'jasmineSpecServer', 'watch']
