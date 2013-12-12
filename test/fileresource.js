// Generated by CoffeeScript 1.4.0
var FileList, LocalFile, async, cc, path;

path = require('path');

cc = require('../');

LocalFile = cc.LocalFile;

FileList = cc.FileList;

async = require('async');

describe('FileResource', function() {
  describe('LocalFile', function() {
    it('should accept a non absolute path', function() {
      var file;
      file = new LocalFile('package.json');
      file.absPath().should.eql(path.join(process.cwd(), 'package.json'));
      file = new LocalFile('/tmp/test.txt');
      return file.absPath().should.eql('/tmp/test.txt');
    });
    it('should accept an absolute path');
    it('should provide cmds to make this file remote');
    return it('should check if the file exists', function(done) {
      return async.parallel([
        function(done) {
          var file;
          file = new LocalFile('package.json');
          return file.exists(function(exists) {
            return done(null, exists);
          });
        }, function(done) {
          var file;
          file = new LocalFile('/tmp/not_existing.file');
          return file.exists(function(exists) {
            return done(null, exists);
          });
        }
      ], function(err, results) {
        results[0].should.be.ok;
        results[1].should.be.not.ok;
        return done();
      });
    });
  });
  return describe('RemoteFile', function() {});
});

describe('FileList', function() {
  it('should be empty to start', function() {
    var fl;
    fl = new FileList();
    return fl.length().should.eql(0);
  });
  it('should provide a string with abd paths of the files', function() {
    var fl;
    fl = new FileList();
    fl.add(new LocalFile('package.json'));
    fl.absPath().should.eql(path.join(process.cwd(), 'package.json'));
    fl.add(new LocalFile('/tmp/test'));
    fl.absPath().should.eql(path.join(process.cwd(), 'package.json') + " /tmp/test");
    fl = new FileList(new LocalFile('/tmp/test'));
    return fl.absPath().should.eql('/tmp/test');
  });
  it('should check if all files exists', function(done) {
    var fl;
    fl = new FileList();
    fl.add(new LocalFile('package.json'));
    return fl.exists(function(exists) {
      exists.should.be.ok;
      return done();
    });
  });
  return it('should check if all files exists', function(done) {
    var fl;
    fl = new FileList();
    fl.add(new LocalFile('/tmp/test'));
    fl.add(new LocalFile('package.json'));
    return fl.exists(function(exists) {
      exists.should.be.not.ok;
      return done();
    });
  });
});