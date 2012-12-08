
module.exports = function(grunt) {
  var config, ejs, express, path, _;
  path = require('path');
  express = require('express');
  ejs = require('ejs');
  _ = grunt.utils._;
  config = {
    name: 'jasmineSpecServer',
    defaults: {
      specs: 'required',
      src: 'required',
      lib: '',
      base: '.',
      task: "node_modules/grunt-jasmine-spec-server",
      port: 8088,
      view: "node_modules/grunt-jasmine-spec-server/static/spec.html"
    },
    parse: function(grunt) {
      var options;
      options = grunt.config(config.name);
      if (!options) {
        grunt.log.error("No config for " + config.name);
        return false;
      }
      _.each(config.defaults, function(value, key) {
        if (value === 'required' && !options[key]) {
          return grunt.log.error("" + config.name + " config requires " + key);
        }
      });
      _.defaults(options, config.defaults);
      options.base = path.resolve(options.base);
      options.taskBase = path.resolve(options.taskBase);
      return options;
    }
  };
  return grunt.registerTask(config.name, "Start a jasmine spec server.", function() {
    var app, options, render, templateValues;
    options = config.parse(grunt);
    if (grunt.task.current.errorCount) {
      return false;
    }
    templateValues = {
      _: _,
      lib: grunt.file.expandFiles(options.lib),
      src: grunt.file.expandFiles(options.src),
      specs: grunt.file.expandFiles(options.specs),
      taskPath: options.task,
      special: ['all'],
      title: ''
    };
    app = express();
    app.engine('html', ejs.renderFile);
    app.set('views', options.base);
    app.use(express["static"](options.base));
    render = function(res, values) {
      values = _.extend({}, templateValues, values);
      return res.render(options.view, values);
    };
    app.get(/^\/specs/, function(req, res, next) {
      var spec;
      spec = req.path.replace(/^\/specs\//, '');
      grunt.verbose.writeln("Serving spec " + spec);
      return render(res, {
        title: spec,
        run: [spec]
      });
    });
    app.get(/^\/special/, function(req, res, next) {
      var special, values;
      special = req.path.replace(/^\/special\//, '');
      grunt.verbose.writeln("Serving special " + special);
      values = {
        title: special
      };
      if (special === 'all') {
        values.run = templateValues.specs;
      }
      return render(res, values);
    });
    app.get('/', function(req, res) {
      grunt.verbose.writeln("Serving /");
      return render(res, {
        run: []
      });
    });
    grunt.log.writeln("listening on http://localhost:" + options.port);
    return app.listen(options.port);
  });
};
