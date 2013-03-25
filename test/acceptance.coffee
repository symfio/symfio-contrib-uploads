suite = require "symfio-suite"


describe "contrib-uploads example", ->
  wrapper = suite.http require "../example"

  describe "POST /uploads", ->
    it "should upload file", wrapper (callback) ->
      test = @http.post "/uploads"

      test.req (req) ->
        req.attach "file", "#{__dirname}/../package.json"

      test.res (res) =>
        @expect(res).to.have.status 201
        @expect(res).to.have.header "location"

        process.nextTick =>
          test = @http.get res.headers.location

          test.res (res) =>
            @expect(res).to.have.status 200
            @expect(res.text).to.include "symfio-contrib-uploads"

            callback()
