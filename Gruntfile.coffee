pushState = require('grunt-connect-pushstate/lib/utils').pushState

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    applicationDir: 'app'
    developmentDir: 'develop'
    publicDir: 'public'
    testDir: 'tests'

    #coffeelint
    coffeelint:
      files:
        src: ['<%= applicationDir %>/scripts/**/*.coffee']
      options:
        'no_trailing_whitespace':
          level: 'warn'
        'camel_case_classes':
          level: 'warn'
        'newlines_after_classes':
          level: 'warn'
        'arrow_spacing':
          level: 'warn'
        'max_line_length':
          level: 'ignore'

    #coffee
    coffee:
      options:
        bare: true
      development:
        files: [
          expand: true
          cwd: '<%= applicationDir %>/scripts'
          src: ['*.coffee', '**/*.coffee']
          dest: '<%= developmentDir %>/scripts'
          ext: '.js'
        ]
      tests:
        files: [
          expand: true
          cwd: '<%= testDir %>/scripts'
          src: ['*.coffee', '**/*.coffee']
          dest: '<%= testDir %>/scripts'
          ext: '.js'
        ]

    #compass
    compass:
      development:
        options:
          sassDir: '<%= applicationDir %>/stylesheets'
          cssDir: '<%= developmentDir %>/stylesheets'
          imagesDir: '<%= developmentDir %>/images'

    #jade to JST compiler
    jade:
      index:
        options:
          pretty: true
          client: false
        files: [
          "<%= developmentDir %>/index.html": ["<%= applicationDir %>/index.jade"]
        ]
      development:
        options:
          pretty: false
          client: true
          amd: true
          processName: (filename) ->
            filename.slice(filename.indexOf("templates"), filename.length - 5)
        files: [
          "<%= developmentDir %>/scripts/templates.js": ["<%= applicationDir %>/templates/**/*.jade"]
        ]

    #сopy
    copy:
      publicCopyStyles: 
        expand: true
        src: '.'
        cwd: '<%= developmentDir %>/stylesheets/style.css'
        dest: '<%= publicDir %>/stylesheets/style.css'
      publicCopyIndex:
        expand: true
        src: '.'
        cwd: '<%= developmentDir %>/index.html'
        dest: '<%= publicDir %>/index.html'

    #clean
    clean:
      development: [
        '<%= developmentDir %>/**/*'
        '!<%= developmentDir %>/bower_components'
        '!<%= developmentDir %>/bower_components/**/*'
        '!<%= developmentDir %>/vendor'
        '!<%= developmentDir %>/vendor/**/*'
      ]
      public: ['<%= publicDir %>']

    #requirejs(concat + uglify)
    requirejs:
      public:
        options:
          name: 'scripts/config'
          preserveLicenseComments: false
          findNestedDependencies: true
          optimize: 'uglify2'
          uglify2:
            output:
              beautify: false
            compress:
              global_defs:
                DEBUG: false
          baseUrl: '<%= developmentDir %>'
          mainConfigFile: '<%= developmentDir %>/scripts/config.js'
          out: '<%= publicDir %>/scripts/app.min.js'
          removeCombined: false
          
    #web-server
    connect:
      options:
        port: 8000
        livereload: 35729
        hostname: 'localhost'
        middleware: (connect, options) ->
          proxy = require('grunt-connect-proxy/lib/utils').proxyRequest
          [
            proxy
            pushState()
            connect.static(options.base)
            connect.directory(options.base)
          ]
      livereload:
        options:
          #open: true
          base: '<%= developmentDir %>'
      proxies: [
        context: '/api'
        host: 'localhost'
        port: 8080
      ]

    #mocks
    easymock:
      api:
        options:
          port: 8080
          path: 'mocks'

    #tests mocha+chai
    mocha:
      options:
        reporter: 'Nyan'
        run: true

    #watch
    watch:
      options:
        livereload: true
        spawn: false
      files: ['<%= applicationDir %>/**/*']
      tasks: [
        'templates'
        'compass:development'
        'coffee:development'
        'coffeelint'
      ]

    #shell scripts
    shell:
      bowerInstall:
        options:
          stdout: true
        command: 
          '[ "$(ls <%= developmentDir %>/bower_components)" ] 
            && echo "<%= developmentDir%>/bower_components is not Empty. 
            Libraries are already installed" || bower install'

    #loading grunt tasks
    require('load-grunt-tasks')(grunt)

    #templates compiler tasks
    grunt.registerTask 'templates', [
      'jade:index'
      'jade:development'
    ]

    #test tasks
    grunt.registerTask 'test', '', () ->
      grunt.task.run('coffee:tests')
      grunt.config.set('mocha.browser', ['<%= testDir %>/**/*.html'])
      grunt.task.run('mocha')

    #global tasks
    grunt.registerTask 'initialize', [
      'clean:development'
      'templates'
      'compass:development'
      'coffee:development'
      'coffeelint'
      'connect:livereload'
      'easymock'
      'configureProxies:server'
    ]

    grunt.registerTask 'public', [
      'clean:public'
      'initialize'
      'requirejs:public'
      'copy:publicCopyStyles'
    ]

    grunt.registerTask 'default', [
      'shell:bowerInstall'
      'initialize'
      'watch'
    ]
