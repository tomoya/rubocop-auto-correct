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
        @run(atom.workspace.getActiveTextEditor())
      'rubocop-auto-correct:toggle-auto-run': => @toggleAutoRun()
      'rubocop-auto-correct:toggle-notification': => @toggleNotification()
      'rubocop-auto-correct:toggle-only-fixes-notification': =>
        @toggleOnlyFixesNotification()
      'rubocop-auto-correct:toggle-correct-file': => @toggleCorrectFile()
      'rubocop-auto-correct:toggle-debug-mode': => @toggleDebugMode()

  destroy: ->
    @subscriptions.dispose()

  handleEvents: (editor) ->
    buffer = editor.getBuffer()
    bufferSavedSubscription = buffer.onDidSave =>
      buffer.transact =>
        @run(editor) if atom.config.get('rubocop-auto-correct.autoRun')

    editorDestroyedSubscription = editor.onDidDestroy ->
      bufferSavedSubscription.dispose()
      editorDestroyedSubscription.dispose()

    @subscriptions.add(bufferSavedSubscription)
    @subscriptions.add(editorDestroyedSubscription)

  toggleMessage: (messagePrepend, enabled) ->
    "Rubocop Auto Correct: "+ messagePrepend + " " +
      (if enabled then "ON" else "OFF")

  toggleAutoRun: ->
    setting = atom.config.get('rubocop-auto-correct.autoRun')
    atom.config.set('rubocop-auto-correct.autoRun', !setting)
    atom.notifications.addSuccess(@toggleMessage("Auto Run", !setting))

  toggleNotification: ->
    setting = atom.config.get('rubocop-auto-correct.notification')
    atom.config.set('rubocop-auto-correct.notification', !setting)
    atom.notifications.addSuccess(@toggleMessage("Notifications", !setting))

  toggleOnlyFixesNotification: ->
    setting = atom.config.get('rubocop-auto-correct.onlyFixesNotification')
    atom.config.set('rubocop-auto-correct.onlyFixesNotification', !setting)
    atom.notifications.addSuccess(
      @toggleMessage("Only fixes notification", !setting)
    )

  toggleCorrectFile: ->
    setting = atom.config.get('rubocop-auto-correct.correctFile')
    atom.config.set('rubocop-auto-correct.correctFile', !setting)
    atom.notifications.addSuccess(@toggleMessage("Correct File", !setting))

  toggleDebugMode: ->
    setting = atom.config.get('rubocop-auto-correct.debugMode')
    atom.config.set('rubocop-auto-correct.debugMode', !setting)
    atom.notifications.addSuccess(@toggleMessage("Debug Mode", !setting))

  run: (editor) ->
    return if !editor
    unless editor.getGrammar().scopeName.match("ruby")
      return atom.notifications.addError("Only use source.ruby")
    if atom.config.get('rubocop-auto-correct.correctFile')
      editor.save() if editor.isModified()
      @autoCorrectFile(editor)
    else
      @autoCorrectBuffer(editor)

  rubocopConfigPath: (filePath) ->
    configFile = '/.rubocop.yml'
    [projectPath, relativePath] = atom.project.relativizePath(filePath)
    projectConfigPath = projectPath + configFile
    homeConfigPath = fs.getHomeDirectory() + configFile
    return ['--config', projectConfigPath] if (fs.existsSync(projectConfigPath))
    return ['--config', homeConfigPath] if (fs.existsSync(homeConfigPath))
    []

  rubocopCommand: ->
    commandWithArgs = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
                                .concat(" --format json")
                                .replace(/--format\s[^(\sj)]+/, "")
                                .split(/\s+/).filter((i) -> i)
    [commandWithArgs[0], commandWithArgs[1..]]

  autoCorrectBuffer: (editor)  ->
    buffer = editor.getBuffer()

    tempFilePath = @makeTempFile("rubocop.rb")
    fs.writeFileSync(tempFilePath, buffer.getText())

    rubocopCommand = @rubocopCommand()
    command = rubocopCommand[0]
    args = rubocopCommand[1]
      .concat(['-a', tempFilePath])
      .concat(@rubocopConfigPath(buffer.getPath()))

    which command, (err) =>
      return @rubocopNotFoundError() if (err)
      rubocop = spawnSync(command, args, { encoding: 'utf-8', timeout: 5000 })
      return @rubocopOutput({"stderr": "#{rubocop.stderr}"}) if (rubocop.stderr)
      buffer.setTextViaDiff(fs.readFileSync(tempFilePath, 'utf-8'))
      @rubocopOutput(JSON.parse(rubocop.stdout))

  autoCorrectFile: (editor)  ->
    filePath = editor.getPath()
    buffer = editor.getBuffer()

    rubocopCommand = @rubocopCommand()
    command = rubocopCommand[0]
    args = rubocopCommand[1]
      .concat(['-a', filePath])
      .concat(@rubocopConfigPath(filePath))

    stdout = (output) =>
      @rubocopOutput(JSON.parse(output))
      buffer.reload()
    stderr = (output) =>
      @rubocopOutput({"stderr": "#{output}"})

    which command, (err) =>
      return @rubocopNotFoundError() if (err)
      new BufferedProcess({command, args, stdout, stderr})

  rubocopNotFoundError: ->
    atom.notifications.addError(
      "Rubocop command is not found.",
      { detail: '''
      When you don't install rubocop yet, Run `gem install rubocop` first.\n
      If you already installed rubocop,
      Please check package setting at `Rubocop Command Path`.
      ''' }
    )

  rubocopOutput: (data) ->
    debug = atom.config.get('rubocop-auto-correct.debugMode')
    notification = atom.config.get('rubocop-auto-correct.notification')
    onlyFixesNotification =
      atom.config.get('rubocop-auto-correct.onlyFixesNotification')

    console.log(data) if debug

    if (data.stderr)
      atom.notifications.addError(data.stderr) if notification
      return

    if (data.summary.offense_count == 0)
      if !onlyFixesNotification
        atom.notifications.addSuccess("No offenses found") if notification
      return

    if !onlyFixesNotification
      atom.notifications.addWarning(
        "#{data.summary.offense_count} offenses found!"
      ) if notification

    for file in data.files
      for offense in file.offenses
        if offense.corrected
          atom.notifications.addSuccess(
            "Line: #{offense.location.line},
            Col:#{offense.location.column} (FIXED)",
            { detail: "#{offense.message}" }
          ) if notification
        else
          if !onlyFixesNotification
            atom.notifications.addWarning(
              "Line: #{offense.location.line},
              Col:#{offense.location.column}",
              { detail: "#{offense.message}" }
            ) if notification

  makeTempFile: (filename) ->
    directory = temp.mkdirSync()
    filePath = path.join(directory, filename)
    fs.writeFileSync(filePath, '')
    filePath
