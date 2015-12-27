RubocopAutoCorrect = require './rubocop-auto-correct'

module.exports =
  config:
    rubocopCommandPath:
      description: 'If the command does not work, please input rubocop full path here. Example: /Users/<username>/.rbenv/shims/rubocop)'
      type: 'string'
      default: 'rubocop'
    autoRun:
      description: 'When you save the buffer, automatically it runs Rubocop auto correct. You need to run manually once at window before you use the option.'
      type: 'boolean'
      default: false
    notification:
      description: 'When this option is disabled, you do not receive any notifications even thought a file is corrected.'
      type: 'boolean'
      default: true
    correctFile:
      description: 'You can correct a file directly if you enable this option. You do not need to save file after correcting it.'
      type: 'boolean'
      default: false
    debugMode:
      description: 'You can get log on console panel if you enable this option.'
      type: 'boolean'
      default: false

  activate: ->
    @rubocopAutoCorrect = new RubocopAutoCorrect()

  deactivate: ->
    @rubocopAutoCorrect?.destroy()
    @rubocopAutoCorrect = null
