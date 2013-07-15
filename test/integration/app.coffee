require "coffee-script"
should = require("should")
request = require('supertest')
superagent = require('superagent');

# start app server here 
app = require("../../server")
app.listen process.env["PORT"]

# define server base URL

beforeEach ->
  # DB clear and re-init here

describe "Specific QueryTest", ->
  it "get Platform File", (done) ->
    response = request(app).get("/application.js?dependencies=jqueryify&apps=app/shared").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()

  it "get app File", (done) ->
    response = request(app).get("/application.js?apps=app/mobile").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()


  it "get two Files", (done) ->
    response = request(app).get("/application.js?apps=app/mobile,app/shared").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()

  it "get app", (done) ->
    response = request(app).get("/").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()

describe "Named QueryTest", ->
  it "get complete App with dependencyGroup", (done) ->
    response = request(app).get("/application.js?apps=app/mobile&dependencyGroup=forClick").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()
      
  it "get complete App from width", (done) ->
    response = request(app).get("/application.js?width=500").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()
      
  it "get complete App from width", (done) ->
    response = request(app).get("/application.js?width=900").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()
      
describe "Render CSS", ->
  it "should render css", (done) ->
    response = request(app).get("/application.css?path=css/").expect(200).expect("X-Powered-By", "Express")
    response.end (err, res) ->
      return done(err)  if err
      done()
