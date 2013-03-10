cp = require 'child_process'
exec = cp.exec
fs = require 'fs'

BaseCommand = require './basecommand'

class ShellCommand extends BaseCommand
  constructor: (@cmd, @folder=null) ->
    super(@cmd)
    if @folder
      @name = "#{@cmd} (#{@folder})"
  setName: (@name) ->
  run: (done) ->
    if @folder
      cmd = "cd #{@folder} && #{@cmd}"
    else
      cmd = @cmd
    exec cmd, (err, stdout, stderr) =>
      @err = err
      @log = stdout
      @err_log = stderr
      super done

module.exports = ShellCommand
