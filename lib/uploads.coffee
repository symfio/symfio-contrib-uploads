fileupload = require "fileupload"
path = require "path"


module.exports = (container, callback) ->
  applicationDirectory = container.get "application directory"
  uploadsDirectory = path.join applicationDirectory, "uploads"

  uploadsDirectory = container.get "uploads directory", uploadsDirectory
  publicDirectory = container.get "public directory"
  logger = container.get "logger"
  app = container.get "app"

  logger.info "loading plugin", "contrib-uploads"

  unless uploadsDirectory.indexOf(publicDirectory) == 0
    return logger.error "Uploads directory isn't in public directory"

  upload = fileupload.createFileUpload uploadsDirectory
  prefix = uploadsDirectory.replace publicDirectory, ""

  app.use (req, res, callback) ->
    return callback() unless req.url is "/uploads"
    return callback() unless req.method is "POST"

    return res.send 400 unless Object.keys(req.body).length is 0
    return res.send 400 unless Object.keys(req.files).length is 1

    upload.middleware req, res, ->
      key = Object.keys(req.body).shift()
      file = req.body[key].shift()

      res.set "Location", "#{prefix}/#{file.path}#{file.basename}"
      res.send 201

  callback()
