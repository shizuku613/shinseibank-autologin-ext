util = require('shinseibank-autologin-util')

main = ->
  userdata = null
  
  chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
    sendResponse( userdata: userdata )
  
  
  loadUserdata (err, data) ->
    return console.error(err) if err
    
    console.log 'Succeeded to get userdata'
    userdata = data


loadJSON = (url, cb) ->
  xhr = new XMLHttpRequest
  xhr.open('GET', url)
  xhr.responseType = 'json'
  xhr.onload = ->
    if @status == 200
      cb(null, @response)
    else
      cb(@statusText)
  
  xhr.onerror = ->
    cb(@statusText)
  
  xhr.send()


loadUserdata = (done) ->
  loadJSON 'userdata.json', (err, data) ->
    return done(err) if err

    loadJSON data.keyUrl, (err, key) ->
      return done(err) if err
      
      try
        decrypted = util.crypto.decrypt(data, key)
      catch e
        return done(e)
      
      if decrypted.keyUrl != data.keyUrl
        return done('keyUrl is miss match')
      
      done(null, decrypted)


main()