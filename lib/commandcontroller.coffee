colors = require 'colors'
fs = require 'fs'

class CommandController
  constructor: (@threads) ->
    @cmds = []
    @pending = []
    @running = []
    @done = []
  size: () ->
    return @cmds.length
  addCommand: (cmd) ->
    @cmds.push cmd
    @pending.push cmd
    cmd.id = @size()
    cmd.cc = @
    @log cmd, "add"
  firstReady: (done, idx=0) ->
    if idx + 1 > @cmds.length
      return done undefined
    @cmds[idx].isReady (ready) =>
      if not @cmds[idx].done and ready and @pending.indexOf(@cmds[idx]) >= 0
        done @cmds[idx]
      else
        @firstReady done, idx + 1
  prefix: (cmd) ->
    #ret = "[#{cmd.id}/#{@size()}]"
    ret = "[#{@pending.length}/#{@running.length}/#{@done.length}]"
    if cmd
      ret += "(#{cmd.id})"
    return ret
  log: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".blue
  good: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".green
  warning: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".yellow
  error: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".red
    console.log cmd.err_log.red
  startCmd: (cmd, done) ->
    idx = @pending.indexOf cmd
    @pending.splice idx, 1
    @running.push cmd
    @warning cmd, "start"
    cmd.preRun (reallyRun) =>
      if reallyRun
        cmd.run () =>
          idx = @running.indexOf cmd
          @running.splice idx, 1
          @done.push cmd
          if not cmd.err
            @good cmd, "done"
          else
            @error cmd, "error"
          if cmd.logFile
            fs.writeFile cmd.logFile, cmd.cmd + "\n\n" + cmd.log, (err) ->
          @run done
      else
        idx = @running.indexOf cmd
        @running.splice idx, 1
        @done.push cmd
        @run done
  run: (done) ->
    if @running.length >= @threads
      return
    if @pending.length > 0
      @firstReady (fr) =>
        if fr
          running = @running.length
          @startCmd fr, done
          if running != @running.length
            # cmd is in sync
            @run done
        else
          if @running.length == 0
            console.log "#{@prefix()} skipped #{@pending.length}".grey
            return done()
          return
    else
      if @running.length == 0
        console.log "#{@prefix()} all done".green
        done()

module.exports = CommandController
