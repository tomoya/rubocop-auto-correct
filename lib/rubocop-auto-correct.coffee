{BufferedProcess} = require 'atom'

module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor',
     'rubocop-auto-correct:current-file': (event) =>
       @run(event.currentTarget.getModel())

  autoCorrect: (filePath)  ->
    command = 'rubocop'
    args = ['-a', filePath]
    process = new BufferedProcess({command, args})
    process

  run: (editor) ->
    if editor.isModified()
      editor.save()
    @autoCorrect(editor.getPath())
