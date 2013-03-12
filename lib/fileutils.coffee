ShellCommand = require './shellcommand'
path = require 'path'

class Copy extends ShellCommand
  constructor: (@srcFile, @dstFolder) ->
    @resolveSrcFile @srcFile
    super "Copy #{@srcFile}"
    @cmd = "cp #{@srcFile} #{@dstFolder}"

class Delete extends ShellCommand
  constructor: (@srcFile) ->
    @resolveSrcFile @srcFile
    super "Delete #{@srcFile}"
    @cmd = "rm #{@srcFile}"
  getDstFile: () ->
    return undefined

class Move extends ShellCommand
  constructor: (@srcFile, @dstFolder) ->
    @resolveSrcFile @srcFile
    super "Move #{@srcFile} to #{@dstFolder}"
    @cmd = "mv #{@srcFile} #{@dstFolder}"
  getDstFile: () ->
    return path.join @dstFolder, path.basename @srcFile

class Zip extends ShellCommand
  constructor: (@srcFile) ->
    @resolveSrcFile @srcFile
    if @isZipFile()
      cmd = "gunzip"
    else
      cmd = "gzip"
    super "#{cmd} #{@srcFile}", path.dirname @srcFile
    @cmd = "#{cmd} #{path.basename @srcFile}"
  isZipFile: () ->
    return @srcFile.match /\.gz$/
  getDstFile: () ->
    if @isZipFile()
      return @srcFile.replace /\.gz$/, ''
    else
      return @srcFile + '.gz'

module.exports.Copy = Copy
module.exports.Move = Move
module.exports.Delete = Delete
module.exports.Zip = Zip
