express = require 'express'
mongoose = require 'mongoose'
bodyParser = require 'body-parser'
session = require 'express-session'
ArticleSchema = require './article'
UserSchema = require './user'
passport = require 'passport'
passportLocal = require 'passport-Local'

app = express()
app.use bodyParser.json()

#data model
ArticleMongooseModel = mongoose.model('Article', ArticleSchema)
UserMongooseModel = mongoose.model('User', UserSchema)

#connection
mongoose.connect('mongodb://localhost:27017/nodejs-blog')

app.use (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  next();

#session
app.use(session
  secret: 'keyboard cat',
  resave: false,
  saveUninitialized: true,
)
app.use passport.initialize()
app.use passport.session()

#passport initialization Settings
passport.serializeUser (user, done) =>
  done undefined, user.id
passport.deserializeUser (id, done) =>
  UserMongooseModel.findById id, (err, user) =>
        done(err, user)

#set passport strategy
LocalStrategy = passportLocal.Strategy
passport.use new LocalStrategy({
  usernameField: 'email'
  passwordField: 'password'
}, (email, password, done) ->
  UserMongooseModel.findOne { email: email }, (err, user) ->
    if err
      return done(err)
    if !user
      console.log 'no user find'
      return done(null, false)
    if password != user.password
      return done(null, false)
    done null, user
  return
)

app.get '/', (req, res) => res.end 'hi'

app.get '/articles', (req, res) =>
  ArticleMongooseModel.find({},(err, data) ->
    if err
      res.send err
    res.json data
)

app.post '/articles', (req, res) ->
  ArticleMongooseModel.insertMany(req.body)

app.get '/user', (req, res) =>
  UserMongooseModel.find({},(err, data) ->
    if err
      res.send err
    res.json data
)

app.post '/user', (req, res) =>
  UserMongooseModel.insertMany(req.body)

app.post '/login', passport.authenticate('local'), (req, res, next) ->
  res.send req.user
  return

server = app.listen 3000, () => console.log 'running'
module.exports = server
