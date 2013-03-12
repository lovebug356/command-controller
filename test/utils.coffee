should = require 'should'
fs = require 'fs'
cc = require '../'

describe 'Utils', () ->
  describe 'Copy', () ->
    it 'should copy a file', (done) ->
      cp = new cc.Copy 'package.json', 'lib'
      cp.run () ->
        fs.exists 'lib/package.json', (exists) ->
          exists.should.be.ok
          done()
  describe 'Delete', () ->
    it 'should delete a file', (done) ->
      ccc = new cc.CommandController 1
      cp = ccc.addCommand new cc.Copy 'package.json', 'lib'
      rm = ccc.addCommand new cc.Delete cp.getDstFile()
      ccc.run () ->
        fs.exists 'lib/package.json', (exists) ->
          exists.should.be.not.ok
          done()
    it 'should skip if srcFile does not exists', (done) ->
      ccc = new cc.CommandController 1
      rm = ccc.addCommand new cc.Delete 'package.json2'
      ccc.run () ->
        rm.done.should.be.not.ok
        done()
    it 'should allow chaining comands', (done) ->
      ccc = new cc.CommandController 1
      cp = ccc.addCommand new cc.Copy 'package.json', 'lib'
      rm = ccc.addCommand new cc.Delete cp
      ccc.run () ->
        fs.exists 'lib/package.json', (exists) ->
          exists.should.be.not.ok
          done()
    it 'should have an empty dstFile', () ->
      rm = new cc.Delete 'package.json'
      should.not.exist rm.getDstFile()
  describe 'Move', () ->
    it 'should provide a correct dstFile', () ->
      mv = new cc.Move 'test.gs', '/tmp'
      mv.getDstFile().should.eql '/tmp/test.gs'
  describe 'Zip', () ->
    it 'should zip and unzip files', (done) ->
      ccc = new cc.CommandController 1
      cp = ccc.addCommand new cc.Copy 'package.json', 'lib'
      zip = ccc.addCommand new cc.Zip cp.getDstFile()
      zip.getDstFile().should.eql "lib/package.json.gz"
      zip = ccc.addCommand new cc.Zip zip.getDstFile()
      zip.getDstFile().should.eql "lib/package.json"
      rm = ccc.addCommand new cc.Delete zip.getDstFile()
      ccc.run () ->
        rm.done.should.be.ok
        done()
    it 'should allow chaining comands', (done) ->
      ccc = new cc.CommandController 4
      for file in ['package.json', 'index.js']
        cp = ccc.addCommand new cc.Copy file, '/tmp'
        zip = ccc.addCommand new cc.Zip cp
        mv = ccc.addCommand new cc.Move zip, "."
        rm = ccc.addCommand new cc.Delete mv
      ccc.run () ->
        rm.done.should.be.ok
        done()
