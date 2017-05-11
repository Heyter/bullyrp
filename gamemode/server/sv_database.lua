
local player = FindMetaTable("Player")

util.AddNetworkString("database")

local defaultValues = {
	["money"] = 100,
	["grade"] = 8,
	["firstName"] = "",
	["lastName"] = "",
	["model"] = "models/player/Group01/male_02.mdl",
	["schedule"] = GenerateSchedule(9),
	["watchedIntro"] = 0,
	["language"] = 1,

	["clique"] = 1,

	["cliques1"] = 10,
	["cliques2"] = 10,
	["cliques3"] = 10,
	["cliques4"] = 10,
	["cliques5"] = 10,
	["cliques6"] = 10,
}

local tables = {
	["schedule"] = true,
}

local nws = {
	['firstName'] = 1,
	['lastName'] = 1,
	['grade'] = 2,
	["clique"] = 2,
}

function player:dbNW(name, v)
	if not v then
		v = self:dbGetValue(name)
	end

	if nws[name] == 1 then
		self:SetNWString(name, v)
	elseif nws[name] == 2 then
		self:SetNWInt(name, v)
	else
		print ("Found none. Type: " .. type(v))
	end
end

function player:dbDefault(override)
	for k,v in pairs(defaultValues) do
		if override or self:dbGetValue(k) == nil then
			if k == "firstName" then
				self:dbSetValue(k, MALE_NAMES[math.random(#MALE_NAMES)])
			elseif k == "lastName" then
				self:dbSetValue(k, TEACHER_NAMES[math.random(#TEACHER_NAMES)])
			else
				self:dbSetValue(k, v)
			end
		end
	end
end

function player:dbCheck()
	self:dbDefault()
	self:dbSendAll()

	for k,v in pairs(nws) do
		self:dbNW(k, self:dbGetValue(k))
	end
end

function player:dbSendAll()
	endtab = {}

	for k,v in pairs(defaultValues) do
		endtab[k] = self:dbGetValue(k)
	end

	net.Start("database")
		net.WriteTable({
			["database"] = endtab
		})
	net.Send(self)
end

function player:dbSend(name, v)
	net.Start("database")
		net.WriteTable({
			["database"] = {
				[name] = v,
			}
		})
	net.Send(self)
end

function player:dbSetValue(name, v)
	self:dbSend(name, v)
	
	if type(v) == "table" then
		v = util.TableToKeyValues(v)
	end

	if string.sub(name, 8) == tostring(self:dbGetValue("clique")) then
		if v < POINTS_FOR_LEADER_MISSION and self:dbGetValue("clique") ~= defaultValues['clique'] then
			self:dbSetValue("clique", defaultValues['clique'])
		end
	end 

	if nws[name] then
		self:dbNW(name, v)
	end

	if name == "model" then
		self:SetModel(v)
	end

	util.SetPData(self:SteamID(), 'srp_' .. name, v)
end

function player:dbChangeValue(name, v)
	if not v or v == 0 then return end

	self:dbSetValue(name, self:dbGetValue(name) + v)
end

function player:dbGetValue(name)
	local v = util.GetPData(self:SteamID(), 'srp_' .. name, nil)

	if v and tables[name] then
		v = util.KeyValuesToTable(v)
	end

	return v
end

function GM:ShowHelp(player)
	player:ConCommand("inventory")
end
