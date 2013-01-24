should = require 'should'
cc = require '../'

describe 'GitFetchCommand', () ->
  it 'should update if the module already exists', (done) ->
    sh1 = new cc.GitFetchCommand "ssh://not_interesting", "lib"
    sh1.preRun (shouldRun) ->
      shouldRun.should.be.true
      sh1.cmd.should.equal "git remote update"
      done()
  it 'should clone if the module does not exists', (done) ->
    sh1 = new cc.GitFetchCommand "ssh://not_interesting", "lib2"
    sh1.preRun (shouldRun) ->
      shouldRun.should.be.true
      sh1.cmd.should.equal "git clone ssh://not_interesting lib2"
      done()
  it 'should checkout the correct branch', (done) ->
    sh1 = new cc.GitFetchCommand "ssh://not_interesting", "lib2", "1.0"
    sh1.preRun (shouldRun) ->
      shouldRun.should.be.true
      sh1.cmd.should.equal "git clone ssh://not_interesting lib2 && git checkout origin/1.0"
      done()
