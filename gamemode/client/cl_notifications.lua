
IsInDetention = false

local dNotes = nil

local DNotesFont = surface.CreateFont("DNotesFont", {
	font = "Arial",
	size = 26,
	weight = 500
})

local function AddNote(mtype, message, delay)
	if not delay then
		delay = 6
	end

	local c = Color(33, 33, 33, 150)

	if mtype == 2 then
		c = Color(39, 174, 96, 150)
	elseif mtype == 3 then
		c = Color(192, 57, 43, 150)
	end

	local DLabel = vgui.Create("DLabel")
	DLabel:SetFont("DNotesFont")
	DLabel:SetText("  " .. message)
	DLabel:SetPos(0, 0)
	DLabel:SizeToContents()
	DLabel:SetTall(DLabel:GetTall() + 25)
	DLabel.Paint = function(s,w,h)
		draw.RoundedBox(
			5,
			0,2,
			w,h-4,
			c
		)
		draw.RoundedBox(
			5,
			4,6,
			w-4,h-8,
			c
		)
	end
	DLabel:SetAlpha(0)
	DLabel:AlphaTo(
		255,
		1
	)
	DLabel:AlphaTo(
		0,
		3,
		delay,
		function()
			DLabel:Remove()
		end
	)
	dNotes:Add(DLabel)
end

local function DrawDNotes()
	if not dNotes then
		local W, H = ScrW(), ScrH()
		local w, h = 400, 150
		local x, y = W - w - 30, 30

		dNotes = vgui.Create("DListLayout")
		dNotes:SetPos(x, y)
		dNotes:SetSize(w, h)
	end
end

DrawDNotes()

local function notificationReceive(tab)
	for k,v in pairs(tab) do
		if k == "detention" then
			HUDTriggerFade()
			AddNote(3, "You received detention!")

			if v > CurTime() then
				IsInDetention = v
			end
		elseif k == "openschedule" then
			OpenSchedule(nil, "gm_showhelp")
		elseif k == "watchIntro" then
			PromptCutScene(1)
		elseif k == "specialchatmsg" then
			chat.AddText(unpack(v))
		elseif k == "QuestAbort" then
			RemoveQuestInfo()
			IsDoingQuest = false
			AddNote(3, "The mission was aborted!")
		elseif k == "QuestSuccess" then
			RemoveQuestInfo()
			IsDoingQuest = false
			AddNote(2, "You completed the mission!")
		elseif k == "QuestAcceptFailed" then
			RemoveQuestInfo()
			IsDoingQuest = false
			AddNote(3, "You failed the mission!")
		elseif k == "GenericSuccess" then
			AddNote(2, v)
		elseif k == "GenericFailure" then
			AddNote(3, v)
		elseif k == "GenericNotice" then
			AddNote(1, v)
		elseif k == "pvpenabled" then
			if v then
				AddNote(2, "PvP has been enabled!")
			else
				AddNote(2, "PvP has been disabled!")
			end
			PvPEnabled = v
		elseif k == "playcutscene" then
			RollCutscene()
		end
	end
end

net.Receive("notification", function(len)
	print("Got notification")
	local tab = net.ReadTable()
	notificationReceive(tab)
	PrintTable(tab)
end)
