module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  grunt.initConfig
    express:
      options: {}
      web:
        options:
          script: 'build/server/app.js'
      
    watch:
      frontend:
        options:
          spawn: true
          livereload: true
        files: ['src/client/**/*.*']
        tasks: ['buildClient']
      web:
        files: ['src/server/**/*.coffee']
        tasks: ['buildWeb', 'express:web']
        options:
          spawn: false
          atBegin: false
    coffee:
      options:
        sourceMap: true
      client:
        files: [{
          expand: true
          cwd: 'src'
          src: ['client/**/*.coffee']
          dest: 'build'
          ext: '.js'
        }]
      web:
        files: [{
          expand: true
          cwd: 'src'
          src: ['server/**/*.coffee']
          dest: 'build'
          ext: '.js'
        }]
    jade:
      default:
        files: [{
          expand: true
          cwd: 'src'
          src: ['**/*.jade']
          dest: 'build'
          ext: '.html'
        }]
    injector:
      default:
        files:
          "build/client/index.html": ['build/client/**/*.js', 'build/client/**/*.css']
    stylus:
      default:
        files:
          "build/client/app.css": "src/client/**/*.stylus"
    wiredep:
      options:
        directory: 'bower'
      target:
        src: 'build/client/index.html'
    clean:
      client: 'build/client'
      web: 'build/server'
      html: 'build/client/*/**/*.html'
    filerev:
      build:
        src: [
          'build/client/**/*.js'
          'build/client/**/*.css'
        ]
    usemin:
      html: ['build/client/**/*.html']
      js: ['build/client/**/*.js']
      css: ['build/client/**/*.css']
      options:
        assetsDirs: ['build/client']
        patterns:
          js: [
            /'([^']+\.html)'/
          ]
    ngtemplates:
      options:
        module: 'vsProperty'
      main:
        cwd: 'build/client'
        src: [
          'routes/**/*.html'
          'directives/**/*.html'
        ]
        dest: 'build/client/templates.js'
    copy:
      html:
        files: [{
          expand: true
          cwd: 'src/client'
          dest: 'build/client'
          src: [
            '*/**/*.html'
          ]
        }]
    curl:
      overview:
        src: 'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/overview.php'
        dest: 'build/client/routes/property/overview.html'
    'curl-dir':
      'remote-templates':
        src: [
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/brochure.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/featured-properties.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/layout.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/maps.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/mobile-slider.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/overview.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/photos.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/schools.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/similar-properties.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/taxbands.html'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/partials/transport.html'
        ]
        dest: 'build/client/routes/property'
      'remote-css':
        src: [
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/public/css/stylesheet.css'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/public/css/vitalspace.css'
          'http://vitalspace.co.uk/wp-content/themes/VitalSpace2015/public/css/MyFontsWebfontsKit.css'
        ]
        dest: 'build/client/styles'
    file_append:
      main:
        files: [{
          append: '<script src="http://localhost:35729/livereload.js" type="text/javascript"></script>'
          input: 'build/client/index.html'
          output: 'build/client/index.html'
        }]
  grunt.registerTask 'buildClient', [
    'clean:client'
    'coffee:client'
    'jade'
    'stylus'
    'copy:html'
    'curl:overview'
    'curl-dir:remote-templates'
    'curl-dir:remote-css'
    'ngtemplates'
    'filerev'
    'usemin'
    'wiredep'
    'injector'
    'file_append'
    'clean:html'
  ]
  grunt.registerTask 'buildWeb', [
    'clean:web'
    'coffee:web'
  ]
  grunt.registerTask 'default', [
    'buildClient'
    'buildWeb'
    'express:web'
    'watch'
  ]