util = require('shinseibank-autologin-util')


writeKeyfile = (filename, done) ->
  util.key.generateKey 256, (err, key) ->
    return done(err) if err
    
    util.key.writeKeyfile filename, key, (err) ->
      done(err, key)


module.exports = (grunt) ->
  grunt.registerTask 'newkey', ->
    done = @async()
    
    filename = 'userdata/userdata.key'
    grunt.log.writeln 'Writing new keyfile to ' + filename
    writeKeyfile filename, done
