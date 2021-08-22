require 'lib.moonloader'

script_name('fixator')
script_version("31.03.2020")
script_author("qrlk")
script_url("https://github.com/qrlk/fixator")
script_description("Воспроизводит звук, когда в зоне прорисовки появляются игроки со скинами из списка.")

local as_action = require('moonloader').audiostream_state
local sampev = require 'lib.samp.events'

sound = false
sound1 = false
sound3 = false
sound4 = false
sound5 = false
sound6 = false
sound7 = false
sound8 = false


musora = false
obideli = false
sound33 = false
sound44 = false
sound55 = false
sound66 = false
sound77 = false
sound88 = false

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end

  --вырезать если хочешь отключить автообновление
  update("http://qrlk.me/dev/moonloader/fixator/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods", "fixatorchangelog")
  openchangelog("fixatorchangelog", "http://qrlk.me/changelog/fixator")
  --вырезать если хочешь отключить автообновление

  if not doesDirectoryExist(getGameDirectory().."\\moonloader\\resource") then
    createDirectory(getGameDirectory().."\\moonloader\\resource")
  end
  file = getGameDirectory().."\\moonloader\\resource\\musora1.mp3"
  if not doesFileExist(file) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/musora.mp3", file)
  end

  file1 = getGameDirectory().."\\moonloader\\resource\\musora2.mp3"
  if not doesFileExist(file1) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/obideli.mp3", file1)
  end

  file3 = getGameDirectory().."\\moonloader\\resource\\musora3.mp3"
  if not doesFileExist(file3) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/musora3.mp3", file3)
  end

  file4 = getGameDirectory().."\\moonloader\\resource\\musora4.mp3"
  if not doesFileExist(file4) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/musora4.mp3", file4)
  end

  file5 = getGameDirectory().."\\moonloader\\resource\\musora5.ogg"
  if not doesFileExist(file5) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/musora5.ogg", file5)
  end

  file6 = getGameDirectory().."\\moonloader\\resource\\musora6.ogg"
  if not doesFileExist(file6) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/musora6.ogg", file6)
  end

  file7 = getGameDirectory().."\\moonloader\\resource\\musora7.ogg"
  if not doesFileExist(file7) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/musora7.ogg", file7)
  end


  file8 = getGameDirectory().."\\moonloader\\resource\\musora8.ogg"
  if not doesFileExist(file8) then
    downloadUrlToFile("https://github.com/qrlk/fixator/raw/master/resource/musora8.ogg", file8)
  end

  lua_thread.create(musora_detector)
  lua_thread.create(musora_handle)

  a1 = loadAudioStream(file)
  a2 = loadAudioStream(file1)
  a3 = loadAudioStream(file3)
  a4 = loadAudioStream(file4)
  a5 = loadAudioStream(file5)
  a6 = loadAudioStream(file6)
  a7 = loadAudioStream(file7)
  a8 = loadAudioStream(file8)

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
    if sound3 then
      if getAudioStreamState(a3) ~= as_action.PLAY then
        setAudioStreamState(a3, as_action.PLAY)
      end
      sound3 = false
    end
    if sound4 then
      if getAudioStreamState(a4) ~= as_action.PLAY then
        setAudioStreamState(a4, as_action.PLAY)
      end
      sound4 = false
    end
    if sound5 then
      if getAudioStreamState(a5) ~= as_action.PLAY then
        setAudioStreamState(a5, as_action.PLAY)
      end
      sound5 = false
    end
    if sound6 then
      if getAudioStreamState(a6) ~= as_action.PLAY then
        setAudioStreamState(a6, as_action.PLAY)
      end
      sound6 = false
    end
    if sound7 then
      if getAudioStreamState(a7) ~= as_action.PLAY then
        setAudioStreamState(a7, as_action.PLAY)
      end
      sound7 = false
    end
    if sound8 then
      if getAudioStreamState(a8) ~= as_action.PLAY then
        setAudioStreamState(a8, as_action.PLAY)
      end
      sound8 = false
    end
  end
end

function musora_detector()
  skins = Set { 165, 166, 280, 281, 282, 283, 284, 285, 286, 288, 300, 301, 302, 303, 304, 305, 306, 307, 309, 310, 311, 163, 164 }
  while true do
    wait(200)
    detected = false
    for k, v in pairs(getAllChars()) do
      if doesCharExist(v) then
        f = getCharModel(v)
        if skins[f] and sampGetPlayerIdByCharHandle(v) then
          math.randomseed(os.time())
          ran = math.random(1, 8)
          if ran == 1 then
            musora = true
          elseif ran == 2 then
            obideli = true
          elseif ran == 3 then
            sound33 = true
          elseif ran == 4 then
            sound44 = true
          elseif ran == 5 then
            sound55 = true
          elseif ran == 6 then
            sound66 = true
          elseif ran == 7 then
            sound77 = true
          elseif ran == 8 then
            sound88 = true
          end
          detected = true
          break
        end
      end
    end
    if not detected then
      musora = false
      obideli = false
      sound33 = false
      sound44 = false
      sound55 = false
      sound66 = false
      sound77 = false
      sound88 = false
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
    if obideli then
      sound1 = true
      while obideli do wait(1000) end
      wait(2000)
    end
    if sound33 then
      sound3 = true
      while sound33 do wait(1000) end
      wait(2000)
    end
    if sound44 then
      sound4 = true
      while sound44 do wait(1000) end
      wait(2000)
    end
    if sound55 then
      sound5 = true
      while sound55 do wait(1000) end
      wait(2000)
    end
    if sound66 then
      sound6 = true
      while sound66 do wait(1000) end
      wait(2000)
    end
    if sound77 then
      sound7 = true
      while sound77 do wait(1000) end
      wait(2000)
    end
    if sound88 then
      sound8 = true
      while sound88 do wait(1000) end
      wait(2000)
    end
  end
end

function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update(php, prefix, url, komanda)
  komandaA = komanda
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  serial = serial[0]
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  if thisScript().name == "ADBLOCK" then
    if mode == nil then mode = "unsupported" end
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&m='..mode..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  else
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  end
  downloadUrlToFile(php, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            if info.changelog ~= nil then
              changelogurl = info.changelog
            end
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix, komanda)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      if komandaA ~= nil then
                        sampAddChatMessage((prefix..'Обновление завершено! Подробнее об обновлении - /'..komandaA..'.'), color)
                      end
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function openchangelog(komanda, url)
  sampRegisterChatCommand(komanda,
    function()
      lua_thread.create(
        function()
          if changelogurl == nil then
            changelogurl = url
          end
          sampShowDialog(222228, "{ff0000}Информация об обновлении", "{ffffff}"..thisScript().name.." {ffe600}собирается открыть свой changelog для вас.\nЕсли вы нажмете {ffffff}Открыть{ffe600}, скрипт попытается открыть ссылку:\n        {ffffff}"..changelogurl.."\n{ffe600}Если ваша игра крашнется, вы можете открыть эту ссылку сами.", "Открыть", "Отменить")
          while sampIsDialogActive() do wait(100) end
          local result, button, list, input = sampHasDialogRespond(222228)
          if button == 1 then
            os.execute('explorer "'..changelogurl..'"')
          end
        end
      )
    end
  )
end
