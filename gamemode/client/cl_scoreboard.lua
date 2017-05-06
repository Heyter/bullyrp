
local scoreboard = nil

local movingOut = false
local movingIn = false
local movedIn = true
local movedOut = false

function GM:ScoreboardShow()
	if IsValid(ScoreBoardMain) then
		if not movingOut and not movingIn then
			if movedIn then
				movingOut = true
				
				ScoreBoardMain:Update()
				ScoreBoardMain:SetVisible(true)
				ScoreBoardMain:SetAlpha(0)
				ScoreBoardMain:AlphaTo(255, 0.5, 0, function()
					movingOut = false
					movedOut = true
					movedIn = false
				end)
			else
				movingIn = true
				ScoreBoardMain:AlphaTo(0, 0.5, 0, function()
					movingIn = false
					movedOut = false
					movedIn = true
					ScoreBoardMain:SetVisible(false)
				end)
			end
		end
	else
		CreateScoreboard()
	end 
end

function GM:ScoreboardHide()
	if (ScoreBoardMain) then
		if not movingOut and not movingIn and movedOut then
			movingIn = true
			ScoreBoardMain:AlphaTo(0, 0.5, 0, function()
				movingIn = false
				movedIn = true
				movedOut = false
				ScoreBoardMain:SetVisible(false)
			end)
		end
	end
end

local function AddPanelToBoard(scrollpanel, index, v)
	local w,h = scrollpanel:GetWide() - 16, 75
	local padding = 2

	local panel = scrollpanel:Add("DPanel")
	panel:SetSize(w, h)
	panel:SetPos(0, index * (h + padding) - (h + padding) + padding*2)

	local avatar = panel:Add("AvatarImage")
	avatar:SetSize(54, 54)
	avatar:SetPos(5, 5)
	avatar:SetPlayer(v)
	
	local SteamProfile = vgui.Create( "DButton",avatar )
	SteamProfile:SetSize( avatar:GetWide(), avatar:GetTall() ) 
	SteamProfile:SetText(" ")

	function SteamProfile:Paint(w,h)
	end

	if v:SteamID64() then
		function SteamProfile:DoClick()
			gui.OpenURL( "https://steamcommunity.com/profiles/"..v:SteamID64() )
		end
	end
	
	if v != LocalPlayer() then
		local MuteButton = panel:Add( "DImageButton" )
		MuteButton:SetSize(32,32)
		MuteButton:SetPos(w - 50, h / 2 / 2) 
		MuteButton:SetText(" ")
		function MuteButton:Paint(w,h)
		end
		if v:IsMuted() then
			MuteButton:SetImage("icon32/muted.png")
		else
			MuteButton:SetImage("icon32/unmuted.png")
		end
		function MuteButton:DoClick()
			v:SetMuted(!v:IsMuted())
			
			if v:IsMuted() then
				MuteButton:SetImage("icon32/muted.png")
			else
				MuteButton:SetImage("icon32/unmuted.png")
			end
		end
	end

	panel.Paint = function(self, w, h)
		if not v:IsValid() then
			ScoreBoardMain:Update()
			return
		end

		draw.SimpleText(
			ClientConfig.SteamName(v),
			"ScoreBoardPlayerNames",
			90,
			10,
			ClientConfig.ScoreboardSteamNameColor(v),
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP
		)
		draw.SimpleText(
			ClientConfig.RPName(v),
			"ScoreBoardPlayerSub",
			90,
			h-15,
			ClientConfig.ScoreboardRPNameColor(v),
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_BOTTOM
		)

		draw.SimpleText(
			ClientConfig.Grade(v),
			"ScoreBoardPlayerSub",
			w - 275,
			h / 2,
			ClientConfig.ScoreboardGradeColor(v),
			TEXT_ALIGN_RIGHT,
			TEXT_ALIGN_CENTER
		)

		draw.SimpleText(
			ClientConfig.Rank(v),
			"ScoreBoardPlayerSub",
			w - 205,
			h / 2,
			ClientConfig.ScoreboardRankColor(v),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

		surface.SetDrawColor(ClientConfig.ScoreboardRankMatColor(v))
		surface.SetMaterial(ClientConfig.RankMat(v))
		surface.DrawTexturedRect(
			w - 130,
			h / 2 - 8, 16, 16
		)

		draw.SimpleText(
			v:Ping(),
			"ScoreBoardPlayerSub",
			w - 80,
			h / 2,
			ClientConfig.ScoreboardPingColor(v),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)

	end
end

function CreateScoreboard()
	local W,H = ScrW(), ScrH()
	local w,h = W * 0.75, H * 0.75
	local x,y = W * 0.25 / 2, H * 0.25 / 2
	local topHeight = 50

	ScoreBoardMain = vgui.Create("DFrame")
	ScoreBoardMain:SetPos(x, y)
	ScoreBoardMain:SetSize(w,h)
	ScoreBoardMain:SetTitle("")
	ScoreBoardMain:SetDraggable(false)
	ScoreBoardMain:MakePopup()
	ScoreBoardMain:ShowCloseButton(false)
	ScoreBoardMain:SetKeyboardInputEnabled(false)

	ScoreBoardMain.Paint = function(s,w,h)
		draw.RoundedBox(
			5,
			0,0,
			w,h,
			Color(33,33,33,250)
		)

		surface.SetDrawColor(255,255,255,200)
		surface.SetMaterial(ClientConfig.ScoreboardBackground)
		surface.DrawTexturedRect(5, 5, w-10, h-10)

		draw.SimpleText(
			GetHostName(),
			"ScoreBoardTitle",
			w/2, topHeight/2 + 5,
			Color(255,255,255),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end

	local scrollpanel = ScoreBoardMain:Add("DScrollPanel")
	scrollpanel:SetPos(20, topHeight+10)
	scrollpanel:SetSize(ScoreBoardMain:GetWide()-40, ScoreBoardMain:GetTall()-topHeight-35)

	scrollpanel.Paint = function(s,w,h)
		draw.RoundedBox(
			4,
			0,0,
			w,h,
			Color(0,0,0,220)
		)
	end
	scrollpanel.VBar.Paint = function() end
	
	ScoreBoardMain.Update = function()
		scrollpanel:Clear()

		local playersingrades = {}

		local top = -1
		local bottom = 9999

		for k,v in pairs(player.GetAll()) do
			local g = tonumber(v:GetNWInt("Grade"))

			if playersingrades[g] then
				table.insert(playersingrades[g], v)
			else
				playersingrades[g] = {v}
			end

			if g > top then
				top = g
			end
			if g < bottom then
				bottom = g
			end
		end

		local sortedPlayers = player.GetAll()

		table.sort(sortedPlayers, function(a, b) return a:GetName() < b:GetName() end)

		local index = 1

		for i=top,bottom,-1 do
			local players = playersingrades[i]

			if players then
				local w,h = scrollpanel:GetWide(), 75
				local padding = 2

				local panel = scrollpanel:Add("DPanel")
				panel:SetSize(w, h)
				panel:SetPos(0, index * (h + padding) - (h + padding))
				panel.Paint = function(s,w,h)
					draw.RoundedBox(
						4,
						0,0,
						w,41,
						ClientConfig.ScoreboardHeaderTopBackground
					)
					draw.RoundedBox(
						4,
						0,h-35,
						w,35,
						ClientConfig.ScoreboardHeaderBottomBackground
					)
					draw.SimpleText(
						i .. "th Graders",
						"ScoreBoardPlayerNames",
						w/2,
						10,
						ClientConfig.ScoreboardHeaderTopColor(i),
						TEXT_ALIGN_CENTER,
						TEXT_ALIGN_TOP
					)
					draw.SimpleText(
						"Name",
						"ScoreBoardPlayerSub",
						90,
						h-10,
						ClientConfig.ScoreboardHeaderTopColor(i),
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_BOTTOM
					)
					draw.SimpleText(
						"Grade",
						"ScoreBoardPlayerSub",
						w - 275 - 16,
						h-10,
						ClientConfig.ScoreboardHeaderGradeColor(i),
						TEXT_ALIGN_RIGHT,
						TEXT_ALIGN_BOTTOM
					)
					draw.SimpleText(
						"Rank",
						"ScoreBoardPlayerSub",
						w - 205 - 16,
						h-10,
						ClientConfig.ScoreboardHeaderRankColor(i),
						TEXT_ALIGN_CENTER,
						TEXT_ALIGN_BOTTOM
					)

					draw.SimpleText(
						"Ping",
						"ScoreBoardPlayerSub",
						w - 80 - 16,
						h-10,
						ClientConfig.ScoreboardHeaderPingColor(i),
						TEXT_ALIGN_CENTER,
						TEXT_ALIGN_BOTTOM
					)
					draw.SimpleText(
						"Mute",
						"ScoreBoardPlayerSub",
						w - 32 - 16,
						h-10,
						ClientConfig.ScoreboardHeaderMuteColor(i),
						TEXT_ALIGN_CENTER,
						TEXT_ALIGN_BOTTOM
					)
				end
				index = index + 1

				for k,v in pairs(players) do
					AddPanelToBoard(scrollpanel, index, v)
					index = index + 1
				end
			end
		end	
	end
	
	ScoreBoardMain:Update()

	movingOut = true
				
	ScoreBoardMain:Update()
	ScoreBoardMain:SetVisible(true)
	ScoreBoardMain:SetPos(x, y)
	ScoreBoardMain:SetAlpha(0)
	ScoreBoardMain:AlphaTo(255, 0.5, 0, function()
		movingOut = false
		movedOut = true
		movedIn = false
	end)
end
