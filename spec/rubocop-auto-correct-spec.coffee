path = require 'path'
fs = require 'fs-plus'
temp = require 'temp'
RubocopAutoCorrect = require '../lib/rubocop-auto-correct'

describe "RubocopAutoCorrect", ->
  [workspaceElement, editor, buffer, activationPromise] = []

  beforeEach ->
    directory = temp.mkdirSync()
    atom.project.setPaths([directory])
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('rubocop-auto-correct')
    filePath = path.join(directory, 'example.rb')
    fs.writeFileSync(filePath, '')
    atom.config.set('rubocop-auto-correct.autoRun', false)
    atom.config.set('rubocop-auto-correct.notification', false)
    atom.config.set('rubocop-auto-correct.rubocopCommandPath', 'rubocop')

    waitsForPromise ->
      atom.packages.activatePackage("language-ruby")

    waitsForPromise ->
      atom.workspace.open(filePath).then (o) -> editor = o

    runs ->
      buffer = editor.getBuffer()
      atom.commands.dispatch workspaceElement, 'rubocop-auto-correct:current-file'

    waitsForPromise ->
      activationPromise

  describe "when the editor is destroyed", ->
    beforeEach ->
      editor.destroy()

    it "does not leak subscriptions", ->
      {rubocopAutoCorrect} = atom.packages.getActivePackage('rubocop-auto-correct').mainModule
      expect(rubocopAutoCorrect.subscriptions.disposables.size).toBe 4

      atom.packages.deactivatePackage('rubocop-auto-correct')
      expect(rubocopAutoCorrect.subscriptions.disposables).toBeNull()

  describe "when the 'rubocop-auto-correct:current-file' command is run", ->
    beforeEach ->
      buffer.setText("{ :atom => 'A hackable text editor for the 21st Century' }\n")

    it "manually run", ->
      atom.commands.dispatch workspaceElement, 'rubocop-auto-correct:current-file'

      bufferChangedSpy = jasmine.createSpy()
      buffer.onDidChange(bufferChangedSpy)
      waitsFor ->
        bufferChangedSpy.callCount > 0
      runs ->
        expect(buffer.getText()).toBe "{ atom: 'A hackable text editor for the 21st Century' }\n"

    it "auto run", ->
      atom.config.set('rubocop-auto-correct.autoRun', true)
      editor.save()

      bufferChangedSpy = jasmine.createSpy()
      buffer.onDidChange(bufferChangedSpy)
      waitsFor ->
        bufferChangedSpy.callCount > 0
      runs ->
        expect(buffer.getText()).toBe "{ atom: 'A hackable text editor for the 21st Century' }\n"

  describe "when toggle config", ->
    beforeEach ->
      @rubocopAutoCorrect = new RubocopAutoCorrect

    it "changes auto run", ->
      atom.config.set('rubocop-auto-correct.autoRun', false)
      @rubocopAutoCorrect.toggleAutoRun()
      expect(atom.config.get('rubocop-auto-correct').autoRun).toBe true
      @rubocopAutoCorrect.toggleAutoRun()
      expect(atom.config.get('rubocop-auto-correct').autoRun).toBe false

    it "changes notification", ->
      atom.config.set('rubocop-auto-correct.notification', false)
      @rubocopAutoCorrect.toggleNotification()
      expect(atom.config.get('rubocop-auto-correct').notification).toBe true
      @rubocopAutoCorrect.toggleNotification()
      expect(atom.config.get('rubocop-auto-correct').notification).toBe false

    it "changes correct method", ->
      atom.config.set('rubocop-auto-correct.correctFile', false)
      @rubocopAutoCorrect.toggleCorrectFile()
      expect(atom.config.get('rubocop-auto-correct').correctFile).toBe true
      @rubocopAutoCorrect.toggleCorrectFile()
      expect(atom.config.get('rubocop-auto-correct').correctFile).toBe false

  describe "when makeTempFile", ->
    it "run makeTempFile", ->
      @rubocopAutoCorrect = new RubocopAutoCorrect
      tempFilePath = @rubocopAutoCorrect.makeTempFile("rubocop.rb")
      expect(fs.isFileSync(tempFilePath)).toBe true
