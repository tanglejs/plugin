#
# * <%= plugin.name %>
# * https://github.com/<%= author.github %>/<%= plugin.name %>
# *
# * Copyright (c) <%= new Date().getFullYear() %> <%= author.name %>
# * Licensed under the MIT license.
#

path = require 'path'

module.exports = (grunt) ->
  #
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean:
      docs: ['man/']
      tests: ['tests/tmp/']

    watch:
      all:
        files: [
          'bin/**/*'
          'Gruntfile.coffee'
          'subcommands/*/templates/**/*'
          'subcommands/**/*.coffee'
          'readme/**/*.md'
          'tests/**/*.coffee'
          '!tests/tmp/**/*'
        ]
        tasks: ['default']

    mochacli:
      options:
        compilers: ['coffee:coffee-script/register']
      all: ['tests/**/*_test.coffee']

    readme_generator:
      help:
        options:
          output: 'tangle-<%= plugin.subcommand %>.md'
          table_of_contents: false
          generate_footer: false
          has_travis: false
          package_title: 'tangle-<%= plugin.subcommand %>'
          package_name: 'tangle-<%= plugin.subcommand %>'
        order:
          'usage.md': 'Usage'
      readme:
        options:
          banner: 'banner.md'
          generate_title: false
          has_travis: false
          github_username: '<%= author.github %>'
          generate_footer: false
          table_of_contents: false
        order:
          'overview.md': 'Overview'
          'usage.md': 'Usage'
          'contributing.md': 'Contributing'
          'license.md': 'License'

    bump:
      options:
        commit: true
        commitMessage: 'Release v%VERSION%'
        commitFiles: ['package.json']
        createTag: true
        tagName: 'v%VERSION%'
        tagMessage: 'Version %VERSION%'
        push: false

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-readme-generator'
  grunt.loadNpmTasks 'grunt-mocha-cli'
  grunt.loadNpmTasks 'grunt-bump'

  grunt.registerTask 'marked-man', ->
    done = @async()
    grunt.util.spawn
      cmd: './marked-man'
      args: [path.join(__dirname, 'tangle-<%= plugin.subcommand %>.md')]
      opts:
        cwd: path.join(__dirname, 'node_modules', 'marked-man', 'bin')
    , (error, result, code) ->
      throw error if error
      out = path.join __dirname, 'man', 'tangle-<%= plugin.subcommand %>.1'
      grunt.file.write out, result.stdout
      done()

  grunt.registerTask 'build', ['clean', 'readme_generator', 'marked-man']
  grunt.registerTask 'test', ['mochacli']
  grunt.registerTask 'default', ['build', 'test']
