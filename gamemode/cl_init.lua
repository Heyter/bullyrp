
include("shared.lua")
include("shared/sh_cliques.lua")
include("shared/util.lua")
include("shared/sh_points.lua")
include("shared/sh_classes.lua")
include("shared/sh_atmos.lua")
include("shared/sh_questing.lua")

include("client/cl_config.lua")
include("client/cl_database.lua")
include("client/cl_fonts.lua")
include("client/cl_hud.lua")
include("client/cl_atmos.lua")
include("client/cl_scoreboard.lua")
include("client/cl_f4menu.lua")
include("client/cl_character_creation.lua")
include("client/cl_notifications.lua")
include("client/cl_minimap.lua")
include("client/cl_quests.lua")
include("client/cl_intro.lua")
include("client/cl_q_menu.lua")

local poses = {}

concommand.Add("p", function(ply, cmd, args)
	print ("\n")
	for k,v in pairs(poses) do
		print ("[\"g_" .. args[1] .. k .. "\"] = " .. v)
	end
	print ("\n")
end)

concommand.Add("pz", function(ply)
	poses = {}
end)

concommand.Add("ps", function(ply)
	local p = ply:GetPos()
	local a = ply:GetAngles()

	table.insert(poses, "{Vector(" .. math.Round(p.x, 3) .. ", " .. math.Round(p.y, 3) .. ", " .. math.Round(p.z, 3) .. "), Angle(" .. math.Round(a.pitch, 3) .. ", " .. math.Round(a.yaw, 3) .. ", 0.0)},")
end)

concommand.Add("pos", function(ply)
	local p = ply:GetPos()
	local a = ply:GetAngles()

	print ("{Vector(" .. math.Round(p.x, 3) .. ", " .. math.Round(p.y, 3) .. ", " .. math.Round(p.z, 3) .. "), Angle(" .. math.Round(a.pitch, 3) .. ", " .. math.Round(a.yaw, 3) .. ", 0.0)},")
end)

local IsMouseOn = false

local function EnableMouse( ply, bind, pressed )
    if ( bind == "gm_showspare1" ) then 
    	IsMouseOn = !IsMouseOn
		gui.EnableScreenClicker(IsMouseOn)
	end
end

hook.Add("PlayerBindPress", "EnableMouse", EnableMouse)

function GM:PostDrawViewModel( vm, ply, weapon )
	if ( weapon.UseHands || !weapon:IsScripted() ) then
		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
	end
end

function GM:ShouldCollide(ent1, ent2)
	if ( IsValid( ent1 ) and IsValid( ent2 ) and ent1:IsPlayer() and ent2:IsPlayer() ) then return false end

	if ( IsValid( ent1 ) and IsValid( ent2 ) and (ent1:GetClass() == "srp_quest_item" or ent2:GetClass() == "srp_quest_item")) then return false end

	-- We must call this because anything else should return true.
	return true
end

function NoSuicide( ply )
	ply:PrintMessage( HUD_PRINTTALK, "Suicide has been disabled, contact an online admin for support if needed.")
	return false
end

hook.Add( "CanPlayerSuicide", "Suicide", NoSuicide )
