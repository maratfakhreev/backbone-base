module.exports = (grunt) ->
  development:
    options:
      linenos: true
      compress: false
      urlfunc: 'embedurl'
      paths: ['bower_components', 'vendor']
    files:
      '<%= grunt.publicDir %>/stylesheets/style.css': '<%= grunt.appDir %>/stylesheets/application.styl'
