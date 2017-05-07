
function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function join(inputstr, sep)
	if sep == nil then
		sep = " "
	end

	local s = ""

	if #inputstr > 0 then
		s = table.remove(inputstr, 1) or ""
	end

	if #inputstr > 0 then
		for k, v in ipairs(inputstr) do
			if v then
				s = s .. sep .. v
			end
		end
	end

	return s
end

local function MessageAll(msg, playerList)
	net.Start("notification")
		net.WriteTable({
			["specialchatmsg"] = msg
		})
	if playerList then
		net.Send(playerList)
	else
		net.Broadcast()
	end
end

ChatCommands = {
	["/me"] = function(ply, msg, isTeam)
		msg[1] = ply:GetRPName()
		local s = join(msg)
		print ("(ME) " .. ply:GetName() .. ": " .. s)
		MessageAll({Color(142, 68, 173), s})
		return ""
	end,
	["/ooc"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(OOC) " .. ply:GetName() .. ": " .. s)
		MessageAll({
			Color(56, 163, 234), "(OOC) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), s
		})
		return ""
	end,
	["//"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(OOC) " .. ply:GetName() .. ": " .. s)
		MessageAll({
			Color(56, 163, 234), "(OOC) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), s
		})
		return ""
	end,
	["/looc"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(LOOC) " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(39, 174, 96), "(LOOC) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	[".//"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(LOOC) " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(39, 174, 96), "(LOOC) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), join(msg)
		}, plys)
		return ""
	end,
	["/w"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(Whisper) " .. ply:GetName() .. ": " .. s)
		
		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(22, 160, 133), "(Whisper) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/whisper"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(Whisper) " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(22, 160, 133), "(Whisper) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/y"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(Yell) " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 1000)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(231, 76, 60), "(Yell) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/yell"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(Yell) " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 1000)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(231, 76, 60), "(Yell) " .. ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/roll"] = function(ply, msg, isTeam)
		local die = msg[2] or 10

		print ("(Roll) " .. ply:GetName())

		MessageAll({
			Color(39, 174, 96), ply:GetRPName() .. " rolled a " .. math.random(1,die)
		})
		return ""
	end,
	["/pvp"] = function(ply, msg, isTeam)
		timer.Remove("pvpenabled_" .. ply:SteamID64())

		if ply.pvpenabled then
			timer.Create(
				"pvpenabled_" .. ply:SteamID64(),
				10,
				1,
				function()
					ply.pvpenabled = false
					net.Start("notification")
						net.WriteTable({
							["pvpenabled"] = false
						})
					net.Send(ply)
					ply:SetNWBool("pvpenabled", false)
				end
			)
			net.Start("notification")
				net.WriteTable({
					["GenericNotice"] = "PvP will be disabled in 10 seconds..."
				})
			net.Send(ply)
			ply:StripWeapons()
		else
			ply.pvpenabled = true
			net.Start("notification")
				net.WriteTable({
					["pvpenabled"] = true
				})
			net.Send(ply)
			ply:SetNWBool("pvpenabled", true)
			ply:Give("weapon_fists")
		end
		return ""
	end,
	["!pvp"] = function(ply, msg, isTeam)
		timer.Remove("pvpenabled_" .. ply:SteamID64())

		if ply.pvpenabled then
			timer.Create(
				"pvpenabled_" .. ply:SteamID64(),
				10,
				1,
				function()
					ply.pvpenabled = false
					net.Start("notification")
						net.WriteTable({
							["pvpenabled"] = false
						})
					net.Send(ply)
					ply:SetNWBool("pvpenabled", false)
				end
			)
			net.Start("notification")
				net.WriteTable({
					["GenericNotice"] = "PvP will be disabled in 10 seconds..."
				})
			net.Send(ply)
			ply:StripWeapons()
		else
			ply.pvpenabled = true
			net.Start("notification")
				net.WriteTable({
					["pvpenabled"] = true
				})
			net.Send(ply)
			ply:SetNWBool("pvpenabled", true)
			ply:Give("weapon_fists")
		end
		return ""
	end,
	["!intro"] = function(ply, msg, isTeam)
		print (ply:GetName() .. " played the intro.")
		if not ply.inDetention then
			ply:SetPos(Vector(-10.647, -982.497, 100.031))
			ply:SetAngles(Angle(-10.198, 90.044, 0.0))
		end

		net.Start("notification")
			net.WriteTable({
				["playcutscene"] = 1
			})
		net.Send(ply)
		return ""
	end,
}

-- Custom Chat commands
hook.Add("PlayerSay", "textCommands", function(ply, text, isTeam)
	local s = split(text, sep)

	if s[1] and ChatCommands[s[1]] then
		local x = ChatCommands[s[1]](ply, s, isTeam)
		if x then
			return x
		end
	end
end)

local function ScheduleChatCommand( ply, text, public )
    if (string.starts(text, "!sch")) then
		net.Start("notification")
			net.WriteTable({
				["openschedule"] = true
			})
		net.Send(ply)
		return (false)
    end
end

hook.Add( "PlayerSay", "schedule", ScheduleChatCommand)

local function CharacterCreationChatCommand( ply, text, public )
    if (string.starts(text, "!name")) then
		net.Start("notification")
			net.WriteTable({
				["opencharactercreation"] = true
			})
		net.Send(ply)
		return (false)
    end
end

hook.Add( "PlayerSay", "characterCreation", CharacterCreationChatCommand)

hook.Add("OnPlayerChat", "range", function(player, player, strText, bTeamOnly, bPlayerIsDead)

end)

hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range", function( listener, talker )
	if listener:GetPos():Distance( talker:GetPos() ) > 1000 then return false end
end )

function GM:PlayerCanSeePlayersChat(t, o, listener, speaker)
	return (listener:GetPos():Distance(speaker:GetPos())) < 1000
end
