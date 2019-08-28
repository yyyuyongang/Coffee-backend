mongoose = require 'mongoose'

Schema = mongoose.Schema

UserSchema = new Schema (
    email: String
    password: String
)

module.exports = UserSchema
