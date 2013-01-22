colors = require 'colors'

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
  firstReady: (done, idx=0) ->
    if idx + 1 > @cmds.length
      return undefined
    @cmds[idx].isReady (ready) =>
      if not @cmds[idx].done and ready
        done @cmds[idx]
      else
        @firstReady done, idx + 1
  prefix: (cmd) ->
    return "[#{cmd.id}/#{@size()}]"
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
    @warning cmd, "add"
    cmd.run () =>
      idx = @running.indexOf cmd
      if not cmd.err
        @good cmd, "done"
      else
        @error cmd, "error"
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
          return
    else
      if @running.length == 0
        console.log "[#{@done.length}/#{@size()}] all done".green
        done()

module.exports = CommandController
