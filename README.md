# symfio-contrib-uploads

> Handle file uploading.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt12,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt12&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-uploads.png)](https://gemnasium.com/symfio/symfio-contrib-uploads)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname
loader = container.get "loader"

loader.use require "symfio-contrib-express"
loader.use require "symfio-contrib-assets"
loader.use require "symfio-contrib-uploads"

loader.load()
```

## Required plugins

* [contrib-express](https://github.com/symfio/symfio-contrib-express)
* [contrib-assets](https://github.com/symfio/symfio-contrib-assets)

## Can be configured

* __uploads directory__ - Default value is `uploads`.
