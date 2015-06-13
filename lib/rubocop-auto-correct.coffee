{BufferedProcess, CompositeDisposable} = require 'atom'
which = require 'which'
path = require 'path'
fs = require 'fs-plus'
temp = require 'temp'

module.exports =
class RubocopAutoCorrect
  constructor: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      if editor.getGrammar().scopeName.match("ruby")
        @handleEvents(editor)

    @subscriptions.add atom.commands.add 'atom-workspace',
      'rubocop-auto-correct:current-file': =>
        if editor = atom.workspace.getActiveTextEditor()
          @run(editor)
      'rubocop-auto-correct:toggle-auto-run': => @toggleAutoRun()
      'rubocop-auto-correct:toggle-notification': => @toggleNotification()

  destroy: ->
    @subscriptions.dispose()

  handleEvents: (editor) ->
    buffer = editor.getBuffer()
    bufferSavedSubscription = buffer.onDidSave =>
      buffer.transact =>
        if atom.config.get('rubocop-auto-correct.autoRun')
          @run(editor)

    editorDestroyedSubscription = editor.onDidDestroy ->
      bufferSavedSubscription.dispose()
      editorDestroyedSubscription.dispose()

    @subscriptions.add(bufferSavedSubscription)
    @subscriptions.add(editorDestroyedSubscription)

  autoCorrect: (editor)  ->
    options = @getOptions(editor.getPath())
    which options.command, (err) ->
      if (err)
        return atom.notifications.addFatalError(
          "Rubocop command is not found.",
          { detail: '''
          When you don't install rubocop yet, Run `gem install rubocop` first.\n
          If you already installed rubocop, Please check package setting at `Rubocop Command Path`.
          ''' }
        )

      process = new BufferedProcess(options)
      process

  run: (editor) ->
    unless editor.getGrammar().scopeName.match("ruby")
      return atom.notifications.addError("Only use source.ruby")
    if editor.isModified()
      editor.save()
    @autoCorrect(editor)

  getOptions: (filePath) ->
    command = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
    args = ['-a', filePath]
    stdout = (output) ->
      if output.match("corrected")
        atom.notifications.addSuccess(output)
    stderr = (output) ->
      atom.notifications.addError(output)

    unless atom.config.get('rubocop-auto-correct.notification')
      return {
        command: command,
        args: args,
      }

    {
      command: command,
      args: args,
      stdout: stdout,
      stderr: stderr
    }

  toggleAutoRun: ->
    if atom.config.get('rubocop-auto-correct.autoRun')
      atom.config.set('rubocop-auto-correct.autoRun', false)
      atom.notifications.addSuccess("Trun OFF, Auto Run")
    else
      atom.config.set('rubocop-auto-correct.autoRun', true)
      atom.notifications.addSuccess("Trun ON, Auto Run")

  toggleNotification: ->
    if atom.config.get('rubocop-auto-correct.notification')
      atom.config.set('rubocop-auto-correct.notification', false)
      atom.notifications.addSuccess("Trun OFF, Notification")
    else
      atom.config.set('rubocop-auto-correct.notification', true)
      atom.notifications.addSuccess("Trun ON, Notification")
