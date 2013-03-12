colors = require 'colors'
fs = require 'fs'
Group = require './group'

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
    return cmd
  getTargets: (cmd) ->
    targets = []
    for cmd in @cmds
      if cmd.dependencies.indexOf(cmd) >= 0
        targets.push cmd
    return targets
  checkNoTarget: (cmd) ->
    for depCommand in cmd.dependencies
      continue if depCommand.target
      continue if depCommand.done
      allDone = true
      targets = @getTargets depCommand
      for target in targets
        if not target.done
          allDone = false
          break
      if allDone
        depCommand.done = true
        idx = @pending.indexOf depCommand
        @pending.splice idx, 1
        @done.push depCommand
        @info depCommand, "skipped (no target)"
        @checkNoTarget depCommand
  checkPreRun: (done) ->
    all = []
    start = @cmds.length
    for cmd in @cmds
      continue if cmd.done
      do (cmd) =>
        cmd.preRun (really) =>
          if cmd.done
            idx = @pending.indexOf cmd
            if idx >= 0
              @pending.splice idx, 1
              @done.push cmd
              @info cmd, "skipped (prerun)"
            @checkNoTarget cmd
          all.push cmd
          if @cmds.length == start
            if all.length == start
              done()
  firstTarget: (done, idx=0) ->
    while true
      found = false
      return done undefined if idx + 1 > @cmds.length
      cmd = @cmds[idx]
      return done cmd if cmd.target
      for peer in @cmds
        if peer.dependencies.indexOf(cmd) >= 0
          found = true
          break
      if found
        idx += 1
      else
        return done cmd
  firstReadyTarget: (done, idx=0) ->
    @firstTarget idx, (target) =>
      return done undefined if not target
      target.isReady (ready) =>
        if not ready
          firstReadyTarget done, @cmds.indexOf(target)+1
        else
          done target
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
  info: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".cyan
  good: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".green
  warning: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".yellow
  error: (cmd, log) ->
    console.log "#{@prefix(cmd)} #{log} #{cmd.name}".red
    console.log cmd.err_log.red
  run2done: (cmd) ->
    idx = @running.indexOf cmd
    @running.splice idx, 1
    @done.push cmd
    if not cmd.err
      @good cmd, "done"
    else
      @error cmd, "error"
    if cmd.logFile
      fs.writeFile cmd.logFile, cmd.cmd + "\n\n" + cmd.log, (err) ->
  startCmd: (cmd, done) ->
    idx = @pending.indexOf cmd
    @pending.splice idx, 1
    @running.push cmd
    if not (cmd instanceof Group)
      @warning cmd, "start"
    cmd.preRun (reallyRun) =>
      if reallyRun
        cmd.run () =>
          @run2done cmd
          @run done
      else
        idx = @running.indexOf cmd
        @running.splice idx, 1
        @done.push cmd
        @info cmd, "skipped"
        @run done
  checkRun: (done) ->
    @checkPreRun () =>
      @run done
  run: (done) ->
    if @running.length >= @threads
      return
    if @pending.length > 0
      @firstReady (fr) =>
        # Async so other tasks could be started already
        if @running.length >= @threads
          return
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
