cc = require './'
ShellCommand = require './shellcommand'
Project = require './project'

class Autotools extends Project
  buildConfigure: () ->
    @configure = new ShellCommand "sh autogen.sh", @module

module.exports = Autotools

