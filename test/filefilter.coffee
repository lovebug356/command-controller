should = require 'should'
cc = require '../'

describe 'FileFilter', () ->
  it 'should find the package.json file', (done) ->
    cc.FileFilter.foreach '.', /\.json$/, (filename) ->
      done()
