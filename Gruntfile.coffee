'use strict'

module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  grunt.initConfig
    watch:
      stylus:
        files: ['src/**/*.styl']
        tasks: ['newer:stylus', 'autoprefixer']
      jade:
        files: ['src/**/*.jade']
        tasks: ['newer:jade']
      coffee:
        files: ['src/**/*.coffee']
        tasks: ['newer:coffee']
    autoprefixer:
      options:
        browsers: ['last 1 version']
      dist:
        files: [{
          expand: true
          cwd: 'app/'
          src: '{,*/}*.css'
          dest: 'app/'
        }]
    jade:
      options:
        sourceMap: true
        sourceRoot: ''
      server:
        files: [{
          expand: true
          cwd: 'src/'
          src: [ '**/*.jade' ]
          dest: 'app/'
          ext: '.html'
        }]
    coffee:
      options:
        sourceMap: true
        sourceRoot: ''
      server:
        files: [{
          expand: true
          cwd: 'src/'
          src: [ '**/*.coffee' ]
          dest: 'app/'
          ext: '.js'
        }]
    stylus:
      server:
        options:
          paths: [ 'app/' ]
          'include css': true
    electron:
      winBuild:
        options:
          name: 'sparks'
          dir: 'app'
          out: 'build'
          version: '0.30.1'
          platform: 'win32'
          arch: 'x64'
          prune: true
          asar: true
          'version-string.FileDescription': 'Sparks'
          'version-string.ProductName': 'Sparks'
      osxBuild:
        options:
          name: 'Sparks',
          dir: 'app'
          out: 'build'
          version: '0.30.1'
          platform: 'darwin'
          arch: 'x64'
    'create-windows-installer':
      x64:
        appDirectory: 'build/sparks-win32-x64'
        outputDirectory: 'release/installer64'
        authors: 'ndxbxrme'
        exe: 'sparks.exe'
        description: 'Sparks'
        title: 'Sparks'
    clean:
      dist:
        files: [{
          dot: true
          src: [
            'build'
            'release'
          ]
        }]
    
  grunt.registerTask 'default', [
    'watch'
  ]
  grunt.registerTask 'winbuild', [
    'clean'
    'coffee'
    'stylus'
    'autoprefixer'
    'jade'
    'electron:winBuild'
    'create-windows-installer'
  ]
  grunt.registerTask 'osxbuild', [
    'clean'
    'coffee'
    'stylus'
    'autoprefixer'
    'jade'
    'electron:osxBuild'
  ]