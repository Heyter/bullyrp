
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
	["/" .. GetTString("me")] = function(ply, msg, isTeam)
		msg[1] = ply:GetRPName()
		local s = join(msg)
		print ("(ME) " .. ply:GetName() .. ": " .. s)
		MessageAll({Color(142, 68, 173), s})
		return ""
	end,
	["/" .. GetTString("ooc")] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("OOC") .. ") " .. ply:GetName() .. ": " .. s)
		MessageAll({
			Color(56, 163, 234), "(" .. GetTString("OOC") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		})
		return ""
	end,
	["//"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("OOC") .. ") " .. ply:GetName() .. ": " .. s)
		MessageAll({
			Color(56, 163, 234), "(" .. GetTString("OOC") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		})
		return ""
	end,
	["/" .. GetTString("looc")] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("LOOC") .. ") " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(39, 174, 96), "(" .. GetTString("OOC") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	[".//"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("OOC") .. ") " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(39, 174, 96), "(" .. GetTString("OOC") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), join(msg)
		}, plys)
		return ""
	end,
	["/w"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("Whisper") .. ") " .. ply:GetName() .. ": " .. s)
		
		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(22, 160, 133), "(" .. GetTString("Whisper") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/".. GetTString("whisper")] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("Whisper") .. ") " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(22, 160, 133), "(" .. GetTString("Whisper") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/y"] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("Yell") .. ") " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 1000)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(231, 76, 60), "(" .. GetTString("Yell") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/" .. GetTString("yell")] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("Yell") .. ") " .. ply:GetName() .. ": " .. s)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 1000)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(231, 76, 60), "(" .. GetTString("Yell") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		}, plys)
		return ""
	end,
	["/" .. GetTString("ad")] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("Advert") .. ") " .. ply:GetName() .. ": " .. s)

		MessageAll({
			Color(231, 76, 60), "(" .. GetTString("Advert") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		})
		return ""
	end,
	["/" .. GetTString("advert")] = function(ply, msg, isTeam)
		msg[1] = nil
		local s = join(msg)
		print ("(" .. GetTString("Advert") .. ") " .. ply:GetName() .. ": " .. s)

		MessageAll({
			Color(231, 76, 60), "(" .. GetTString("Advert") .. ") ",
			GetCliqueColor(ply:GetClique()),
			ply:GetRPName() .. ": ",
			Color(255,255,255), s
		})
		return ""
	end,
	["/" .. GetTString("roll")] = function(ply, msg, isTeam)
		local die = msg[2] or 10

		print ("(" .. GetTString("Roll") .. ") " .. ply:GetName())

		MessageAll({
			Color(39, 174, 96), ply:GetRPName() .. " " .. GetTString("Roll") .. " a " .. math.random(1,die)
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
	else
		print ("(" .. GetTString("Local") .. ") " .. ply:GetName() .. ": " .. text)

		local plys = {}

		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 1000)) do
			if v:IsPlayer() then
				table.insert(plys, v)
			end
		end

		MessageAll({
			Color(255,255,255),
			"(" .. GetTString("Local") .. ") " .. ply:GetRPName() .. ": " .. text,
		}, plys)
		return ""
	end
end)

hook.Add("OnPlayerChat", "range", function(player, player, strText, bTeamOnly, bPlayerIsDead)

end)

hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range", function( listener, talker )
	if listener:GetPos():Distance( talker:GetPos() ) > 1000 then return false end
end )

function GM:PlayerCanSeePlayersChat(t, o, listener, speaker)
	return (listener:GetPos():Distance(speaker:GetPos())) < 1000
end
