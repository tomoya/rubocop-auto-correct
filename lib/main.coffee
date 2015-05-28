RubocopAutoCorrect = require './rubocop-auto-correct'

module.exports =
  config:
    rubocopCommandPath:
      description: 'If command doesnot work, please input rubocop full path. example: /Users/<username>/.rbenv/shims/rubocop)'
      type: 'string'
      default: 'rubocop'

  activate: ->
    @rubocopAutoCorrect = new RubocopAutoCorrect()

  deactivate: ->
    @rubocopAutoCorrect?.destroy()
    @rubocopAutoCorrect = null
