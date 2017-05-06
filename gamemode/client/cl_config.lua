
local WHITE = Color(255,255,255)
local GREY1 = Color(50,50,50, 150)
local GREY2 = Color(33,33,33, 150)

ClientConfig = {
	DeveloperMat = Material("icon16/application_osx_terminal.png"),
	SuperadminMat = Material("icon16/color_wheel.png"),
	AdminMat = Material("icon16/shield.png"),
	VipMat = Material("materials/assets/won.png"),
	RegularMat = Material("icon16/user.png"),

	-- Backgrounds
	ScoreboardBackground = Material("materials/assets/vgui/scoreboard/chalkboard.png"),
	ScoreboardHeaderTopBackground = GREY1,
	ScoreboardHeaderBottomBackground = GREY2,

	-- Text colors
	ScoreboardSteamNameColor = function(ply)
		return WHITE
	end,
	ScoreboardRPNameColor = function(ply)
		return WHITE
	end,
	ScoreboardGradeColor = function(ply)
		return WHITE
	end,
	ScoreboardRankColor = function(ply)
		return WHITE
	end,
	ScoreboardRankMatColor = function(ply)
		return WHITE
	end,
	ScoreboardPingColor = function(ply)
		return WHITE
	end,
	ScoreboardHeaderTopColor = function(g)
		return WHITE
	end,
	ScoreboardHeaderNameColor = function(g)
		return WHITE
	end,
	ScoreboardHeaderNameColor = function(g)
		return WHITE
	end,
	ScoreboardHeaderGradeColor = function(g)
		return WHITE
	end,
	ScoreboardHeaderRankColor = function(g)
		return WHITE
	end,
	ScoreboardHeaderPingColor = function(g)
		return WHITE
	end,
	ScoreboardHeaderMuteColor = function(g)
		return WHITE
	end,

	-- Names
	SteamName = function(ply)
		return ply:GetName()
	end,
	RPName = function(ply)
		local firstName = "Barack"
		local lastName = "Obama"

		if ply:GetNWString("firstName") ~= "" then
			firstName = ply:GetNWString("firstName")
		end

		if ply:GetNWString("lastName") ~= "" then
			lastName = ply:GetNWString("lastName")
		end

		return firstName .. " " .. lastName
	end,
	Grade = function(ply)
		return ply:GetNWString("Grade") .. "th Grader"
	end,
	Rank = function(ply)
		local status = "Player"

		if ply.SteamID64 and ply:SteamID64() == "76561198079126590" then
			status = "Developer"
		elseif ply:IsSuperAdmin() then
			status = "Owner"
		elseif ply:IsAdmin() then
			status = "Admin"
		elseif ply.VIP then
			status = "VIP"
		end

		return status
	end,
	RankMat = function(ply)
		local icon = ClientConfig.RegularMat
		
		if ply.SteamID64 and ply:SteamID64() == "76561198079126590" then
			icon = ClientConfig.DeveloperMat
		elseif ply:IsSuperAdmin() then
			icon = ClientConfig.SuperadminMat
		elseif ply:IsAdmin() then
			icon = ClientConfig.AdminMat
		elseif ply.VIP then
			icon = ClientConfig.VipMat
		end

		return icon
	end,
}

surface.CreateFont( "ScoreBoardTitle", {
	font = "Arial",
	size = 32
})

surface.CreateFont( "ScoreBoardPlayerNames", {
	font = "Arial",
	size = 24
})

surface.CreateFont( "ScoreBoardPlayerSub", {
	font = "Arial",
	size = 18
})
