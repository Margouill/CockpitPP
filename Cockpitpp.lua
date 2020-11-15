----------------------------------------------------------------------------------
--
--                          []                         []
--                          ||   ___     ___     ___   ||
--                          ||  /   \   /| |\   /   \  ||
--                          || |  O  |__|| ||__|  O  | ||
--                          ||  \___/--/^^^^^\--\___/  ||
--                      __  ||________|       |________||  __
--   .-----------------/  \-++--------|   .   |--------++-/  \-----------------.
--  /.---------________|  |___________\__(*)__/___________|  |________---------.\
--            |    |   '$$'   |                       |   '$$'   |    |
--           (o)  (o)        (o)                     (o)        (o)  (o)
--
-- Because we all love the BBBBBBBBRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRTTTTTTTTTTTTTT
--
-- AsciiArt A-10 Thunderbolt II from: Mike Whaley, Georgia Tech, 
-- source: http://xcski.com/~ptomblin/planes.txt
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
--Pilot, please edit only these three lines
----------------------------------------------------------------------------------
-- PUT YOUR ANDROID IP(S) in the next line, you will find the Android IP in the app, going in 'settings':
local clientIP={"192.168.1.12"} 
-- If you want to have several devices, just add IP like that : clientIP={"192.168.0.10","192.168.0.15"}


--Editable but not mandatory, put them in the app
local DCS_PORT = 14801
local ANDROID_PORT = 14800
----------------------------------------------------------------------------------




----------------------------------------------------------------------------------
--Developers, if you know what you are doing, feel free to change things here
----------------------------------------------------------------------------------
local version = 5
local log_file = nil
local lengthIPTable = 0
local ipUsed = 1
local DELAY = 5 --Reduce this value if you want to have a hight framerate, but can affect your CPU for DCS!!!
local POSITION = 0

local HEAD_MSG = "Cockpit++"
local msgOut =""

local prevLuaExportStart = LuaExportStart

function LuaExportStart()

	if prevLuaExportStart then
        prevLuaExportStart()
    end
	
	lengthIPTable = table.getn(clientIP)

	log_file = io.open(lfs.writedir().."/Logs/Cockpit++_Logger.log", "w")
	
	log_file:write("Opening file")
	log_file:write("\n")

	package.path  = package.path..";"..lfs.currentdir().."/LuaSocket/?.lua"
  	package.cpath = package.cpath..";"..lfs.currentdir().."/LuaSocket/?.dll"
	socket = require("socket")
 	udp = socket.udp()
	udp:setsockname("*", DCS_PORT)
	udp:setoption('broadcast', true)
	udp:settimeout(0)
end


local RELEASE = 0
local TYPEBUTTON = 0
local DEVICE = 0
local COMMAND = 0
local VALUE = 0

local prevLuaExportBeforeNextFrame = LuaExportBeforeNextFrame

function LuaExportBeforeNextFrame()
	

	if prevLuaExportBeforeNextFrame then
        prevLuaExportBeforeNextFrame()
    end
	
	if RELEASE == 1 then
		RELEASE = 0
		GetDevice(DEVICE):performClickableAction(COMMAND,1*0)
		
	else
		data, ip, port = udp:receivefrom()
		
		if data then
	  
			local dataArray = string.gmatch(data, '([^,]+)')

			if dataArray(1)==HEAD_MSG then

				TYPEBUTTON = dataArray(2)
				DEVICE = dataArray(3)
				COMMAND = dataArray(4)
				VALUE = dataArray(5)
				
				if TYPEBUTTON == "1" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "2" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "3" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "4" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "5" then
						RELEASE = 1
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "6" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
				
				if TYPEBUTTON == "7" then
						GetDevice(DEVICE):performClickableAction(COMMAND,VALUE)
				end
			end    
		end
	end

	
end

local prevLuaExportAfterNextFrame = LuaExportAfterNextFrame

function LuaExportAfterNextFrame()

	if prevLuaExportAfterNextFrame then
        prevLuaExportAfterNextFrame()
	end
	
	POSITION = POSITION + 1

	if(POSITION == DELAY) then
		local selfData = LoGetSelfData()
		if selfData then
		
			currentAircraft = selfData["Name"]
        
			msgOut = HEAD_MSG..","..version..","..currentAircraft ..","
			
			
			if currentAircraft == "A-10C" and GetDevice(0) ~= 0 then
     		local MainPanel = GetDevice(0)
     		vvi = MainPanel:get_argument_value(12)
				hsi_course = MainPanel:get_argument_value(47)
				hsi_power_off_flag =  MainPanel:get_argument_value(40)
				hsi_range_flag =  MainPanel:get_argument_value(32)
				hsi_bearing_flag =  MainPanel:get_argument_value(46)
				hsi_hdg =  MainPanel:get_argument_value(34)
				hsi_bearing1 =  MainPanel:get_argument_value(33)
				hsi_bearing2 =  MainPanel:get_argument_value(35)
				hsi_hdg_bug =  MainPanel:get_argument_value(36)
				hsi_cc_a =  MainPanel:get_argument_value(37)
				hsi_cc_b =  MainPanel:get_argument_value(39) 
				hsi_rc_a =  MainPanel:get_argument_value(28)
				hsi_rc_b =  MainPanel:get_argument_value(29)
				hsi_rc_c =  MainPanel:get_argument_value(30)
				hsi_rc_d =  MainPanel:get_argument_value(31)
				hsi_deviation =  MainPanel:get_argument_value(41)
				hsi_tofrom1 =  MainPanel:get_argument_value(42)
				hsi_tofrom2 =  MainPanel:get_argument_value(43)				
				hsi = hsi_course .. ";" ..  hsi_power_off_flag .. ";" ..  hsi_range_flag .. ";" ..  hsi_bearing_flag .. ";" ..  hsi_hdg .. ";" ..  hsi_bearing1 .. ";" ..  hsi_bearing2 .. ";" ..  hsi_hdg_bug .. ";" ..  hsi_cc_a .. ";" ..  hsi_cc_b .. ";" .. hsi_rc_a  .. ";" ..  hsi_rc_b .. ";" ..  hsi_rc_c  .. ";" ..  hsi_rc_d .. ";" ..  hsi_deviation  .. ";" ..  hsi_tofrom1 .. ";" ..  hsi_tofrom2
				
				engine_left_core_speed_tenth = MainPanel:get_argument_value(78)
				engine_right_core_speed_tenth = MainPanel:get_argument_value(80)
				engine_left_core_speed = MainPanel:get_argument_value(79)
				engine_right_core_speed = MainPanel:get_argument_value(81)
				engine_left_oil_pressure = MainPanel:get_argument_value(82)
				engine_right_oil_pressure = MainPanel:get_argument_value(83)				
				emi_left_panel_gauges = engine_left_core_speed_tenth .. ";" ..  engine_right_core_speed_tenth .. ";" ..  engine_left_core_speed .. ";" ..  engine_right_core_speed .. ";" ..  engine_left_oil_pressure .. ";" ..  engine_right_oil_pressure
								
				engine_left_fan_speed = MainPanel:get_argument_value(76)
				engine_right_fan_speed = MainPanel:get_argument_value(77)
				engine_left_fuel_flow = MainPanel:get_argument_value(84)
				engine_right_fuel_flow = MainPanel:get_argument_value(85)
				apu_rpm = MainPanel:get_argument_value(13)
				apu_temperature = MainPanel:get_argument_value(14)
				emi_right_panel_gauges = engine_left_fan_speed .. ";" ..  engine_right_fan_speed .. ";" ..  engine_left_fuel_flow .. ";" ..  engine_right_fuel_flow .. ";" ..  apu_rpm .. ";" ..  apu_temperature
				
     				msgOut = msgOut .. vvi .. "," .. hsi .. "," .. emi_left_panel_gauges .. "," .. emi_right_panel_gauges .." \n"
				--msgOut(0) Cockpit++ (header)
				--msgOut(1) lua version
				--msgOut(2) aircraft identifier
				--msgOut(3) vvi
				--msgOut(4) hsi ; separated
				--msgOut(5) emi_left ; separated
				--msgOut(6) emi_right ; separated
				--[[ 
					HSI table :
					0 = hsi_course
					1 = hsi_power_off_flag
					2 = hsi_range_flag
					3 = hsi_bearing_flag
					4 = hsi_hdg
					5 = hsi_bearing1
					6 = hsi_bearing2
					7 = hsi_hdg_bug
					8 = hsi_cc_a
					9 = hsi_cc_b
					10 = hsi_rc_a
					11 = hsi_rc_b
					12 = hsi_rc_c
					13 = hsi_rc_d
					14 = hsi_deviation
					15 = hsi_tofrom1
					16 = hsi_tofrom2
					
					EMI left panel gauges table :
					[0] = engine_left_core_speed_tenth
					[1] = engine_right_core_speed_tenth
					[2] = engine_left_core_speed
					[3] = engine_right_core_speed
					[4] = engine_left_oil_pressure
					[5] = engine_right_oil_pressure
					
					EMI right panel gauges table :
					[0] = engine_left_fan_speed
					[1] = engine_right_fan_speed
					[2] = engine_left_fuel_flow
					[3] = engine_right_fuel_flow
					[4] = apu_rpm
					[5] = apu_temperature
				]]--
				
			elseif currentAircraft == "M-2000C" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
  
				pca = MainPanel:get_argument_value(234) ..";".. MainPanel:get_argument_value(463) ..";".. MainPanel:get_argument_value(249) ..";".. MainPanel:get_argument_value(248) ..";".. MainPanel:get_argument_value(236) ..";".. MainPanel:get_argument_value(238) ..";".. MainPanel:get_argument_value(240) ..";".. MainPanel:get_argument_value(242) ..";".. MainPanel:get_argument_value(244) ..";".. MainPanel:get_argument_value(246) ..";".. MainPanel:get_argument_value(247) ..";".. MainPanel:get_argument_value(251) ..";".. MainPanel:get_argument_value(252) ..";".. MainPanel:get_argument_value(254) ..";".. MainPanel:get_argument_value(255) ..";".. MainPanel:get_argument_value(257) ..";".. MainPanel:get_argument_value(258) ..";".. MainPanel:get_argument_value(260) ..";".. MainPanel:get_argument_value(261) ..";".. MainPanel:get_argument_value(263) ..";".. MainPanel:get_argument_value(264)

				ppa = MainPanel:get_argument_value(276) ..";".. MainPanel:get_argument_value(265) ..";".. MainPanel:get_argument_value(277) ..";".. MainPanel:get_argument_value(278) ..";".. MainPanel:get_argument_value(275) ..";".. MainPanel:get_argument_value(267) ..";".. MainPanel:get_argument_value(268) ..";".. MainPanel:get_argument_value(270) ..";".. MainPanel:get_argument_value(271) ..";".. MainPanel:get_argument_value(273) ..";".. MainPanel:get_argument_value(274) ..";".. MainPanel:get_argument_value(280) ..";".. MainPanel:get_argument_value(281)
				
				local insdata = "";
				for line in string.gmatch(list_indication(9), "[^%s]+") do
					insdata = insdata.."\n"..line:sub(-25)	

				end


				ins = MainPanel:get_argument_value(669) ..";".. MainPanel:get_argument_value(670) ..";".. MainPanel:get_argument_value(671) ..";".. MainPanel:get_argument_value(564) ..";".. MainPanel:get_argument_value(565) ..";".. MainPanel:get_argument_value(566) ..";".. MainPanel:get_argument_value(567) ..";".. MainPanel:get_argument_value(568) ..";".. MainPanel:get_argument_value(569) ..";".. MainPanel:get_argument_value(574) ..";".. MainPanel:get_argument_value(575) ..";".. MainPanel:get_argument_value(571) ..";".. MainPanel:get_argument_value(668) ..";".. MainPanel:get_argument_value(573) ..";".. MainPanel:get_argument_value(577) ..";".. MainPanel:get_argument_value(579)..";".. MainPanel:get_argument_value(581)..";".. MainPanel:get_argument_value(583)..";".. MainPanel:get_argument_value(595)..";".. MainPanel:get_argument_value(597)

				ins_knob = MainPanel:get_argument_value(627)..";".. MainPanel:get_argument_value(629)
				
				msgOut = msgOut..list_indication(4)..","..list_indication(5)..","..pca..","..list_indication(6)..","..ppa..","..insdata..","..list_indication(10)..","..ins..","..ins_knob..",".." \n"

				
			elseif currentAircraft == "F-15C" and LoGetTWSInfo() then
				local result_of_LoGetTWSInfo = LoGetTWSInfo()
				if result_of_LoGetTWSInfo then
					local data =""
					local allSpots =""
					local spot =""
					local name =""
					for k,emitter_table in pairs (result_of_LoGetTWSInfo.Emitters) do
						name = LoGetNameByType(emitter_table.Type.level1,emitter_table.Type.level2,emitter_table.Type.level3,emitter_table.Type.level4)
						if name == nil or name == '' then
							name = "UK"
						end
						spot = name .. ":" .. emitter_table.Power .. ":" .. emitter_table.Azimuth .. ":" .. emitter_table.Priority .. ":" .. emitter_table.SignalType .. ":" .. emitter_table.Type.level1 .. ":" .. emitter_table.Type.level2 .. ":" .. emitter_table.Type.level3 .. ":" .. emitter_table.Type.level4
						allSpots = allSpots .. ";" .. spot
					end
					data = result_of_LoGetTWSInfo.Mode .. ",".. allSpots	
					msgOut = msgOut..data
				end
				
				
			elseif currentAircraft == "UH-1H" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
				armament_panel = MainPanel:get_argument_value(252) ..";".. MainPanel:get_argument_value(253) ..";".. MainPanel:get_argument_value(256) ..";".. MainPanel:get_argument_value(257) ..";".. MainPanel:get_argument_value(258) ..";".. MainPanel:get_argument_value(259) ..";".. MainPanel:get_argument_value(260)
				msgOut = msgOut..armament_panel..",".." \n"
		
				
			elseif currentAircraft == "AV8BNA" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
				msgOut = msgOut..MainPanel:get_argument_value(487) ..";".. MainPanel:get_argument_value(488) ..",".." \n"
				
		
			elseif currentAircraft == "MiG-21Bis" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
				radarPanel = MainPanel:get_argument_value(205) ..";".. MainPanel:get_argument_value(206) ..";".. MainPanel:get_argument_value(207) ..";".. MainPanel:get_argument_value(553) ..";".. MainPanel:get_argument_value(554) ..";".. MainPanel:get_argument_value(555)
				
				
				msgOut = msgOut.. radarPanel ..",".." \n"
		
			elseif currentAircraft == "Ka-50" and GetDevice(0) ~= 0 then
				local MainPanel = GetDevice(0)
				
				
				--HUD = list_indication(1)
				--SHKVAL = list_indication(2)
				--ABRIS = list_indication(3)				
				--ERKAN = list_indication(4)				
				--PVI800 = list_indication(5)
				--Weapon = list_indication(6)
				--UV26 = list_indication(7)
				--ADF = list_indication(9)
				--WarningPanel = list_indication(12)
				
				--log_file:write(list_indication(6))

				local function getPUI800_txt_canon_count()
					local canon_count = "---"
					local m = list_indication(6):gmatch("-----------------------------------------\n([^\n]+)\n([^\n]*)\n")
				
					while true do
						local name, value = m()
						if not name then break end
						if name == "txt_cannon_count" then
							canon_count = value;
						end
					end

					return canon_count;
				end
				
				local function getPUI800_txt_weapon_count()
					local count = "---"
					local m = list_indication(6):gmatch("-----------------------------------------\n([^\n]+)\n([^\n]*)\n")
				
					while true do
						local name, value = m()
						if not name then break end
						if name == "txt_weap_count" then
							count = value;
						end
					end

					return count;
				end
				
				local function getPUI800_txt_weapon_type()
					local weapon_type = "---"
					local m = list_indication(6):gmatch("-----------------------------------------\n([^\n]+)\n([^\n]*)\n")
					
					--log_file:write(list_indication(6).."\n")
					while true do
						local name, value = m()
						if not name then break end
						
						if name == "txt_weap_type_AT" then
							if(value == "ПС") then
								weapon_type = "NC";
							end
						end
						
						if name == "txt_weap_type_RT" then
							if(value == "НР") then
								weapon_type = "HP";
							end
						end
						
					end


					return weapon_type;
				end				

				local function getUV26Display()
					local ind = "---"
					local m = list_indication(7):gmatch("-----------------------------------------\n([^\n]+)\n([^\n]*)\n")
					
					log_file:write(list_indication(7).."\n")
					
					
					while true do
						local name, value = m()
						if not name then break end
						
						if name == "txt_digits" then
							ind = value;
						end
					end
					
					return ind
				end
									
				--log_file:write(getPUI800_txt_weapon_type().."-")
				--log_file:write(getPUI800_txt_weapon_count().."-")
				--log_file:write(getPUI800_txt_canon_count().."\n")
				
				PUI800Switchs =    MainPanel:get_argument_value(387) ..";"
								.. MainPanel:get_argument_value(396) ..";"
								.. MainPanel:get_argument_value(397) ..";"
								.. MainPanel:get_argument_value(398) ..";"
								.. MainPanel:get_argument_value(399) ..";"
								.. MainPanel:get_argument_value(400) ..";"
								.. MainPanel:get_argument_value(401) ..";"
								.. MainPanel:get_argument_value(402) ..";"
								.. MainPanel:get_argument_value(403) ..";"
				
				PUI800Leds =   MainPanel:get_argument_value(388) ..";"
							.. MainPanel:get_argument_value(389) ..";"
							.. MainPanel:get_argument_value(390) ..";"
							.. MainPanel:get_argument_value(391) ..";"
							.. MainPanel:get_argument_value(392) ..";"
							.. MainPanel:get_argument_value(393) ..";"
							.. MainPanel:get_argument_value(394) ..";"
							.. MainPanel:get_argument_value(395) ..";"
				
				PUI800Displays = getPUI800_txt_weapon_type() ..";"
							.. getPUI800_txt_weapon_count() ..";"
							.. getPUI800_txt_canon_count() ..";"
				
				
				PRTzLeds =     MainPanel:get_argument_value(21) ..";"
							.. MainPanel:get_argument_value(22) ..";"
							.. MainPanel:get_argument_value(23) ..";"
							.. MainPanel:get_argument_value(50) ..";"
							
							.. MainPanel:get_argument_value(17) ..";"
							.. MainPanel:get_argument_value(18) ..";"
							.. MainPanel:get_argument_value(19) ..";"
							.. MainPanel:get_argument_value(20) ..";"
							.. MainPanel:get_argument_value(16) ..";"
							
							.. MainPanel:get_argument_value(15) ..";"
							.. MainPanel:get_argument_value(161) ..";"
							.. MainPanel:get_argument_value(150) ..";"
							.. MainPanel:get_argument_value(159) ..";"

				
				
				LWRLeds =    MainPanel:get_argument_value(27) ..";"
							.. MainPanel:get_argument_value(25) ..";"
							.. MainPanel:get_argument_value(28) ..";"
							.. MainPanel:get_argument_value(26) ..";"
							.. MainPanel:get_argument_value(31) ..";"
							.. MainPanel:get_argument_value(32) ..";"
							.. MainPanel:get_argument_value(33) ..";"
							.. MainPanel:get_argument_value(34) ..";"
				
				UV26Switchs =  MainPanel:get_argument_value(36) ..";"
							.. MainPanel:get_argument_value(37) ..";"	
							
				UV26Leds = 	   MainPanel:get_argument_value(541) ..";"
							.. MainPanel:get_argument_value(542) ..";"

				UV26Displays = getUV26Display()..";"
				
				CautionLeds =  MainPanel:get_argument_value(78) ..";"
							.. MainPanel:get_argument_value(79) ..";"
							.. MainPanel:get_argument_value(80) ..";"
							.. MainPanel:get_argument_value(81) ..";"
							.. MainPanel:get_argument_value(82) ..";"
							.. MainPanel:get_argument_value(83) ..";"
							.. MainPanel:get_argument_value(84) ..";"
							.. MainPanel:get_argument_value(85) ..";"
							.. MainPanel:get_argument_value(86) ..";"
				
				
				EKRAN_Displays = ""
				
				
				OverheadSwitchs =  MainPanel:get_argument_value(146) ..";"
								.. MainPanel:get_argument_value(147) ..";"
								.. MainPanel:get_argument_value(539) ..";"
								.. MainPanel:get_argument_value(151) ..";"
								.. MainPanel:get_argument_value(153) ..";"
								.. MainPanel:get_argument_value(154) ..";"
				
				OverheadLeds = 	   MainPanel:get_argument_value(167) ..";"
								.. MainPanel:get_argument_value(189) ..";"
								.. MainPanel:get_argument_value(181) ..";"
								.. MainPanel:get_argument_value(182) ..";"
								.. MainPanel:get_argument_value(200) ..";"
								.. MainPanel:get_argument_value(201) ..";"
								.. MainPanel:get_argument_value(180) ..";"
								.. MainPanel:get_argument_value(206) ..";"
								.. MainPanel:get_argument_value(190) ..";"
								.. MainPanel:get_argument_value(191) ..";"
								.. MainPanel:get_argument_value(209) ..";"
								.. MainPanel:get_argument_value(210) ..";"
								.. MainPanel:get_argument_value(179) ..";"
								.. MainPanel:get_argument_value(212) ..";"
								.. MainPanel:get_argument_value(207) ..";"
								.. MainPanel:get_argument_value(208) ..";"
								.. MainPanel:get_argument_value(185) ..";"
								.. MainPanel:get_argument_value(186) ..";"
								.. MainPanel:get_argument_value(188) ..";"
								.. MainPanel:get_argument_value(205) ..";"
								.. MainPanel:get_argument_value(183) ..";"
								.. MainPanel:get_argument_value(184) ..";"
								.. MainPanel:get_argument_value(202) ..";"
								.. MainPanel:get_argument_value(203) ..";"
								
								.. MainPanel:get_argument_value(165) ..";"
								.. MainPanel:get_argument_value(165) ..";"
								.. MainPanel:get_argument_value(164) ..";"
								.. MainPanel:get_argument_value(211) ..";"
								.. MainPanel:get_argument_value(170) ..";"
								.. MainPanel:get_argument_value(171) ..";"
								.. MainPanel:get_argument_value(178) ..";"
								.. MainPanel:get_argument_value(187) ..";"
								.. MainPanel:get_argument_value(175) ..";"
								.. MainPanel:get_argument_value(176) ..";"
								.. MainPanel:get_argument_value(173) ..";"
								.. MainPanel:get_argument_value(204) ..";"
								.. MainPanel:get_argument_value(172) ..";"
								.. MainPanel:get_argument_value(166) ..";"
								.. MainPanel:get_argument_value(177) ..";"
								.. MainPanel:get_argument_value(213) ..";"
								
				OverheadInstrument = MainPanel:get_argument_value(587) ..";"
				
				--log_file:write(OverheadSwitchs.."\n");
				--log_file:write(OverheadLeds.."\n");
				
				--msgOut = msgOut ..PUI800Switchs..PUI800Leds..PUI800Displays..","..OverheadSwitchs..OverheadLeds..","..UV26Switchs..UV26Leds..","..PRTzLeds..","..LWRLeds
				msgOut = msgOut ..PUI800Switchs..PUI800Leds..PUI800Displays..","..OverheadSwitchs..OverheadLeds..OverheadInstrument..","..UV26Switchs..UV26Leds..UV26Displays..","..PRTzLeds..","..LWRLeds
								--..PUI800Switchs..PUI800Leds..PUI800Displays..","
			--log_file:write(msgOut)
			end
			
				
			--log_file:write("\n")
			--log_file:write(msgOut)
			--log_file:write("\n")
			--Sending data to device
			udp:sendto(msgOut, clientIP[ipUsed], ANDROID_PORT)
			
			--To alternate data transmission between several devices
			if ipUsed == lengthIPTable then
				ipUsed = 1
			else
				ipUsed = ipUsed + 1
			end
		end
		POSITION = 0
	end
end

local prevLuaExportStop = LuaExportStop

function LuaExportStop()

	if prevLuaExportStop then
        prevLuaExportStop()
    end
	
   if log_file then
   	log_file:write("Closing log file...")
   	log_file:close()
   	log_file = nil
   end
end




----------------------------------------------------------------------------------
--
--
--     _         Spitfire
--   |   \       Murray "Moray" Lalor
--  | |    \
-- |  |     \                               __---___
-- |  |      \ _____________---------------^      | ^\
--  | | =======--_               ___     \________|__*^--------------__________
--   ^-____                    /  _  \    Capt. Moray  #######     ********  | \
--        * -----_______      (  (_)  )                ###                  _ -'
--                      -------\____ /                                __ - '
--                                   -----======________:----------- '
--
--
-- source: http://xcski.com/~ptomblin/planes.txt