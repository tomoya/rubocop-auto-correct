RubocopAutoCorrect = require './rubocop-auto-correct'

module.exports =
  config:
    rubocopCommandPath:
      description: 'If command doesnot work, please input rubocop full path. example: /Users/<username>/.rbenv/shims/rubocop)'
      type: 'string'
      default: 'rubocop'
    autoRun:
      description: 'When you save the buffer, Automatically run Rubocop auto correct'
      type: 'boolean'
      default: false

  activate: ->
    @rubocopAutoCorrect = new RubocopAutoCorrect()

  deactivate: ->
    @rubocopAutoCorrect?.destroy()
    @rubocopAutoCorrect = null
