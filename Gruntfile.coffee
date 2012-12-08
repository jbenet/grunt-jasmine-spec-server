module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      tasks:
        src: 'coffee/tasks/**/*.coffee'
        dest: 'tasks'
        # grunt expects npm modules to have a top-level tasks directory, in js

    watch:
      files: 'coffee/**/*.coffee'
      tasks: 'coffee'

  # Load tasks
  grunt.loadNpmTasks 'grunt-coffee'

  # Register tasks
  grunt.registerTask 'default', ['coffee']
