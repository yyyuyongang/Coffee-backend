mongoose = require 'mongoose'

Schema = mongoose.Schema

ArticleSchema = new Schema (
    title: String
    author: String
    body: String
)

module.exports = ArticleSchema
