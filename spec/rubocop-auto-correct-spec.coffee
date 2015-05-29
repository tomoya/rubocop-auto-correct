RubocopAutoCorrect = require '../lib/rubocop-auto-correct'

describe "RubocopAutoCorrect", ->
  beforeEach ->
    atom.config.set('rubocop-auto-correct.autoRun', false)

  it "toggle auto run", ->
    @rubocopAutoCorrect = new RubocopAutoCorrect
    expect(atom.config.get('rubocop-auto-correct').autoRun).toBe false
    @rubocopAutoCorrect.toggleAutoRun()
    expect(atom.config.get('rubocop-auto-correct').autoRun).toBe true
    @rubocopAutoCorrect.toggleAutoRun()
    expect(atom.config.get('rubocop-auto-correct').autoRun).toBe false
