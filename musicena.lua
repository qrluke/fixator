local as_action = require('moonloader').audiostream_state
local sampev = require 'lib.samp.events'

sound = false
sound1 = false

musora = false
carroza = false
function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end
  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource") then
    createDirectory(getGameDirectory().."\\moonloader\\resource")
  end
  file = getGameDirectory().."\\moonloader\\resource\\musora.mp3"
  if not doesFileExist(file) then
    downloadUrlToFile("http://qrlk.me/dev/moonloader/!edith/musora.mp3", file)
  end

  file1 = getGameDirectory().."\\moonloader\\resource\\arbuz.mp3"
  if not doesFileExist(file1) then
    downloadUrlToFile("http://qrlk.me/dev/moonloader/!edith/arbuz.mp3", file1)
  end

  lua_thread.create(musora_detector)
  lua_thread.create(musora_handle)

	lua_thread.create(carroza_detector)
  lua_thread.create(carroza_handle)

  a1 = loadAudioStream(file)
  a2 = loadAudioStream(file1)
  while true do
    wait(0)
    if sound then
      if getAudioStreamState(a1) ~= as_action.PLAY then
        setAudioStreamState(a1, as_action.PLAY)
      end
      sound = false
    end
    if sound1 then
      if getAudioStreamState(a2) ~= as_action.PLAY then
        setAudioStreamState(a2, as_action.PLAY)
      end
      sound1 = false
    end
  end
end

function musora_detector()
  while true do
    wait(200)
    detected = false
    for k, v in pairs(getAllChars()) do
      if doesCharExist(v) then
        f = getCharModel(v)
        if f == 165 or f == 166 or f == 280 or f == 281 or f == 282 or f == 283 or f == 284 or f == 285 or f == 286 or f == 288 or f == 300 or f == 301 or f == 302 or f == 303 or f == 304 or f == 305 or f == 306 or f == 307 or f == 309 or f == 310 or f == 311 or f == 163 or f == 164 then
          musora = true
          detected = true
          break
        end
      end
    end
    if not detected then
      musora = false
    end
  end
end

function musora_handle()
  while true do
    wait(0)
    if musora then
      sound = true
      while musora do wait(1000) end
      wait(2000)
    end
  end
end

function carroza_detector()
  while true do
    wait(200)
    detected_carroza = false
    for k, v in pairs(getAllChars()) do
      if doesCharExist(v) then
        res, id = sampGetPlayerIdByCharHandle(v)
        if res then
          if sampIsPlayerConnected(id) and string.find(sampGetPlayerNickname(id), "arozza") then
            carroza = true
            detected_carroza = true
            break
          end
        end
      end
      if not detected_carroza then
        carroza = false
      end
    end
  end
end

function carroza_handle()
  while true do
    wait(0)
    if carroza then
      sound1 = true
      while carroza do wait(1000) end
      wait(2000)
    end
  end
end
