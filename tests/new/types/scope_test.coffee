_ = require 'lodash'
helpers = require '../helpers'

describe 'Generating a scope plugin', ->
  beforeEach(helpers.createPlugin)

  describe 'output', ->
    beforeEach (done) ->
      helpers.mockPrompt @plugin,
        helpers.answerPrompts 'plugin:type': 'scope'
      done()

    it 'includes expected files', (done) ->
      @plugin.run {}, ->
        helpers.assertFiles helpers.pluginFiles
        done()

    it 'installs npm dependencies', (done) ->
      @plugin.installDependencies =>
        console.log @commandsRun
        helpers.assert.deepEqual(@commandsRun, [['bower', ['install']], ['npm', ['install']]])
        done()
