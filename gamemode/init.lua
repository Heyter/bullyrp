
util.AddNetworkString("notification")
util.AddNetworkString("quest_request")
util.AddNetworkString("quest_accept")
util.AddNetworkString("quest_abort")
util.AddNetworkString("quest_feedback")
util.AddNetworkString("update_character")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("shared/sh_strings.lua")
AddCSLuaFile("shared/util.lua")
AddCSLuaFile("shared/sh_cliques.lua")
AddCSLuaFile("shared/sh_points.lua")
AddCSLuaFile("shared/sh_atmos.lua")
AddCSLuaFile("shared/sh_classes.lua")
AddCSLuaFile("shared/sh_questing.lua")

AddCSLuaFile("client/cl_config.lua")
AddCSLuaFile("client/cl_database.lua")
AddCSLuaFile("client/cl_fonts.lua")
AddCSLuaFile("client/cl_hud.lua")
AddCSLuaFile("client/cl_atmos.lua")
AddCSLuaFile("client/cl_scoreboard.lua")
AddCSLuaFile("client/cl_f4menu.lua")
AddCSLuaFile("client/cl_character_creation.lua")
AddCSLuaFile("client/cl_notifications.lua")
AddCSLuaFile("client/cl_minimap.lua")
AddCSLuaFile("client/cl_quests.lua")
AddCSLuaFile("client/cl_intro.lua")
AddCSLuaFile("client/cl_q_menu.lua")

resource.AddWorkshop( "920348014" )

include("shared.lua")

include("shared/sh_strings.lua")
include("shared/util.lua")
include("shared/sh_cliques.lua")
include("shared/sh_points.lua")
include("shared/sh_atmos.lua")
include("shared/sh_classes.lua")
include("shared/sh_questing.lua")

include("server/sv_database.lua")
include("server/sv_player.lua")
include("server/sv_questing.lua")
include("server/sv_classes.lua")
include("server/sv_atmos.lua")
include("server/sv_console_commands.lua")
include("server/sv_chat_commands.lua")

CurrentDayTime = -1
CurrentDayHour = -1

local function CalcDayTime()
	local curtime = CurTime() - GetGlobalInt("DayTime")
	local realtimec = curtime / LengthOfDay
	CurrentDayTime =  realtimec * SecondsInDay
	CurrentDayHour =  realtimec * SecondsInDay / 3600.0
end

function GM:PlayerConnect(name, ip)
	print("Player: " .. name .. " has joined.")
end

function GM:PlayerAuthed(player, steamID, uniqueID)
	player:dbCheck()
	print("Player: " .. player:Nick() .. " has authed.")
end

function GM:PlayerInitialSpawn(player)
	player:SetModel("models/player/Group01/male_02.mdl")
	player:AllowFlashlight(true)
	player:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	player:SetCustomCollisionCheck( true )

	local p = POINTS[DORM_POINTS[1][math.random(#DORM_POINTS[1])]]
	player:SetPos(p[1])
	player:SetAngles(p[2])

	if not player:dbGetValue("watchedIntro") or player:dbGetValue("watchedIntro") == "0" then
		print ("-------->> You need to watch intro! :)")
		net.Start("notification")
			net.WriteTable({
				["watchIntro"] = 1
			})
		net.Send(player)

		timer.Simple(1,
			function()
				player:SetPos(Vector(-10.647, -982.497, 100.031))
				player:SetAngles(Angle(-10.198, 90.044, 0.0))
				player.watchedIntro = CurTime()
			end
		)
	end

	print("Player: " .. player:Nick() .. " has spawned.")
end

function GM:PlayerDisconnected(player)
	ProcessQuestAbort(player)
end

function GM:PlayerSpawn(player)
	player:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	player:SetCustomCollisionCheck( true )
	local p = POINTS[DORM_POINTS[1][math.random(#DORM_POINTS[1])]]
	player:SetPos(p[1])
	player:SetAngles(p[2])

	player:AddHands()

	if player.pvpenabled then
		player:Give("weapon_fists")
	end
end

-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GM:ShouldCollide(ent1, ent2)
	if ( IsValid( ent1 ) and IsValid( ent2 ) and ent1:IsPlayer() and ent2:IsPlayer() ) then return false end

	-- We must call this because anything else should return true.
	return true
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if attacker and IsValid(attacker) and attacker:IsPlayer() then
		return ply.pvpenabled and attacker.pvpenabled
	end
	return false
end

function GM:Think()
	AtmosGlobal:Think()
	CalcDayTime()
end

-- If ya refresh, you need to fix things that may break.
if #player.GetAll() > 0 then
	for k,v in pairs(player.GetAll()) do
		v:dbCheck()
		v.inDetention = false
		v.HasQuest = false
		v.IsTeacher = false
		v.pvpenabled = false
		v:SetNWBool("pvpenabled", false)

		if not v:dbGetValue("watchedIntro") or v:dbGetValue("watchedIntro") == "0" then
			print ("-------->> You need to watch intro! :)")
			net.Start("notification")
				net.WriteTable({
					["watchIntro"] = 1
				})
			net.Send(v)
			v:SetPos(Vector(-10.647, -982.497, 100.031))
			v:SetAngles(Angle(-10.198, 90.044, 0.0))
			v.watchedIntro = CurTime()
		end
	end
end

local keepDoorsShut = {
	[1581] = true,
	[1582] = true,
}

timer.Simple(55,
	function()
		-- Remove a random table that blocks NPCs in lunch room.
		if ents.GetMapCreatedEntity(2246) then
			ents.GetMapCreatedEntity(2246):Remove()
		end

		for k,v in pairs(ents.GetAll()) do
			if v:GetClass() == "prop_door_rotating" then
				v:SetSaveValue("m_bLocked", false)
				if keepDoorsShut[v:MapCreationID()] then
					v:Fire("Close")
				else
					v:Fire("Open")
				end
			end
		end
	end)

timer.Simple(
	60,
	function()
		for k,v in pairs(ents.GetAll()) do
			if v:GetClass() == "prop_door_rotating" then
				v:SetSaveValue("m_bLocked", true)
			end
		end
	end)
