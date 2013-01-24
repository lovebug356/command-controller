#!/usr/bin/env coffee

class BaseCommand
  constructor: (@name) ->
    @dependencies = []
    @done = false
  addDependency: (dep) ->
    @dependencies.push dep
  isReady: (done) ->
    for dependency in @dependencies
      if not dependency.done or (dependency.done and dependency.err)
        return done false
    return done true
  preRun: (done) ->
    done true
  run: (done) ->
    @done = true
    done()

module.exports = BaseCommand
