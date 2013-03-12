should = require 'should'
cc = require '../'

describe 'Group', () ->
  it 'should contain a list of commands', (done) ->
    d1 = new cc.BaseCommand()
    d2 = new cc.BaseCommand()
    d3 = new cc.BaseCommand()
    g = new cc.Group "test-group"
    g.add d1
    g.add d2
    g.add d3
    cco = new cc.CommandController()
    cco.addCommand d1
    cco.addCommand d2
    cco.addCommand d3
    cco.addCommand g
    cco.run () ->
      g.done.should.be.ok
      done()
