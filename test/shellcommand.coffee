should = require 'should'
cc = require '../'

describe 'ShellCommand', () ->
  it 'should save log information when running', (done) ->
    sh1 = new cc.ShellCommand "ls"
    sh1.run () ->
      should.not.exist sh1.err
      sh1.log.should.be.ok
      sh1.done.should.be.ok
      should.not.exist sh1.alreadyDone
      done()

  it 'should allow to run its command in a folder', (done) ->
    sh1 = new cc.ShellCommand "ls", "lib"
    sh1.run () ->
      sh2 = new cc.ShellCommand "ls"
      sh2.run () ->
        sh2.log.should.be.ok
        sh1.log.should.be.ok
        sh1.log.should.not.equal sh2.log
        done()

  it 'should allow to overwrite the default name', () ->
    sh1 = new cc.ShellCommand "ls"
    sh1.name.should.equal "ls"
    sh1.setName "ls2"
    sh1.name.should.equal "ls2"

  it 'should indicate already done if checkfile exsits', (done) ->
    sh1 = new cc.ShellCommand "ls", process.cwd(), 'package.json'
    sh1.preRun (really) ->
      really.should.be.false
      sh1.done.should.be.ok
      sh1.alreadyDone.should.be.ok
      done()
