cp = require 'child_process'
exec = cp.exec
fs = require 'fs'

ShellCommand = require './shellcommand'

class GitFetchCommand extends ShellCommand
  constructor: (@uri, @module, @branch) ->
    super(@uri)
    @name = "git #{@module}"
  preRun: (done) ->
    fs.exists @module, (exists) =>
      if exists
        @cmd = "git remote update"
        @folder = @module
      else
        @cmd = "git clone #{@uri} #{@module} && cd #{@module}"
        @folder = undefined
      if @branch
        @cmd += " && git checkout origin/#{@branch}"
      done true

module.exports = GitFetchCommand
