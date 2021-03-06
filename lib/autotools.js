// Generated by CoffeeScript 1.4.0
var Autotools, Project, ShellCommand, cc,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

cc = require('./');

ShellCommand = require('./shellcommand');

Project = require('./project');

Autotools = (function(_super) {

  __extends(Autotools, _super);

  function Autotools() {
    return Autotools.__super__.constructor.apply(this, arguments);
  }

  Autotools.prototype.buildConfigure = function() {
    return this.configure = new ShellCommand("sh autogen.sh", this.module);
  };

  return Autotools;

})(Project);

module.exports = Autotools;
