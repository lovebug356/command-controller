#!/usr/bin/env coffee

class BaseCommand
  constructor: (@name) ->
    @dependencies = []
    @done = false
  addDependency: (dep) ->
    @dependencies.push dep
  isReady: (done) ->
    for dependency in @dependencies
      if not dependency.done
        return done false
    return done true
  run: (done) ->
    @done = true
    done()

module.exports = BaseCommand
