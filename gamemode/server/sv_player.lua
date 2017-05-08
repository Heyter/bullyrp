
local player = FindMetaTable("Player")

local teams = {
	[1] = {
		name = "Blue",
		color = Vector(.2, .2, 1.0),
		weapons = {"weapon_pistol"}
	},
	[2] = {
		name = "Red",
		color = Vector(1.0, .2, .2),
		weapons = {"weapon_pistol"}
	}
}

function player:GetRPName()
	local firstName = self:dbGetValue("firstName")
	local lastName = self:dbGetValue("lastName")

	if not firstName or firstName == "" then
		firstName = "Barack"
	end

	if not lastName or lastName == "" then
		lastName = "Obama"
	end

	return firstName .. " " .. lastName
end

function player:SetGamemodeTeam(n)
	if not teams[n] then return end

	self:SetTeam(n)

	self:SetPlayerColor(teams[n].color)

	self:GiveGamemodeWeapons()

	return true
end

function player:GiveGamemodeWeapons()
	local n = self:Team()

	if not teams[n] then return end

	print("On team: " .. n)
	self:StripWeapons()

	for k, weapon in pairs(teams[n].weapons) do
		self:Give(weapon)
	end
end

function player:GiveDetention(time)
	if not self.inDetention then
		local p = POINTS[DETENTION_POINTS[math.random(#DETENTION_POINTS)]]
		self:SetPos(p[1])
		self:SetAngles(p[2])

		self.inDetention = true

		net.Start("notification")
			net.WriteTable({
				["detention"] = CurTime() + time
			})
		net.Send(self)

		timer.Simple(
			time,
			function()
				if IsValid(self) then
					self.inDetention = false
					local g = math.random(1, 2)
					local p = POINTS[DORM_POINTS[g][math.random(#DORM_POINTS[g])]]
					self:SetPos(p[1])
					self:SetAngles(p[2])
				end
			end
		)
	end
end

function player:AddHands()
	-- I didn't write this code. Joke did.
	local oldhands = self:GetHands()
	
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		self:SetHands( hands )
		hands:SetOwner( self )

		-- Which hands should we use?
		local cl_playermodel = self:GetInfo( "cl_playermodel" )
		local info = player_manager.TranslatePlayerHands( cl_playermodel )
		if ( info ) then
			hands:SetModel( "models/weapons/c_arms_citizen.mdl" )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		-- Attach them to the viewmodel
		local vm = self:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		self:DeleteOnRemove( hands )

		hands:Spawn()
	end
end

local function UpdatePlayer(ply, db)
	print ("Updating a player's info!")
	PrintTable(db)
	ply:dbSetValue("grade", 8)

	if IsValid(ply) and db then
		if ply:dbGetValue("grade") == "8" then
			ply:dbSetValue("grade", 9)
		else
			print("Grade is not 8")
			return false
		end
		if db.firstName and db.firstName ~= "" then
			ply:dbSetValue("firstName", string.sub(db.firstName, 1, 15):gsub('%W.',''))
		end
		if db.lastName and db.lastName ~= "" then
			ply:dbSetValue("lastName", string.sub(db.lastName, 1, 15):gsub('%W.',''))
		end
		if db.model then
			local i = tonumber(string.sub(db.model, 1, 1))
			local k = tonumber(db.model.sub(db.model, 3))

			if i and k and STUDENT_MODELS[i] and STUDENT_MODELS[i][k] then
				ply:dbSetValue("model", STUDENT_MODELS[i][k])
				print("Going with model: " .. STUDENT_MODELS[i][k])
			else
				print("Model not FOUND!")
			end
		end
		local CurSchedule = ply:dbGetValue("schedule")

		if db.schedule then
			for i=1,NumberOfPeriods do
				local c = db.schedule[i]
				if c then
					local psch = POSSIBLE_SCHEDULES[tonumber(ply:dbGetValue("grade"))][i]
					if CLASSES[c] and psch then
						for k,v in pairs(psch) do
							if c == v then
								print ("matched v: " .. v)
								CurSchedule[i] = c
							else
								print("Not a mach to " .. v)
							end
						end
					else
						print ("no go on " .. c)
					end
				end
			end
			ply:dbSetValue("schedule", CurSchedule)
		end
	end
end

net.Receive("update_character", function(len, ply)
	local db = net.ReadTable()
	UpdatePlayer(ply, db)
end)
