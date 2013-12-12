// Generated by CoffeeScript 1.4.0
var FileList, LocalFile, async, fs, path;

path = require('path');

fs = require('fs');

async = require('async');

LocalFile = (function() {

  function LocalFile(filename, folder, host) {
    this.filename = filename;
    this.folder = folder != null ? folder : process.cwd();
    this.host = host != null ? host : 'localhost';
  }

  LocalFile.prototype.absPath = function() {
    return path.resolve(this.folder, this.filename);
  };

  LocalFile.prototype.exists = function(done) {
    return fs.exists(this.absPath(), done);
  };

  return LocalFile;

})();

FileList = (function() {

  function FileList(file) {
    if (file == null) {
      file = void 0;
    }
    this.files = [];
    if (file) {
      this.add(file);
    }
  }

  FileList.prototype.add = function(file) {
    return this.files.push(file);
  };

  FileList.prototype.length = function() {
    return this.files.length;
  };

  FileList.prototype.absPath = function() {
    var file, tmp, _i, _len, _ref;
    tmp = "";
    _ref = this.files;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      file = _ref[_i];
      if (tmp) {
        tmp += " ";
      }
      tmp += file.absPath();
    }
    return tmp;
  };

  FileList.prototype.exists = function(done) {
    var file, funcs, _fn, _i, _len, _ref;
    funcs = [];
    _ref = this.files;
    _fn = function(file) {
      return funcs.push(function(done) {
        return file.exists(function(e) {
          return done(null, e);
        });
      });
    };
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      file = _ref[_i];
      _fn(file);
    }
    return async.parallel(funcs, function(err, results) {
      var r, _j, _len1;
      for (_j = 0, _len1 = results.length; _j < _len1; _j++) {
        r = results[_j];
        if (!r) {
          return done(false);
        }
      }
      return done(true);
    });
  };

  return FileList;

})();

module.exports.LocalFile = LocalFile;

module.exports.FileList = FileList;