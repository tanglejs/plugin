path = require 'path'
yeoman = require 'yeoman-generator'
_ = require 'lodash'
_.str = require 'underscore.string'

module.exports = class PluginGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    super(args, options, config)
    @args = args
    @options = options

    @sourceRoot path.join __dirname, 'templates'

    @on 'end', ->
      require('fs').chmodSync "bin/tangle-#{@plugin.subcommand}.coffee", '1755'
      @installDependencies
        npm: true

      console.log "Next steps...\n"
      console.log "Build your plugin!\n"
      console.log '    $ grunt'
      console.log "\nDevelop your plugin!\n"
      console.log '    $ npm link'
      console.log '    $ git init'
      console.log '    $ grunt watch'
      console.log "Write your code, documentation and tests"
      console.log "    * CoffeeScript"
      console.log "    * Markdown"
      console.log "    * Mocha + Chai"
      console.log "\nPublish your plugin!\n"
      console.log "    $ grunt bump:<major|minor|patch>"
      console.log "    $ git push origin master"
      console.log "    $ git push --tags"
      console.log "    $ npm publish"
      console.log "    $ npm unlink"
      console.log "    $ npm install #{@plugin.name} -g\n"

PluginGenerator::pluginPrompts = require('./prompts/plugin').prompt
PluginGenerator::authorPrompts = require('./prompts/author').prompt

PluginGenerator::writePluginConfig = ->
  tangleConfig = require 'tangle-config' 
  pluginConfig = tangleConfig.getProject()
  pluginConfig.set 'plugin', @plugin
  pluginConfig.save (err) ->
    console.error err if err

PluginGenerator::copyFiles = ->
  @mkdir 'bin'
  @mkdir 'readme'
  @mkdir 'node_modules'
  @mkdir 'tests'
  @copy 'gitignore', '.gitignore'
  @copy 'editorconfig', '.editorconfig'
  @copy 'travis.yml', '.travis.yml'
  @copy '_package.json', 'package.json'
  @copy '_Gruntfile.coffee', 'Gruntfile.coffee'

  switch @plugin.type
    when 'scope'
      @mkdir 'subcommands'
      @copy 'types/scope/_index.coffee', 'index.coffee'
      @copy 'types/scope/bin/_tangle-subcommand.coffee', "bin/tangle-#{@plugin.subcommand}.coffee"
    when 'generator'
      @mkdir 'templates'
      @copy 'types/generator/_index.coffee', 'index.coffee'
      @copy 'types/generator/templates/_hello.txt', 'templates/_hello.txt'
      @copy 'types/generator/bin/_tangle-subcommand.coffee', "bin/tangle-#{@plugin.subcommand}.coffee"
    when 'runner'
      @copy 'types/runner/_index.coffee', 'index.coffee'
      @copy 'types/runner/bin/_tangle-subcommand.coffee', "bin/tangle-#{@plugin.subcommand}.coffee"

PluginGenerator::copyDocs = ->
  @copy '_LICENSE-MIT', 'LICENSE-MIT'
  @copy 'readme/_contributing.md', 'readme/contributing.md'
  @copy 'readme/_license.md', 'readme/license.md'
  @copy 'readme/_overview.md', 'readme/overview.md'
  @copy 'readme/_usage.md', 'readme/usage.md'
  @copy 'readme/_banner.md', 'readme/banner.md'
