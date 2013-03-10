#!/usr/bin/env coffee
fs = require 'fs'
path = require 'path'

foreachFile = (folder, match, done) ->
  fs.readdir folder, (err, files) ->
    if err
      console.log 'ERROR', err
      return
    for file in files
      if file.match match
        done path.join folder, file

module.exports.foreach = foreachFile
