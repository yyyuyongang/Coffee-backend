index = require '../src/index.coffee'
request = require 'supertest'

test = 0
beforeEach ->
  test = 1
  console.log "hook function"
  console.log test
#test homepage get function
describe 'homepage', ->
  it 'says hi', (done) ->
    request(index).get('/').expect(200).expect(/hi/, done())

#test user post function 
describe 'post request', ->
  it 'returns 200', (done) ->
    request(index).post('/user').send({email:"test1", password:"test1"}).expect(200,done())