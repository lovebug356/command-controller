should = require 'should'
cc = require '../'

describe 'FileFilter', () ->
  it 'should find the package.json file', (done) ->
    cc.FileFilter.foreach '.', cc.FileFilter.ext(/\.json$/), (filename) ->
      done()
