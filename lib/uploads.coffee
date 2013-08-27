fileupload = require "fileupload"
path = require "path"
gm = require "gm"


module.exports = (container, callback) ->
  applicationDirectory = container.get "application directory"
  
  publicDirectory = path.join applicationDirectory, "public"
  publicDirectory = container.get "public directory", publicDirectory
  
  uploadsDirectory = path.join publicDirectory, "uploads"
  uploadsDirectory = container.get "uploads directory", uploadsDirectory

  logger = container.get "logger"
  app = container.get "app"

  logger.info "loading plugin", "contrib-uploads"

  unless uploadsDirectory.indexOf(publicDirectory) == 0
    return logger.error "Uploads directory isn't in public directory"

  upload = fileupload.createFileUpload uploadsDirectory
  prefix = uploadsDirectory.replace publicDirectory, ""

  app.use (req, res, callback) ->
    return callback() unless req._parsedUrl.pathname is "/uploads"
    return callback() unless req.method is "POST"

    return res.send 400 unless Object.keys(req.body).length is 0
    return res.send 400 unless Object.keys(req.files).length is 1

    upload.middleware req, res, ->
      key = Object.keys(req.body).shift()
      file = req.body[key].shift()

      callback = ->
        location = encodeURIComponent "#{prefix}/#{file.path}#{file.basename}"
        res.set "Location", location
        res.send 201

      if /image/.test file.type
        query = req.query
        action = query.action
        height = parseInt query.height
        width = parseInt query.width
        startX = parseInt query.startX
        startY = parseInt query.startY
        path = "#{uploadsDirectory}/#{file.path}#{file.basename}"
        image = gm path
        if action is "thumb" and width and height
          image.thumb width, height, path, 100, (err) ->
            return res.send 500 if err
            callback()
        else if action is "resize"
          image.resize width, height, "^"
          image.gravity "Center"
          image.crop width, height, startX, startY
          image.write path, (err) ->
            return res.send 500 if err
            callback()
        else
          callback()
      else
        callback()

  callback()
