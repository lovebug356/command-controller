path = require 'path'
cc = require '../'
LocalFile = cc.LocalFile
FileList = cc.FileList
async = require 'async'

describe 'FileResource', () ->
  describe 'LocalFile', () ->
    it 'should accept a non absolute path', () ->
      file = new LocalFile 'package.json'
      file.absPath().should.eql path.join process.cwd(), 'package.json'
      file = new LocalFile '/tmp/test.txt'
      file.absPath().should.eql '/tmp/test.txt'
    it 'should accept an absolute path'
    it 'should provide cmds to make this file remote'
    it 'should check if the file exists', (done) ->
      async.parallel [
        (done) ->
          file = new LocalFile 'package.json'
          file.exists (exists) ->
            done null, exists
        (done) ->
          file = new LocalFile '/tmp/not_existing.file'
          file.exists (exists) ->
            done null, exists
      ], (err, results) ->
        results[0].should.be.ok
        results[1].should.be.not.ok
        done()
  describe 'RemoteFile', () ->

describe 'FileList', () ->
  it 'should be empty to start', () ->
    fl = new FileList()
    fl.length().should.eql 0
  it 'should provide a string with abd paths of the files', () ->
    fl = new FileList()
    fl.add new LocalFile 'package.json'
    fl.absPath().should.eql path.join process.cwd(), 'package.json'
    fl.add new LocalFile '/tmp/test'
    fl.absPath().should.eql path.join(process.cwd(), 'package.json') + " /tmp/test"
    fl = new FileList new LocalFile '/tmp/test'
    fl.absPath().should.eql '/tmp/test'
  it 'should check if all files exists', (done) ->
    fl = new FileList()
    fl.add new LocalFile 'package.json'
    fl.exists (exists) ->
      exists.should.be.ok
      done()
  it 'should check if all files exists', (done) ->
    fl = new FileList()
    fl.add new LocalFile '/tmp/test'
    fl.add new LocalFile 'package.json'
    fl.exists (exists) ->
      exists.should.be.not.ok
      done()
