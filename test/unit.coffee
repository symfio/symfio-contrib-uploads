fileupload = require "fileupload"
symfio = require "symfio"
plugin = require "../lib/uploads"
suite = require "symfio-suite"


describe "contrib-uploads plugin", ->
  wrapper = suite.sandbox symfio, ->
    @app = use: @sandbox.stub()

    @container.set "public directory", __dirname
    @container.set "uploads directory", __dirname
    @container.set "app", @app

  it "should catch only POST /uploads", wrapper ->
    callback = @sandbox.stub()
    req = url: "/", method: "GET"

    plugin @container, ->

    middleware = @app.use.firstCall.args[0]
    middleware req, null, callback

    @expect(callback).to.have.been.calledOnce

  it "should respond with 400 if no file sent", wrapper ->
    req = url: "/uploads", method: "POST", body: [], files: []
    res = send: @sandbox.stub()

    plugin @container, ->

    middleware = @app.use.firstCall.args[0]
    middleware req, res, ->

    @expect(res.send).to.have.been.calledOnce
    @expect(res.send).to.have.been.calledWith 400

  it "should exit if uploads directory not in public directory", wrapper ->
    error = @logger.error

    @container.set "public directory", "/a"
    @container.set "uploads directory", "/b"

    plugin @container

    @expect(error).to.have.been.calledOnce
    @expect(error).to.have.been.calledWithMatch /isn't in public directory/

  it "should return filepath with uploads in public", wrapper ->
    file = file: [path: "p/", basename: "f.jpg"]
    req = url: "/uploads", method: "POST", body: [], files: file
    res = send: @sandbox.stub(), set: @sandbox.stub()

    @sandbox.stub fileupload, "createFileUpload"
    fileupload.createFileUpload.returns middleware: (req, res, callback) ->
      req.body = file
      callback()

    @container.set "public directory", "/a"
    @container.set "uploads directory", "/a/b"

    plugin @container, ->

    middleware = @app.use.firstCall.args[0]
    middleware req, res, ->

    @expect(res.set).to.have.been.calledWith "Location", "/b/p/f.jpg"
