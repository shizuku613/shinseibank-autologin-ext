fs = require('fs')
path = require('path')
util = require('shinseibank-autologin-util')


getKey = (filename, done) ->
  fs.readFile filename, (err, data) ->
    return done(err) if err
    key = JSON.parse(data)
    key.key = new Buffer(key.key)
    done(null, key)


getUserData = (filename) ->
  try
    data = require(path.resolve(process.cwd(), filename))
  catch e
    throw Error('Can\'t find user settings. Please write in '+ filename)
  
  converted = util.securityCard.convert(data.securityCard)
  data.securityCard = converted
  
  data


writeEncryptedUserdata = (data, key, filename, done) ->
  encrypted = util.crypto.encrypt(data, key)
  encrypted.keyUrl = data.keyUrl
  
  fs.writeFile filename, JSON.stringify(encrypted), (err) ->
    done(err)


module.exports = (grunt) ->
  grunt.registerTask 'userdata', ->
    done = @async()
        
    getKey './userdata/userdata.key', (err, key) ->
      return done(err) if err
      
      data = getUserData('./userdata/userdata.json')
      dest = './dist/userdata.json'
      writeEncryptedUserdata data, key, dest, (err) ->
        done(err)
