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

  it 'should continue if preRun returns false', (done) ->
    d1 = new cc.ShellCommand "ls"
    d2 = new cc.ShellCommand "ls -als"
    cco = new cc.CommandController 2
    d1.preRun = (done) ->
      d1.done = true
      done false
    cco.addCommand d1
    cco.addCommand d2
    cco.run () ->
      d1.done.should.be.ok
      d2.done.should.be.ok
      done()

  it 'should not block dependencies when preRun returns false', (done) ->
    d1 = new cc.ShellCommand "ls"
    d2 = new cc.ShellCommand "ls -als"
    d2.addDependency d1
    cco = new cc.CommandController 2
    d1.preRun = (done) ->
      d1.done = true
      done false
    cco.addCommand d1
    cco.addCommand d2
    cco.run () ->
      d1.done.should.be.ok
      d2.done.should.be.ok
      done()

  it 'should support very large numbers of dependency tasks', (done) ->
    cco = new cc.CommandController 2

    d1 = new cc.ShellCommand "ls"
    cco.addCommand d1

    # FIXME this does not work yet
    #for range in [1..20000]
      #d2 = new cc.ShellCommand "ls -als"
      #d2.addDependency d1
      #cco.addCommand d2

    d3 = new cc.ShellCommand "ls -als"
    #d3.addDependency d2
    cco.addCommand d3

    cco.run () ->
      d1.done.should.be.ok
      d3.done.should.be.ok
      done()

  it 'should find cmds which are the real targets (are no dependencies)', (done) ->
    cco = new cc.CommandController 2
    d1 = cco.addCommand new cc.ShellCommand "ls"
    d2 = cco.addCommand new cc.ShellCommand "ls -als"
    d2.addDependency d1
    cco.firstTarget (target) ->
      console.log target
      target.should.eql d2
      done()

  it 'should find cmds which are marked as targets (target=True)', (done) ->
    cco = new cc.CommandController 2
    d1 = cco.addCommand new cc.ShellCommand "ls"
    d2 = cco.addCommand new cc.ShellCommand "ls -als"
    d2.addDependency d1
    d1.target = true
    cco.firstTarget (target) ->
      target.should.eql d1
      done()

  it 'should find first ready cmd', (done) ->
    cco = new cc.CommandController 2
    d1 = cco.addCommand new cc.ShellCommand "ls"
    d2 = cco.addCommand new cc.ShellCommand "ls -als"
    d2.addDependency d1
    d1.target = true
    cco.firstTarget (target) ->
      target.should.eql d1
      done()

  it 'should skip dependencies of already done tasks', (done) ->
    cco = new cc.CommandController 2
    d1 = cco.addCommand new cc.ShellCommand "ls"
    d2 = cco.addCommand new cc.ShellCommand "ls -als"
    d2.addDependency d1
    d2.getDstFile = () -> return 'package.json'
    cco.checkPreRun () ->
      d2.done.should.be.ok
      d2.alreadyDone.should.be.ok
      d1.done.should.be.ok
      done()

  it 'should not skip dependencies of already done tasks if marked as target', (done) ->
    cco = new cc.CommandController 2
    d1 = cco.addCommand new cc.ShellCommand "ls"
    d2 = cco.addCommand new cc.ShellCommand "ls -als"
    d2.addDependency d1
    d2.getDstFile = () -> return 'package.json'
    d1.target = true
    cco.checkPreRun () ->
      d2.done.should.be.ok
      d2.alreadyDone.should.be.ok
      d1.done.should.be.not.ok
      done()
