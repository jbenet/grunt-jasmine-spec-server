# grunt-jasmine-spec-server

This is a simple grunt task to run a development server to run jasmine spec
files selectively. This makes debugging large codebases much easier, in
particular those with long-running tests.

![demo](http://static.benet.ai/skitch/grunt-jasmine-spec-server-demo-20121207-170158.png)

This is not meant as a replacement of `grunt-jasmine-runner`, but rather to be
used in conjunction. Use the runner for overall testing, and this when debugging
specific spec files.

