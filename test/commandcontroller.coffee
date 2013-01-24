should = require 'should'
cc = require '../'

describe 'CommandController', () ->
  it 'should find the first command that is ready', (done) ->
    d1 = new cc.BaseCommand()
    d2 = new cc.BaseCommand()
    d3 = new cc.BaseCommand()
    cco = new cc.CommandController()
    cco.addCommand d1
    cco.addCommand d2
    cco.addCommand d3
    d1.isReady = (done) ->
      done false
    cco.firstReady (first) ->
      first.should.equal d2
      done()

  it 'should find the first command that is ready and skip done commands', (done) ->
    d1 = new cc.BaseCommand()
    d2 = new cc.BaseCommand()
    cco = new cc.CommandController()
    cco.addCommand d1
    cco.addCommand d2
    d1.done = true
    cco.firstReady (first) ->
      first.should.equal d2
      done()

  it 'should run all commands', (done) ->
    d1 = new cc.BaseCommand()
    d2 = new cc.BaseCommand()
    cco = new cc.CommandController()
    cco.addCommand d1
    cco.addCommand d2
    cco.run () ->
      d1.done.should.be.ok
      d2.done.should.be.ok
      done()

  it 'should limit the amount of simultanious commands', (done) ->
    d1 = new cc.ShellCommand "ls"
    d2 = new cc.ShellCommand "ls -als"
    cco = new cc.CommandController 1
    cco.addCommand d1
    cco.addCommand d2
    cco.running.oldPush = cco.running.push
    cco.running.push = (item) ->
      @length.should.not.be.above (1)
      @oldPush item
    cco.run () ->
      d1.done.should.be.ok
      d2.done.should.be.ok
      done()

  it 'should chain commands that are dependencies of each other', (done) ->
    d1 = new cc.ShellCommand "ls"
    d2 = new cc.ShellCommand "ls -als"
    cco = new cc.CommandController 2
    d2.addDependency d1
    cco.addCommand d1
    cco.addCommand d2
    cco.run () ->
      d1.done.should.be.ok
      d2.done.should.be.ok
      done()

  it 'should skip a task when a dependency has an error', (done) ->
    d1 = new cc.ShellCommand "ls"
    d2 = new cc.ShellCommand "ls -als"
    cco = new cc.CommandController 2
    d2.addDependency d1
    cco.addCommand d1
    cco.addCommand d2
    d1.done = true
    d1.err = true
    cco.firstReady (first) ->
      should.not.exist first
      done()


  it 'should be done, if there are no ready tasks anymore', (done) ->
    d1 = new cc.ShellCommand "ls"
    d2 = new cc.ShellCommand "ls -als"
    cco = new cc.CommandController 2
    d2.addDependency d1
    cco.addCommand d1
    cco.addCommand d2
    d1.done = true
    d1.err = true
    cco.run () ->
      d1.done.should.be.ok
      d2.done.should.be.not.ok
      done()
