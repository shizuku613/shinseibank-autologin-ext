USER_ID_NAME = 'fldUserID'
USER_NUMID_NAME = 'fldUserNumId'
USER_PASS_NAME = 'fldUserPass'
LOGIN_BUTTON_ID = 'loginbutton'
SECURITY_CARD_ID = 'main-left-securitycard'
SECURITY_CARD_POSITION_SEL = 'td > strong'
SECURITY_CARD_NAMES = ['fldGridChg1', 'fldGridChg2', 'fldGridChg3']

LAST_FIRST_STEP_DATE_KEY = 'lastFirstStepDate'
LAST_SECOND_STEP_DATE_KEY = 'lastSecondStepDate'
FIRST_STEP_INTERVAL_MS = 10 * 1000
SECOND_STEP_INTERVAL_MS = 10 * 1000


main = ->
  chrome.runtime.sendMessage { }, (res) ->
    return unless res
    
    securityCard = byId(SECURITY_CARD_ID)

    if securityCard
      secondStep(res.userdata)
      
    else
      firstStep(res.userdata)


firstStep = (data) ->
  console.log 'Start first step'
  
  unless checkStepInterval(LAST_FIRST_STEP_DATE_KEY, FIRST_STEP_INTERVAL_MS)
    return
  
  setByName(USER_ID_NAME,    data.userId)
  setByName(USER_NUMID_NAME, data.userNumid)
  setByName(USER_PASS_NAME,  data.userPass)

  byId(LOGIN_BUTTON_ID).click()


secondStep = (data) ->
  console.log 'Start second step'
  
  unless checkStepInterval(LAST_SECOND_STEP_DATE_KEY, SECOND_STEP_INTERVAL_MS)
    return
  
  positions = getSecurityCardPositions()
  elems = SECURITY_CARD_NAMES.map(byName)
  
  for position, i in positions
    val = getSecurityCardValue(data, position)
    
    # 正しく取得できていない場合は処理を中断
    return if typeof val != 'string' or val.length != 1
    
    elems[i].value = val
  
  # ログイン
  byId(LOGIN_BUTTON_ID).click()


checkStepInterval = (key, interval) ->
   # 前回の操作からの時間を計算
  lastStepDate = localStorage.getItem(key)
  if lastStepDate
    console.log 'Check last login date'
    
    if new Date() - new Date(lastStepDate) < interval
      console.log 'Skip step'
      return false
  
  localStorage.setItem(key, new Date().toUTCString())
  return true


getSecurityCardPositions = ->
  positions = []
  elems = document.querySelectorAll(SECURITY_CARD_POSITION_SEL)
  
  for elem in elems
    positions.push(elem.textContent)

  positions


getSecurityCardValue = (data, position) ->
  data.securityCard[position]


byId = (id) ->
  document.getElementById(id)


byName = (name) ->
  document.querySelector('[name="' + name + '"]')


setByName = (name, val) ->
  elem = byName(name)
  elem.value = val if elem


start = ->
  return main() if isReady()
  return if isLoggedIn()
  setTimeout start, 100


isReady = ->
  byName(USER_ID_NAME) or byId(SECURITY_CARD_ID)


isLoggedIn = ->
  document.getElementsByTagName('frameset').length > 0


start()