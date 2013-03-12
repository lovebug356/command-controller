BaseCommand = require './basecommand'

class Group extends BaseCommand
  constructor: (@name, @cco=undefined) ->
    super (@name)
  add: (child) ->
    @addDependency child
    if @cco
      @cco.addCommand child

module.exports = Group
