require 'lib.moonloader'

script_name('fixator')
script_version("25.06.2022")
script_author("qrlk")
script_url("https://github.com/qrlk/fixator")
script_description("Воспроизводит звук, когда в зоне прорисовки появляются игроки со скинами из списка.")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://cfcf2de871ce442d803ac9e87228e965@o1272228.ingest.sentry.io/6529779" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/fixator/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/fixator"
    end
  end
end

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

  -- вырежи тут, если хочешь отключить проверку обновлений
  if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
  end
  -- вырежи тут, если хочешь отключить проверку обновлений

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