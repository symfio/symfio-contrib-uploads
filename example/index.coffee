symfio = require "symfio"
path = require "path"
fs = require "fs.extra"

uploadsDirectory = path.join __dirname, "uploads"

module.exports = container = symfio "example", __dirname
container.set "public directory", __dirname
container.set "uploads directory", uploadsDirectory

loader = container.get "loader"

loader.use (container, callback) ->
  fs.mkdir uploadsDirectory, ->
    callback()

loader.use require "symfio-contrib-express"
loader.use require "symfio-contrib-assets"
loader.use require "../lib/uploads"

loader.use (container, callback) ->
  unloader = container.get "unloader"

  unloader.register (callback) ->
    fs.remove uploadsDirectory, ->
      callback()

  callback()

loader.load() if require.main is module
