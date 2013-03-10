// Generated by CoffeeScript 1.4.0
var cc, should;

should = require('should');

cc = require('../');

describe('BaseCommand', function() {
  it('should be ready when its dependencies are done', function(done) {
    var bc, d1, d2;
    d1 = new cc.BaseCommand();
    d2 = new cc.BaseCommand();
    bc = new cc.BaseCommand();
    bc.addDependency(d1);
    bc.addDependency(d2);
    bc.isReady(function(ready) {
      return ready.should.be.not.ok;
    });
    d1.run(function() {});
    d2.run(function() {});
    return bc.isReady(function(ready) {
      ready.should.be.ok;
      return done();
    });
  });
  it('should not be ready when one its dependencies is not done', function(done) {
    var bc, d1, d2;
    d1 = new cc.BaseCommand();
    d2 = new cc.BaseCommand();
    bc = new cc.BaseCommand();
    bc.addDependency(d1);
    bc.addDependency(d2);
    d1.run(function() {});
    return bc.isReady(function(ready) {
      ready.should.be.not.ok;
      return done();
    });
  });
  it('should skip the test if dstFile already exists', function(done) {
    var d1;
    d1 = new cc.BaseCommand();
    d1.dstFile = 'package.json';
    return d1.preRun(function(really) {
      really.should.be.not.ok;
      d1.done.should.be.ok;
      d1.alreadyDone.should.be.ok;
      return done();
    });
  });
  return it('should not be ready when there is no srcFile', function(done) {
    var d1,
      _this = this;
    d1 = new cc.BaseCommand();
    d1.srcFile = 'package.json2';
    return d1.isReady(function(ready) {
      ready.should.be.not.ok;
      return done();
    });
  });
});
