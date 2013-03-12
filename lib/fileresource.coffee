path = require 'path'
fs = require 'fs'
async = require 'async'

class LocalFile
  constructor: (@filename, @folder=process.cwd(), @host='localhost') ->
  absPath: () ->
    return path.resolve @folder, @filename
  exists: (done) ->
    fs.exists @absPath(), done

class FileList
  constructor: (file=undefined) ->
    @files = []
    if file
      @add file
  add: (file) ->
    @files.push file
  length: () ->
    return @files.length
  absPath: () ->
    tmp = ""
    for file in @files
      if tmp
        tmp += " "
      tmp += file.absPath()
    return tmp
  exists: (done) ->
    funcs = []
    for file in @files
      do (file) ->
        funcs.push (done) ->
          file.exists (e) ->
            done null, e
    async.parallel funcs, (err, results) ->
      for r in results
        if not r
          return done false
      return done true

module.exports.LocalFile = LocalFile
module.exports.FileList = FileList
