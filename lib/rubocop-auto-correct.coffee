{CompositeDisposable, BufferedProcess} = require 'atom'
{spawnSync} = require 'child_process'
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
      'rubocop-auto-correct:toggle-correct-file': => @toggleCorrectFile()
      'rubocop-auto-correct:toggle-debug-mode': => @toggleDebugMode()

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

  toggleAutoRun: ->
    if atom.config.get('rubocop-auto-correct.autoRun')
      atom.config.set('rubocop-auto-correct.autoRun', false)
      atom.notifications.addSuccess("Turn OFF, Auto Run")
    else
      atom.config.set('rubocop-auto-correct.autoRun', true)
      atom.notifications.addSuccess("Turn ON, Auto Run")

  toggleNotification: ->
    if atom.config.get('rubocop-auto-correct.notification')
      atom.config.set('rubocop-auto-correct.notification', false)
      atom.notifications.addSuccess("Turn OFF, Notification")
    else
      atom.config.set('rubocop-auto-correct.notification', true)
      atom.notifications.addSuccess("Turn ON, Notification")

  toggleCorrectFile: ->
    if atom.config.get('rubocop-auto-correct.correctFile')
      atom.config.set('rubocop-auto-correct.correctFile', false)
      atom.notifications.addSuccess("Correct the buffer")
    else
      atom.config.set('rubocop-auto-correct.correctFile', true)
      atom.notifications.addSuccess("Correct the file")

  toggleDebugMode: ->
    if atom.config.get('rubocop-auto-correct.debugMode')
      atom.config.set('rubocop-auto-correct.debugMode', false)
      atom.notifications.addSuccess("Turn OFF, Debug Mode")
    else
      atom.config.set('rubocop-auto-correct.debugMode', true)
      atom.notifications.addSuccess("Turn ON, Debug Mode")

  run: (editor) ->
    unless editor.getGrammar().scopeName.match("ruby")
      return atom.notifications.addError("Only use source.ruby")
    if atom.config.get('rubocop-auto-correct.correctFile')
      if editor.isModified()
        editor.save()
      @autoCorrectFile(editor.getPath())
    else
      @autoCorrectBuffer(editor.getBuffer())

  autoCorrectBuffer: (buffer)  ->
    tempFilePath = @makeTempFile("rubocop.rb")
    fs.writeFileSync(tempFilePath, buffer.getText())
    commandWithArgs = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
                                .split(/\s+/).filter((i) -> i)
                                .concat(['-a', tempFilePath])
    command = commandWithArgs[0]
    args = commandWithArgs[1..]
    options = { encoding: 'utf-8', timeout: 5000 }
    notification = atom.config.get('rubocop-auto-correct.notification')
    debug = atom.config.get('rubocop-auto-correct.debugMode')

    which command, (err) ->
      if (err)
        return atom.notifications.addFatalError(
          "Rubocop command is not found.",
          { detail: '''
          When you don't install rubocop yet, Run `gem install rubocop` first.\n
          If you already installed rubocop, Please check package setting at `Rubocop Command Path`.
          ''' }
        )

      rubocop = spawnSync(command, args, options)

      if rubocop.stderr != ""
        console.error(rubocop.stderr) if debug
        atom.notifications.addError(rubocop.stderr) if notification

      if rubocop.stdout.match("corrected")
        buffer.setTextViaDiff(fs.readFileSync(tempFilePath, 'utf-8'))
        if notification || debug
          re = /^.+?(:[0-9]+:[0-9]+:.*$)/mg
          offenses = rubocop.stdout.match(re)
          offenses.map (offense) ->
            message = offense.replace(re, buffer.getBaseName() + "$1")
            console.log(message) if debug
            atom.notifications.addSuccess(message) if notification

  autoCorrectFile: (filePath)  ->
    commandWithArgs = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
                                .split(/\s+/).filter((i) -> i)
                                .concat(['-a', filePath])
    command = commandWithArgs[0]
    args = commandWithArgs[1..]
    debug = atom.config.get('rubocop-auto-correct.debugMode')
    notification = atom.config.get('rubocop-auto-correct.notification')
    stdout = (output) ->
      if output.match("corrected")
        console.log(output) if debug
        atom.notifications.addSuccess(output) if notification
    stderr = (output) ->
      console.error(output) if debug
      atom.notifications.addError(output) if notification

    which command, (err) ->
      if (err)
        return atom.notifications.addFatalError(
          "Rubocop command is not found.",
          { detail: '''
          When you don't install rubocop yet, Run `gem install rubocop` first.\n
          If you already installed rubocop, Please check package setting at `Rubocop Command Path`.
          ''' }
        )

      rubocop = new BufferedProcess({command, args, stdout, stderr})


  makeTempFile: (filename) ->
    directory = temp.mkdirSync()
    filePath = path.join(directory, filename)
    fs.writeFileSync(filePath, '')
    filePath
