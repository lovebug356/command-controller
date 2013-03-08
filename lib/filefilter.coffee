#!/usr/bin/env coffee
fs = require 'fs'

foreachFile = (folder, match, done) ->
  fs.readdir folder, (err, files) ->
    if err
      console.log 'ERROR', err
      return
    for file in files
      if file.match match
        done file

module.exports.foreach = foreachFile
