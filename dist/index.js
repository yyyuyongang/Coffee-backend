// Generated by CoffeeScript 2.4.1
(function() {
  var ArticleMongooseModel, ArticleSchema, LocalStrategy, UserMongooseModel, UserSchema, app, bodyParser, express, mongoose, passport, passportLocal, server, session;

  express = require('express');

  mongoose = require('mongoose');

  bodyParser = require('body-parser');

  session = require('express-session');

  ArticleSchema = require('./article');

  UserSchema = require('./user');

  passport = require('passport');

  passportLocal = require('passport-Local');

  app = express();

  app.use(bodyParser.json());

  //data model
  ArticleMongooseModel = mongoose.model('Article', ArticleSchema);

  UserMongooseModel = mongoose.model('User', UserSchema);

  //connection
  mongoose.connect('mongodb://localhost:27017/nodejs-blog');

  app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
    return next();
  });

  app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true
  }));

  app.use(passport.initialize());

  app.use(passport.session());

  //passport initialization Settings
  passport.serializeUser((user, done) => {
    return done(void 0, user.id);
  });

  passport.deserializeUser((id, done) => {
    return UserMongooseModel.findById(id, (err, user) => {
      return done(err, user);
    });
  });

  //set passport strategy
  LocalStrategy = passportLocal.Strategy;

  passport.use(new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password'
  }, function(email, password, done) {
    UserMongooseModel.findOne({
      email: email
    }, function(err, user) {
      if (err) {
        return done(err);
      }
      if (!user) {
        console.log('no user find');
        return done(null, false);
      }
      if (password !== user.password) {
        return done(null, false);
      }
      return done(null, user);
    });
  }));

  app.get('/', (req, res) => {
    return res.end('hi');
  });

  app.get('/articles', (req, res) => {
    return ArticleMongooseModel.find({}, function(err, data) {
      if (err) {
        res.send(err);
      }
      return res.json(data);
    });
  });

  app.post('/articles', (req, res) => {
    return ArticleMongooseModel.insertMany(req.body);
  });

  app.get('/user', (req, res) => {
    return UserMongooseModel.find({}, function(err, data) {
      if (err) {
        res.send(err);
      }
      return res.json(data);
    });
  });

  app.post('/user', (req, res) => {
    return UserMongooseModel.insertMany(req.body);
  });

  app.post('/login', passport.authenticate('local'), function(req, res, next) {
    res.send(req.user);
  });

  server = app.listen(3000, () => {
    return console.log('running');
  });

  module.exports = server;

}).call(this);
