{BufferedProcess} = require 'atom'

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
    command = atom.config.get('rubocop-auto-correct.rubocopCommandPath')
    args = ['-a', filePath]
    console.log("#{command} -a #{filePath}")
    process = new BufferedProcess({command, args})
    process

  run: (editor) ->
    if editor.isModified()
      editor.save()
    @autoCorrect(editor.getPath())
