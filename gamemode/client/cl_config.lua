
LANGUAGES = {
	[1] = "English"	
}

LANGUAGE = 1



ClientConfig = {
	DeveloperMat = Material("icon16/application_osx_terminal.png"),
	SuperadminMat = Material("icon16/color_wheel.png"),
	AdminMat = Material("icon16/shield.png"),
	VipMat = Material("materials/assets/won.png"),
	RegularMat = Material("icon16/user.png"),

	F4URL = "http://steamcommunity.com/groups/bullyrp",

	CliqueMats = {
		-- Nerds
		[2] = Material("materials/assets/bullyrp/icons/spectacles.png"),
		-- Bullies
		[3] = Material("materials/assets/bullyrp/icons/muscle-up.png"),
		-- Preppies
		[4] = Material("materials/assets/bullyrp/icons/take-my-money.png"),
		-- Burnouts
		[5] = Material("materials/assets/bullyrp/icons/cigar.png"),
		-- Jocks
		[6] = Material("materials/assets/bullyrp/icons/american-football-helmet.png"),
		-- Clique Leader
		Leader = Material("materials/assets/bullyrp/icons/stars-stack.png"),
	},

	-- Backgrounds
	ScoreboardBackground = Material("materials/assets/bullyrp/vgui/scoreboard/chalkboard.png"),
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

	OverheadNameColor = function(ply, alpha)
		return Color(WHITE.r, WHITE.g, WHITE.b, 255 * alpha)
	end,
	OverheadGradeColor = function(ply, alpha)
		-- This may be an "srp_student" or player
		local clique = ply:GetNWInt("clique")
		local c = WHITE

		if clique and CLIQUES[clique] then
			clique = CLIQUES[clique]
			if CliqueColorMap[clique.Name] then
				c = CliqueColorMap[clique.Name]
			end
		end

		return Color(c.r, c.g, c.b, 255 * alpha)
	end,
	GetCliqueColor = function(clique)
		-- This method has become obsolete by this
		-- shared method lol.
		return GetCliqueColor(clique)
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
		local grade = ""

		if ply:GetNWString("teacher") and ply:GetNWString("teacher") ~= "" then
			grade = ply:GetNWString("Teacher")
		elseif ply:GetNWInt("grade") then
			grade = ply:GetNWInt("grade") .. "th Grader"
		end

		return grade
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
