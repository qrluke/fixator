script_name('fixator')
script_version("22.09.2019")
script_author("qrlk")
script_url("https://github.com/qrlk/fixator")
script_description("Воспроизводит звук, когда в зоне прорисовки появляются игроки со скинами из списка.")

local as_action = require('moonloader').audiostream_state
local sampev = require 'lib.samp.events'

sound = false
sound1 = false

musora = false
obideli = false

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
    downloadUrlToFile("http://qrlk.me/dev/moonloader/!edith/musora.mp3", file)
  end

  file1 = getGameDirectory().."\\moonloader\\resource\\musora2.mp3"
  if not doesFileExist(file1) then
    downloadUrlToFile("http://qrlk.me/dev/moonloader/!edith/obideli.mp3", file1)
  end

  lua_thread.create(musora_detector)
  lua_thread.create(musora_handle)

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
  skins = Set { 165, 166, 280, 281, 282, 283, 284, 285, 286, 288, 300, 301, 302, 303, 304, 305, 306, 307, 309, 310, 311, 163, 164 }
  while true do
    wait(200)
    detected = false
    for k, v in pairs(getAllChars()) do
      if doesCharExist(v) then
        f = getCharModel(v)
        if skins[f] then
          if math.random(1,2) == 1 then
            musora = true
          else
            obideli = true
          end
          detected = true
          break
        end
      end
    end
    if not detected then
      musora = false
      obideli = false
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
