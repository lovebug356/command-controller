#!/usr/bin/env coffee
fs = require 'fs'

class BaseCommand
  constructor: (@name) ->
    @dependencies = []
    @done = false
  addDependency: (dep) ->
    @dependencies.push dep
  isReady: (done) ->
    if @srcFile
      fs.exists @srcFile, (exists) =>
        if not exists
          return done false
        return @isReadyDependencies done
    else
      return @isReadyDependencies done
  isReadyDependencies: (done) ->
    for dependency in @dependencies
      if not dependency.done or (dependency.done and dependency.err)
        return done false
    return done true
  preRun: (done) ->
    if @dstFile
      return @preRunFile @dstFile, done
    done true
  preRunFile: (filename, done) ->
    if filename != null
      fs.exists filename, (exists) =>
        if exists
          @done = true
          @alreadyDone = true
        return done false
    else
      return done true
  run: (done) ->
    @done = true
    done()

module.exports = BaseCommand
