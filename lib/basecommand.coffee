#!/usr/bin/env coffee
fs = require 'fs'
path = require 'path'

class BaseCommand
  constructor: (@name) ->
    if not @dependencies
      @dependencies = []
    @done = false
  resolveSrcFile: () ->
    if @srcFile instanceof BaseCommand
      if not @dependencies
        @dependencies = []
      @addDependency @srcFile
      @srcFile = @srcFile.getDstFile()
  addDependency: (dep) ->
    @dependencies.push dep
  getDstFile: (filename=@srcFile) ->
    return path.join @dstFolder, path.basename filename
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
    if @getDstFile()
      return @preRunFile @getDstFile(), done
    done true
  preRunFile: (filename, done) ->
    if filename != null
      fs.exists filename, (exists) =>
        if exists
          @done = true
          @alreadyDone = true
        return done not exists
    else
      return done true
  run: (done) ->
    @done = true
    done()

module.exports = BaseCommand
