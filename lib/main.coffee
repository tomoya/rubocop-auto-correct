RubocopAutoCorrect = require './rubocop-auto-correct'

module.exports =
  config:
    rubocopCommandPath:
      description: 'If command doesnot work, please input rubocop full path. example: /Users/<username>/.rbenv/shims/rubocop)'
      type: 'string'
      default: 'rubocop'
    autoRun:
      description: 'When you save the buffer, Automatically run Rubocop auto correct, But, need to run manually once at window'
      type: 'boolean'
      default: false
    notification:
      description: 'If you want to disable notification, Please remove the check'
      type: 'boolean'
      default: true

  activate: ->
    @rubocopAutoCorrect = new RubocopAutoCorrect()

  deactivate: ->
    @rubocopAutoCorrect?.destroy()
    @rubocopAutoCorrect = null
