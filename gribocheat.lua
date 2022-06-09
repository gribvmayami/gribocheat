local event = require('lib.samp.events')
local imgui = require ('imgui')
local dlstatus = require('moonloader').download_status
local inicfg = require('inicfg')
local encoding = require ('encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)
local text_buffer imgui.ImBuffer(256)

imgui.Process = false

local sw, sh = getScreenResolution()

--  Чекбоксы короче
local checked_test = imgui.ImBool(false)
local checked_test_2 = imgui.ImBool(false)

--  апдейт хуевина
local script_vers = 2
local script_vers_text = "1.02"

local update_url = "https://raw.githubusercontent.com/gribvmayami/nuborp/master/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/gribvmayami/nuborp/blob/master/gribocheat.luac?raw=true"
local script_path = thisScript().path

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait (100) end

	sampAddChatMessage("{FFFF00}gribocheat{FF0000} BY {FF00FF}gribvmayami {FF0000}ACTIVATED", 0xFF0000)




	if main_window_state.v == false then
		imgui.Process = false
	end


	sampRegisterChatCommand("grmenu", cmd_imgui)

	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				updateIni = inicfg.load(nil, update_path)
				if tonumber(updateIni.info.vers) > script_vers then
					sampAddChatMessage("Есть обнова! Версия:" .. updateIni.info.vers_text, 0xFF)
					update_state = true
				end
			end
		end)




	while true do
		wait(0)
		if update_state then
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("Скрипт обновлен, у автора нету мамки", 0xFF00FF)
					thisScript():reload()
				end
			end)
			break
		end
	end
end

function cmd_check(arg)
	if checked_test.v == true then
		function event.RemovePlayerFromVehicle()
			return false
		end
	end
	if checked_test_2.v == true then
		function event.onApplyPlayerAnimation(playerId, animLib, animName, frameDelta, loop)
			return false
		end
		function event.ShowDialog(dialogId, style, title, button1, button2, text)
			return false
		end
	end
end


function cmd_imgui()
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end


function imgui.OnDrawFrame()
	imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
	imgui.SetNextWindowPos(imgui.ImVec2((sw / 2 ), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

	imgui.Begin(u8"gribocheat Menu by {0xFF00FF}gribvmayami v"..updateIni.info.vers_text, main_window_state)
	imgui.Text(u8"Скрипт нихуя не готов так что пока что соси хуй.")
	imgui.Separator()
	imgui.Checkbox(u8"Anti-Eject",checked_test)

	imgui.Checkbox(u8"ZZ-DM",checked_test_2)

	imgui.End()
end
