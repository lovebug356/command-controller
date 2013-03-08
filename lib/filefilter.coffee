#!/usr/bin/env coffee
fs = require 'fs'

foreachFile = (folder, filter, done) ->
  fs.readdir folder, (err, files) ->
    if err
      console.log 'ERROR', err
      return
    for file in files
      filter file, done

extFilter = (match) ->
  return (filename, done) ->
    if filename.match match
      done filename

module.exports.foreach = foreachFile
module.exports.ext     = extFilter
