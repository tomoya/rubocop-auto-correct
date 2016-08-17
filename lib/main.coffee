RubocopAutoCorrect = require './rubocop-auto-correct'

module.exports =
  activate: ->
    @rubocopAutoCorrect = new RubocopAutoCorrect()

  deactivate: ->
    @rubocopAutoCorrect?.destroy()
    @rubocopAutoCorrect = null
