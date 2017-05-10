
CurrentDayTime = -1
CurrentDayHour = -1

local IsBellRinging = false
local ClassChangeLast = false

PvPEnabled = false

local chalkboard = Material("materials/assets/bullyrp/vgui/scoreboard/chalkboard.png")
local clock = Material("materials/assets/bullyrp/vgui/hud/clock.png")
local cog = Material("materials/assets/bullyrp/vgui/hud/cog.png")

local hudenabled = true

sound.Add( {
	name = "RingBell",
	channel = CHAN_STATIC,
	volume = 0.4,
	level = 80,
	sound = "ambient/alarms/alarm1.wav"
} )

local function RingBell()
	if not IsBellRinging then
		IsBellRinging = true
		LocalPlayer():EmitSound("RingBell")

		timer.Simple(
			4,
			function()
				LocalPlayer():StopSound("RingBell")
				IsBellRinging = false
			end
		)
	end
end

local function TimeHud()
	local W, H = ScrW(), ScrH()
	local w,h = 120, 60
	local x,y = 30, 30

	draw.RoundedBox(
		3,
		x,y,
		w + h,h,
		Color(33,33,33,200)
	)

	surface.SetDrawColor(240, 240, 240, 230)
	surface.SetMaterial(clock)
	surface.DrawTexturedRect(x+10, y+10, h-20, h-20)

	draw.SimpleText(
		"Time of Day",
		"CustomFontB",
		x + (w/2) + h - 5,
		y + 5,
		Color(255, 255, 255),
		TEXT_ALIGN_CENTER
	)

	local time = string.FormattedTime(CurrentDayTime)
	local hour = time.h
	local min = time.m
	local side = 'AM'

	if min <= 9 then
		min = "0" .. min
	end

	if hour >= 12 then
		side = "PM"
		time = string.FormattedTime(CurrentDayTime - SecondsInHalfDay)
		hour = time.h
	end

	if hour <= 9 then
		if hour == 0 then
			hour = "12"
		else
			hour = "0" .. hour
		end
	end

	local c = Color(255, 255, 255)

	if IsCurfew() then
		c = Color(192, 57, 43)
	end

	draw.SimpleText(
		hour .. ":" .. min .. " " .. side,
		"CustomFontA",
		x + (w/2) + h - 5,
		y + (h/2),
		c,
		TEXT_ALIGN_CENTER
	)
end

local function ClassHud()
	local W, H = ScrW(), ScrH()
	local w,h = 190, 60
	local x,y = W - w - 30, H - h - 30
	local periodName = "Invalid"

	draw.RoundedBox(
		3,
		x,y,
		w,h,
		Color(33,33,33,200)
	)

	draw.SimpleText(
		"Current Period",
		"CustomFontB",
		x + (w/2),
		y + 5,
		Color(255, 255, 255),
		TEXT_ALIGN_CENTER
	)

	local grade = tonumber(LocalPlayer():GetNWInt("grade"))

	if grade and grade == 8 then
		periodName = "See Counselor!"
	else
		local periodID = GetGlobalInt("ClassPeriod")
		periodName = "Free Time"
		local schedule = databaseGetValue("schedule")

		if periodID > 0 then
			local curtime = GetGlobalInt("ClassPeriodEnds") - CurTime() 
			local realtimec = curtime / LengthOfDay
			local realtime =  realtimec * SecondsInDay / 60

			if realtime > LengthOfPeriodInGame then
				periodName = "Class Change"
				if not ClassChangeLast then
					RingBell()
				end
				ClassChangeLast = true
			elseif periodID > 0 and schedule and schedule[periodID] and CLASSES[schedule[periodID]] then
				periodName = CLASSES[schedule[periodID]].Name
				if ClassChangeLast then
					RingBell()
				end
				ClassChangeLast = false
			else
				periodName = "Invalid"
			end
		elseif IsCurfew() then
			periodName = "Bedtime"
		end
	end

	draw.SimpleText(
		periodName,
		"CustomFontA",
		x + (w/2),
		y + (h/2),
		Color(255, 255, 255),
		TEXT_ALIGN_CENTER
	)
end

local function ClassTimeHud()
	local periodID = GetGlobalInt("ClassPeriod")

	local grade = tonumber(LocalPlayer():GetNWInt("grade"))

	if grade and grade == 8 then return false end

	local W, H = ScrW(), ScrH()
	local cw,ch = 190, 60
	local w,h = 190, 60
	local x,y = W - w - 30, H - h - ch - 30 - 15

	if periodID > 0 then
		draw.SimpleText(
			"F1 to view schedule",
			"CustomFontB",
			x + w / 2 + 5, y - 20,
			Color(255,255,255),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

		draw.RoundedBox(
			3,
			x,y,
			w,h,
			Color(33,33,33,200)
		)

		local curtime = GetGlobalInt("ClassPeriodEnds") - CurTime() 
		local realtimec = curtime / LengthOfDay
		local realtime =  realtimec * SecondsInDay / 60

		local finaltime = curtime

		if realtime > LengthOfPeriodInGame then
			finaltime = curtime - (LengthOfPeriodInGame * CalcMinute)
		end

		local time = math.ceil(finaltime)

		local min = "seconds"

		if time == 1 then
			min = "second"
		elseif time < 0 then
			time = 0
		end

		local eclipsed = curtime / (LengthOfPeriod + PeriodIntermission)

		if eclipsed > 0.02 then
			draw.RoundedBox(
				3,
				x,y,
				w * eclipsed,h,
				Color(44, 62, 80,100)
			)
		end

		draw.SimpleText(
			"Time Remaining",
			"CustomFontB",
			x + (w/2),
			y + 5,
			Color(255, 255, 255),
			TEXT_ALIGN_CENTER
		)

		draw.SimpleText(
			time .. " " .. min,
			"CustomFontA",
			x + (w/2),
			y + (h/2),
			Color(255, 255, 255),
			TEXT_ALIGN_CENTER
		)
	else
		if not IsCurfew() then
			draw.SimpleText(
				"F1 to view schedule",
				"CustomFontB",
				x + w / 2 + 5, y + 50,
				Color(255,255,255),
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)
		end
	end
end

local function ClassRoom2D3D()
	local periodID = GetGlobalInt("ClassPeriod")
	local schedule = databaseGetValue("schedule")
	local room = nil
	local roomName = nil

	local grade = databaseGetValue("grade")

	if grade and grade == "8" then
		room = "SupervisorsOffices"
		roomName = "Counselor's Office"
	elseif periodID > 0 and schedule and schedule[periodID] and CLASSES[schedule[periodID]] then
		room = CLASSES[schedule[periodID]].Room
	end

	if room then
		local p = POINTS['d_' .. room][1]
		
		if roomName then
			room = roomName
		end

		local pos = p:ToScreen()

		local eyeang = LocalPlayer():EyeAngles().y - 90 -- Face upwards
		local SpinAng = Angle( 0, eyeang, 90 )

		local x = 0
		local y = 0
		local padding = 7
		local offset = 0

		local w, h = surface.GetTextSize( room )
		
		x = pos.x - w 
		y = pos.y - h 
		
		x = x - offset
		y = y - offset

		draw.RoundedBox(4,
			x-padding-2,
			y-padding-2 - 20,
			w+padding*2+4,
			h+padding*2+4,
			Color(33,33,33,210)
		)

		draw.SimpleText(
			room,
			"CustomFontA",
			x + w/2,
			y - 20,
			Color(255,255,255),
			TEXT_ALIGN_CENTER
		)
	end
end

dAvatar = nil

local function DrawHud()

	local W, H = ScrW(), ScrH()
	local w,h = 375, 110
	local x,y = 30 + 10, H - h - 30

	if not PvPEnabled then
		draw.RoundedBox(
			0,
			x - 7, y,
			7, h,
			Color(39, 174, 96, 230)
		)
	else
		draw.RoundedBox(
			0,
			x - 7, y,
			7, h,
			Color(192, 57, 43, 230)
		)
	end

	surface.SetDrawColor(240, 240, 240, 230)
	surface.SetMaterial(chalkboard)
	surface.DrawTexturedRect(x, y, w, h)

	draw.RoundedBox(
		5,
		x+15,y+10,
		h-10*2-10,h-10*2-10,
		Color(33,33,33)
	)

	if not dAvatar then
		dAvatar = vgui.Create("AvatarImage")
		dAvatar:SetPos(x + 18, y + 13)
		dAvatar:SetSize(h-13*2-10, h-13*2-10)
		dAvatar:SetPlayer(LocalPlayer(), 84)

		local dEdit = vgui.Create("DButton", dAvatar)
		dEdit:SetPos(dAvatar:GetWide() - 30, dAvatar:GetTall() - 30)
		dEdit:SetSize(24, 24)
		dEdit:SetText("")
		dEdit.Paint = function(s,w,h)
			draw.RoundedBox(
				3,
				0,0,
				w,h,
				Color(33,33,33,230)
			)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(cog)
			surface.DrawTexturedRect(0, 0, w, h)
		end
		dEdit.DoClick = function()
			OpenCharacterCreation()
		end
	end

	draw.SimpleText(
		ClientConfig.RPName(LocalPlayer()),
		"CustomFontA",
		x + h + 5 - 10, y + 10
	)

	draw.SimpleText(
		ClientConfig.Grade(LocalPlayer()),
		"CustomFontD",
		x + h + 5 - 10, y + 35
	)

	local cx, cy = x + h + 5 - 10, y + 65
	local clique = tonumber(LocalPlayer():GetNWInt("clique"))
	local ccolor = ClientConfig.GetCliqueColor(clique)

	if clique > 1 then
		surface.SetDrawColor(ccolor)
		surface.SetMaterial(ClientConfig.CliqueMats[clique])
		surface.DrawTexturedRect(cx, cy-5, 32, 32)

		cx, cy = cx + 40, cy + 12
	end

	draw.SimpleText(
		CLIQUES[clique].Name,
		"CustomFontD",
		cx, cy,
		ccolor,
		TEXT_ALIGN_LEFT,
		TEXT_ALIGN_CENTER
	)

	local health = LocalPlayer():Health()
	local healthLength = (health / 100.0) 
	if healthLength > 1 then
		healthLength = 1
	elseif healthLength < 0 then
		healthLength = 0
	end

	if health > 0 then
		draw.RoundedBox(
			2,
			x,y+h-10,
			w * healthLength,10,
			Color(192, 57, 43, 80)
		)
	end

	if health < 95 and health > 0 then
		draw.SimpleText(
			health .. "%",
			"CustomFontE",
			x + w * healthLength + 5, y+h-10 
		)
	end
end

local function CalcDayTime()
	local curtime = CurTime() - GetGlobalInt("DayTime")
	local realtimec = curtime / LengthOfDay
	CurrentDayTime =  realtimec * SecondsInDay
	CurrentDayHour =  realtimec * SecondsInDay / 3600.0
end

local function DrawInDetention()
	if IsInDetention and IsInDetention > CurTime() then
		local W, H = ScrW(), ScrH()
		local w,h = 350, 50
		local x,y = W / 2 - w / 2, 30

		draw.RoundedBox(
			5,
			x,y,
			w,h,
			Color(192, 57, 43, 50)
		)

		draw.RoundedBox(
			5,
			x+4,y+4,
			w-8,h-8,
			Color(192, 57, 43, 100)
		)

		draw.SimpleText(
			"Detention Ends in " .. math.Round(IsInDetention - CurTime()) .. " seconds.",
			"CustomFontA",
			x + (w/2), y + (h/2),
			Color(255,255,255),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
end

local HUDTriggeredFade = false
local HUDTriggeredFadeDown = false

function HUDTriggerFade()
	HUDTriggeredFade = true
end

function HUDTriggerFadeDown()
	HUDTriggeredFade = true
	HUDTriggeredFadeDown = true
end

local dHudFade = nil

local function HUDFade()
	if HUDTriggeredFade then
		if dHudFade then
			dHudFade:Remove()
		end

		dHudFade = vgui.Create("DPanel")
		dHudFade:SetPos(0, 0)
		dHudFade:SetSize(ScrW(), ScrH())
		dHudFade.Paint = function(s,w,h)
			draw.RoundedBox(
				0,
				0,0,
				w,h,
				Color(0,0,0)
			)
		end
		if HUDTriggeredFadeDown then
			dHudFade:SetAlpha(0)
			dHudFade:AlphaTo(
				255,
				4,
				0,
				function()
					print("removing")
					dHudFade:Remove()
					dHudFade = nil
					HUDTriggeredFade = false
					HUDTriggeredFadeDown = false
				end
			)
		else
			dHudFade:SetAlpha(255)
			dHudFade:AlphaTo(
				0,
				4,
				0,
				function()
					dHudFade:Remove()
					dHudFade = nil
					HUDTriggeredFade = false
					HUDTriggeredFadeDown = false
				end
			)
		end

		HUDTriggeredFadeDown = false
		HUDTriggeredFade = false
	end
end

function EnableHud()
	hudenabled = true
	if dAvatar then
		dAvatar:SetVisible(true)
	end
end

function DisableHud()
	hudenabled = false
	if dAvatar then
		dAvatar:SetVisible(false)
	else
		print ("Davatar not there??")
	end
end

local function hud()
	if hudenabled then
		CalcDayTime()

		DrawHud()
		TimeHud()
		ClassHud()
		ClassTimeHud()
		ClassRoom2D3D()
		DrawInDetention()
	end

	HUDFade()
end

hook.Add("HUDPaint", "MyHudName", hud) -- I'll explain hooks and functions in a second

function hidehud(name)
	for k, v in pairs({"CHudHealth", "CHudBattery", "CHudSecondaryAmmo", "CHudAmmo", "CHudCrosshair"}) do
		if v == name then
			return false
		end
	end
end

hook.Add("HUDShouldDraw", "HideOurHud", hidehud)

-- Move to cl_overhead_names.lua

function GM:HUDDrawTargetID()
end

surface.CreateFont( "player_overhead_name", {
	font 		= "Arial",
	size 		= 28,
	weight 		= 700,
})

surface.CreateFont( "player_overhead_title", {
	font 		= "Arial",
	size 		= 20,
	weight 		= 700,
})

local function OverheadNames()
	for k,v in pairs(player.GetAll()) do
		local dist = v:GetPos():Distance(LocalPlayer():GetPos())

		if v ~= LocalPlayer() and dist <= 400 then
			local alphaStrength = 1 - (dist) / 400
			if alphaStrength < 0 then
				alphaStrength = 0
			end

			local zOffset = 90

			local x = v:GetPos().x
			local y = v:GetPos().y
			local z = v:GetPos().z

			local pos = Vector(x, y, z + zOffset)
			local pos2d = pos:ToScreen()
			pos2d.y = pos2d.y - (dist / 10.0)

			local clique = v:GetNWInt("Clique")
			local cliqueColor = ClientConfig.OverheadGradeColor(v, alphaStrength)

			if clique and ClientConfig.CliqueMats[clique] then
				surface.SetDrawColor(cliqueColor)
				surface.SetMaterial(ClientConfig.CliqueMats[clique])
				surface.DrawTexturedRect(pos2d.x-16, pos2d.y-40, 32, 32)
			end

			draw.DrawText(
				ClientConfig.RPName(v),
				"player_overhead_name",
				pos2d.x, pos2d.y,
				ClientConfig.OverheadNameColor(v, alphaStrength),
				TEXT_ALIGN_CENTER
			)

			local c = Color(39, 174, 96, 255 * alphaStrength)
			
			draw.DrawText(
				ClientConfig.Grade(v),
				"player_overhead_title",
				pos2d.x, pos2d.y + 32,
				ClientConfig.OverheadGradeColor(v, alphaStrength),
				TEXT_ALIGN_CENTER
			)
		end
	end
end

hook.Add("HUDDrawTargetID", "LoopThroughPlayers", OverheadNames)	
