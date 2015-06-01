{BufferedProcess, CompositeDisposable} = require 'atom'
path = require 'path'
which = require 'which'

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

    @subscriptions.add atom.commands.add 'atom-workspace',
      'rubocop-auto-correct:toggle-auto-run': => @toggleAutoRun()

    @subscriptions.add atom.commands.add 'atom-workspace',
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
    bufferDestroyedSubscription = buffer.onDidDestroy ->
      bufferDestroyedSubscription.dispose()
      bufferSavedSubscription.dispose()

    @subscriptions.add(bufferSavedSubscription)
    @subscriptions.add(editorDestroyedSubscription)
    @subscriptions.add(bufferDestroyedSubscription)

  autoCorrect: (filePath)  ->
    basename = path.basename(filePath)
    command = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
    args = ['-a', filePath]
    stdout = (output) ->
      if output.match("corrected")
        atom.notifications.addSuccess(output)
    stderr = (output) ->
        atom.notifications.addError(output)

    options = {
      command: command,
      args: args,
      stdout: stdout,
      stderr: stderr
    }

    unless atom.config.get('rubocop-auto-correct.notification')
      options = {
        command: command,
        args: args,
      }

    which command, (err) ->
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
    @autoCorrect(editor.getPath())

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
