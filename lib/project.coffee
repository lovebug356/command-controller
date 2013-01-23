cc = require './'
GitCommand = cc.GitFetchCommand
ShellCommand = cc.ShellCommand

class Project
  constructor: (@cco, @module, @uri) ->
    @git = new GitCommand @uri, @module
    @buildConfigure()
    @configure.addDependency @git
    @make = new ShellCommand "make", @module
    @make.addDependency @configure
    @cco.addCommand @git
    @cco.addCommand @configure
    @cco.addCommand @make
  buildConfigure: () ->
    @configure = new ShellCommand "./configure", @module

module.exports = Project

#class Autotools extends Project
  #buildConfigure: () ->
    #@configure = new ShellCommand "sh autogen.sh", @module
