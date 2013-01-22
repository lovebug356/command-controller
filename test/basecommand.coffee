should = require 'should'
cc = require '../'

describe 'BaseCommand', () ->
  it 'should be ready when its dependencies are done', (done) ->
    d1 = new cc.BaseCommand()
    d2 = new cc.BaseCommand()
    bc = new cc.BaseCommand()
    bc.addDependency d1
    bc.addDependency d2
    bc.isReady (ready) ->
      ready.should.be.not.ok
    d1.run () ->
    d2.run () ->
    bc.isReady (ready) ->
      ready.should.be.ok
      done()

  it 'should not be ready when one its dependencies is not done', (done) ->
    d1 = new cc.BaseCommand()
    d2 = new cc.BaseCommand()
    bc = new cc.BaseCommand()
    bc.addDependency d1
    bc.addDependency d2
    d1.run () ->
    bc.isReady (ready) ->
      ready.should.be.not.ok
      done()
