path = require 'path'
fs = require 'fs-plus'
temp = require 'temp'
{File} = require 'atom'

RubocopAutoCorrect = require '../lib/rubocop-auto-correct'

describe "RubocopAutoCorrect", ->
  [workspaceElement, editor, buffer, filePath, activationPromise] = []

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

    describe "when correct buffer", ->
      beforeEach ->
        atom.config.set('rubocop-auto-correct.correctFile', false)

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

    describe "when correct file", ->
      beforeEach ->
        atom.config.set('rubocop-auto-correct.correctFile', true)

      it "manually run", ->
        atom.commands.dispatch workspaceElement, 'rubocop-auto-correct:current-file'

        bufferChangedSpy = jasmine.createSpy()
        buffer.onDidChange(bufferChangedSpy)
        waitsFor ->
          bufferChangedSpy.callCount > 1
        runs ->
          expect(buffer.getText()).toBe "{ atom: 'A hackable text editor for the 21st Century' }\n"

      it "auto run", ->
        atom.config.set('rubocop-auto-correct.autoRun', true)
        editor.save()

        bufferChangedSpy = jasmine.createSpy()
        buffer.onDidChange(bufferChangedSpy)
        waitsFor ->
          bufferChangedSpy.callCount > 1
        runs ->
          expect(buffer.getText()).toBe "{ atom: 'A hackable text editor for the 21st Century' }\n"

  describe "when command with arguments", ->
    beforeEach ->
      buffer.setText("{ :atom => 'A hackable text editor for the 21st Century' }\n")
      atom.config.set('rubocop-auto-correct.rubocopCommandPath', 'rubocop --no-color --format simple')

    describe "when correct buffer", ->
      it "manually run", ->
        atom.config.set('rubocop-auto-correct.correctFile', false)
        atom.commands.dispatch workspaceElement, 'rubocop-auto-correct:current-file'
        bufferChangedSpy = jasmine.createSpy()
        buffer.onDidChange(bufferChangedSpy)
        waitsFor ->
          bufferChangedSpy.callCount > 0
        runs ->
          expect(buffer.getText()).toBe "{ atom: 'A hackable text editor for the 21st Century' }\n"

    describe "when correct file", ->
      it "manually run", ->
        atom.config.set('rubocop-auto-correct.correctFile', true)
        atom.commands.dispatch workspaceElement, 'rubocop-auto-correct:current-file'
        bufferChangedSpy = jasmine.createSpy()
        buffer.onDidChange(bufferChangedSpy)
        waitsFor ->
          bufferChangedSpy.callCount > 1
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

    it "changes notification", ->
      atom.config.set('rubocop-auto-correct.onlyFixesNotification', false)
      @rubocopAutoCorrect.toggleOnlyFixesNotification()
      expect(atom.config.get('rubocop-auto-correct').onlyFixesNotification).toBe true
      @rubocopAutoCorrect.toggleOnlyFixesNotification()
      expect(atom.config.get('rubocop-auto-correct').onlyFixesNotification).toBe false

    it "changes correct method", ->
      atom.config.set('rubocop-auto-correct.correctFile', false)
      @rubocopAutoCorrect.toggleCorrectFile()
      expect(atom.config.get('rubocop-auto-correct').correctFile).toBe true
      @rubocopAutoCorrect.toggleCorrectFile()
      expect(atom.config.get('rubocop-auto-correct').correctFile).toBe false

    it "changes debug mode", ->
      atom.config.set('rubocop-auto-correct.debug-mode', false)
      @rubocopAutoCorrect.toggleDebugMode()
      expect(atom.config.get('rubocop-auto-correct').debugMode).toBe true
      @rubocopAutoCorrect.toggleDebugMode()
      expect(atom.config.get('rubocop-auto-correct').debugMode).toBe false

  describe "when makeTempFile", ->
    it "run makeTempFile", ->
      @rubocopAutoCorrect = new RubocopAutoCorrect
      tempFilePath = @rubocopAutoCorrect.makeTempFile("rubocop.rb")
      expect(fs.isFileSync(tempFilePath)).toBe true
