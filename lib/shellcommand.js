// Generated by CoffeeScript 1.5.0
var BaseCommand, ShellCommand, cp, exec, fs,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

cp = require('child_process');

exec = cp.exec;

fs = require('fs');

BaseCommand = require('./basecommand');

ShellCommand = (function(_super) {

  __extends(ShellCommand, _super);

  function ShellCommand(cmd, folder) {
    this.cmd = cmd;
    this.folder = folder != null ? folder : null;
    ShellCommand.__super__.constructor.call(this, this.cmd);
    if (this.folder) {
      this.name = "" + this.cmd + " (" + this.folder + ")";
    }
  }

  ShellCommand.prototype.setName = function(name) {
    this.name = name;
  };

  ShellCommand.prototype.run = function(done) {
    var cmd,
      _this = this;
    if (this.folder) {
      cmd = "cd " + this.folder + " && " + this.cmd;
    } else {
      cmd = this.cmd;
    }
    return exec(cmd, function(err, stdout, stderr) {
      _this.err = err;
      _this.log = stdout;
      _this.err_log = stderr;
      return ShellCommand.__super__.run.call(_this, done);
    });
  };

  return ShellCommand;

})(BaseCommand);

module.exports = ShellCommand;
