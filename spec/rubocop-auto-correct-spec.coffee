RubocopAutoCorrect = require '../lib/rubocop-auto-correct'

describe "RubocopAutoCorrect", ->
  beforeEach ->
    @rubocopAutoCorrect = new RubocopAutoCorrect
    atom.config.set('rubocop-auto-correct.autoRun', false)
    atom.config.set('rubocop-auto-correct.notification', false)

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
