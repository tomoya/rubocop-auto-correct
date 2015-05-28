{BufferedProcess} = require 'atom'
path = require 'path'

module.exports =
  config:
    rubocopCommandPath:
      description: 'If command doesnot work, please input rubocop full path. example: /Users/<username>/.rbenv/shims/rubocop)'
      type: 'string'
      default: 'rubocop'

  activate: ->
    atom.commands.add 'atom-text-editor',
     'rubocop-auto-correct:current-file': (event) =>
       @run(event.currentTarget.getModel())

  autoCorrect: (filePath)  ->
    basename = path.basename(filePath)
    command = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
    args = ['-a', filePath]
    exit = (code) -> if (code == 0)
      atom.notifications.addSuccess("#{command} -a #{basename}")
    else
      atom.notifications.addError("Failer #{command} -a #{basename}")
    process = new BufferedProcess({command, args, exit})
    process

  run: (editor) ->
    if editor.isModified()
      editor.save()
    @autoCorrect(editor.getPath())
