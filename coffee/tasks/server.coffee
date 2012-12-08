module.exports = (grunt) ->

  # Nodejs libs.
  path = require 'path'

  # External libs.
  express = require 'express'
  ejs = require 'ejs'
  _ = grunt.utils._




  # Task config
  config =
    name: 'jasmineSpecServer'

    # these are the available configuration options, and their defaults.
    # a default of 'required' means you must provide a value.
    defaults:

      # [required] the paths to the jasmine spec sources you want to test
      specs: 'required'

      # [required] the paths to the sources you want to include
      src: 'required'

      # the paths to the libraries you want to include
      lib: ''

      # the base path for your project (other paths are relative to it)
      base: '.'

      # the relative path to the grunt-jasmine-spec-server task source
      task: "node_modules/grunt-jasmine-spec-server"

      # the server port to use
      port: 8088

      # the express view to use
      view: "node_modules/grunt-jasmine-spec-server/static/spec.html"


    # parses the given configuration options, signaling any errors found
    parse: (grunt) ->
      options = grunt.config config.name

      # ensure we have options
      if not options
        grunt.log.error "No config for #{config.name}"
        return false

      # ensure we have all required values
      _.each config.defaults , (value, key) ->
        if value is 'required' and not options[key]
          grunt.log.error "#{config.name} config requires #{key}"

      # assign defaults
      _.defaults options, config.defaults

      # resolve paths
      options.base = path.resolve options.base
      options.taskBase = path.resolve options.taskBase

      return options




  # Tasks
  grunt.registerTask config.name, "Start a jasmine spec server.", ->

    # parse config options
    options = config.parse grunt

    # if there were errors parsing config, error out
    if grunt.task.current.errorCount
      return false


    # template value defaults for the view - modified by each route
    templateValues =

      # pass underscore :)
      _: _

      # paths to files
      lib: grunt.file.expandFiles options.lib
      src: grunt.file.expandFiles options.src
      specs: grunt.file.expandFiles options.specs
      taskPath: options.task

      # special running configurations
      special: ['all']

      # the menu item title to select
      title: ''


    # server setup
    app = express()

    # setup ejs templating engine
    app.engine 'html', ejs.renderFile

    # setup views path
    app.set 'views', options.base

    # static files
    app.use express.static options.base

    render = (res, values) ->
      values = _.extend({}, templateValues, values)
      res.render options.view, values

    # run spec
    app.get /^\/specs/, (req, res, next) ->
      spec = req.path.replace(/^\/specs\//, '')
      grunt.verbose.writeln "Serving spec #{spec}"
      render res,
        title: spec
        run: [spec]

    # run special/all
    app.get /^\/special/, (req, res, next) ->
      special = req.path.replace(/^\/special\//, '')
      grunt.verbose.writeln "Serving special #{special}"
      values = title: special

      if special is 'all'
        values.run = templateValues.specs

      render res, values

    # index
    app.get '/', (req, res) ->
      grunt.verbose.writeln "Serving /"
      render res, run: []

    grunt.log.writeln "listening on http://localhost:#{options.port}"
    app.listen options.port
