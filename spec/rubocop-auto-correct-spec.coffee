RubocopAutoCorrect = require '../lib/rubocop-auto-correct'

describe "RubocopAutoCorrect", ->
  [workspaceElement, initialActiveItem] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    @rubocopAutoCorrect = new RubocopAutoCorrect
    atom.config.set('rubocop-auto-correct.autoRun', false)
    atom.config.set('rubocop-auto-correct.notification', false)
    atom.config.set('rubocop-auto-correct.rubocopCommandPath', 'rubocop')

    waitsForPromise ->
      atom.workspace.open('sample.rb')

    runs ->
      initialActiveItem = atom.workspace.getActiveTextEditor()

  it "toggle auto run", ->
    expect(atom.config.get('rubocop-auto-correct').autoRun).toBe false
    @rubocopAutoCorrect.toggleAutoRun()
    expect(atom.config.get('rubocop-auto-correct').autoRun).toBe true
    @rubocopAutoCorrect.toggleAutoRun()
    expect(atom.config.get('rubocop-auto-correct').autoRun).toBe false

  it "toggle notification", ->
    expect(atom.config.get('rubocop-auto-correct').notification).toBe false
    @rubocopAutoCorrect.toggleNotification()
    expect(atom.config.get('rubocop-auto-correct').notification).toBe true
    @rubocopAutoCorrect.toggleNotification()
    expect(atom.config.get('rubocop-auto-correct').notification).toBe false

  describe "get options", ->
    it 'should have only command and args, When notification false', ->
      atom.config.set('rubocop-auto-correct.notification', false)
      editor = atom.workspace.getActiveTextEditor()
      options = @rubocopAutoCorrect.getOptions(editor.getPath())
      expect(Object.keys(options).length).toBe 2
      expect(Object.keys(options)[0]).toBe "command"
      expect(Object.keys(options)[1]).toBe "args"

    it 'should have full options, When notification true', ->
      atom.config.set('rubocop-auto-correct.notification', true)
      editor = atom.workspace.getActiveTextEditor()
      options = @rubocopAutoCorrect.getOptions(editor.getPath())
      expect(Object.keys(options).length).toBe 4
      expect(Object.keys(options)[0]).toBe "command"
      expect(Object.keys(options)[1]).toBe "args"
      expect(Object.keys(options)[2]).toBe "stdout"
      expect(Object.keys(options)[3]).toBe "stderr"
