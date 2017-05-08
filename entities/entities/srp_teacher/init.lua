
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:GoToRespawn()
	local p = POINTS[ROAMING_POINTS[math.random(#ROAMING_POINTS)]]
	self:SetPos(p[1] + Vector(math.random(-50, 50), math.random(-50, 50), 0))
	self:SetAngles(p[2])
end

function ENT:Initialize()
	self.Posted = false
	self:SetModel( "models/monk.mdl" )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.stuckCount = 0
	self.Cancel = false
	self:SetUseType( SIMPLE_USE )
	self.IsNotMonitoring = true
	self.IsTeaching = false
end

function ENT:SetNWName(name)
	self:SetNWString("Name", name)
end

function ENT:SetTitle(title)
	self.Title = title
	self:SetNWString("Title", title)
end

function ENT:AltModel(model)
	self:SetModel(model)
end

function ENT:SetGender(gender)
	self.gender = gender
end

function ENT:Think()
	if self.IsNotMonitoring and IsCurfew() then
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 200)) do
			if v:IsPlayer() and not (v.watchedIntro and CurTime() - v.watchedIntro < 400) then
				v:GiveDetention(60)
				v.watchedIntro = false
			end
		end
	end
end

function ENT:MoveToPos( pos, options )
	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( not self.Cancel and path:IsValid() ) do
		path:Update( self )

		-- Draw the path (only visible on listen servers or single player)
		if ( options.draw ) then
			path:Draw()
		end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			if self:GetPos():Distance(pos) < 75 then
				return "stuck"
			else
				self:GoToRespawn()
			end
		end

		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		--
		-- If they set repath then rebuild the path every x seconds
		--
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		coroutine.yield()
	end
	return "ok"
end

function ENT:GetRandom()
	points = ROAMING_POINTS

	if self.RoamPoints then
		points = self.RoamPoints
	end
	
	return points[math.random(#points)]
end

function ENT:RunBehaviour()
	while (true) do
		self:StartActivity( ACT_WALK )			-- Walk animation

		local point = nil

		if self.Posted then
			if self.destination then
				point = POINTS[self.destination]
			elseif self.destinationByPos then
				point = self.destinationByPos
			end
			self.loco:SetDesiredSpeed( 200 )		-- Walk speed
		else
			local d = self:GetRandom()
			point = POINTS[d]
			self.loco:SetDesiredSpeed( 75 )		-- Walk speed
		end

		local travelto = point[1]

		self.Cancel = false

		self:MoveToPos( travelto, {
			lookahead = 100,
			draw = false,
			repath = 3
		})

		point[2].pitch = 0
		self:SetAngles(point[2])
		self:StartActivity( ACT_IDLE )			-- Idle animation

		local pos = 0
		local dir = 3
		local a = self:GetAngles()

		if not self.Cancel then
			coroutine.wait( 5 )
		end

		while (not self.Cancel and self.Posted) do
			coroutine.wait( 0.1 )
			if pos > 30 or pos < -30 then
				dir = -dir
			end

			a.yaw = a.yaw + dir
			pos = pos + dir

			self:SetAngles(a)
		end

		coroutine.yield()
		-- The function is done here, but will start back at the top of the loop and make the bot walk somewhere else
	end
end

function ENT:SetIsTeaching(bool)
	self.IsTeaching = bool
end

function ENT:SetDestination(point)
	self.destination = point
	self.destinationByPos = nil
	self.Posted = true
	self.Cancel = true
end

function ENT:SetDestinationByPos(pos)
	self.destinationByPos = pos
	self.destination = nil
	self.Posted = true
	self.Cancel = true
end

function ENT:Roam(points)
	self.Posted = false
	self.Cancel = true
	self.RoamPoints = points
	self.IsTeaching = false
end

function ENT:Use( activator, caller, type, value )
	if self.IsTeaching and not caller.IsTeacher then
		GetGlobalInt("ClassPeriodEnds")
		caller.IsTeacher = true
		caller:SetNWString("teacher", self.Title)

		timer.Simple(
			GetGlobalInt("ClassPeriodEnds") - CurTime(),
			function()
				if caller and IsValid(caller) then
					caller.IsTeacher = false
					caller:SetNWString("teacher", "")
					net.Start("notification")
						net.WriteTable({
							["GenericNotice"] = "You are no longer the teacher!"
						})
					net.Send(caller)
				end
			end
		)
		self:Roam(SCHOOL_POINTS)
		net.Start("notification")
			net.WriteTable({
				["GenericSuccess"] = "You are now the " .. self.Title .. "!"
			})
		net.Send(caller)
	elseif self.qid and self.quest and self.QuestOpen and caller and IsValid(caller) and caller:IsPlayer() and not caller.HasQuest then
		net.Start("quest_request")
			net.WriteUInt(self.qid, 32)
			net.WriteEntity(self)
			net.WriteUInt(self.quest.Type, 16)
			net.WriteUInt(self.quest.questLine1, 16)
			net.WriteUInt(self.quest.questLine2, 16)
			net.WriteUInt(self.quest.questLine3, 16)
			net.WriteUInt(self.quest.questLine4, 16)
			net.WriteUInt(self.quest.questLine5, 16)
			net.WriteTable(self.quest.Meta)
		net.Send(caller)
	end
end

function ENT:Touch( activator, caller, type, value )
end

function ENT:HasQuest()
	return self.qid ~= nil
end

function ENT:IsQuestOpen()
	return self.QuestOpen
end

function ENT:SetQuest(qid, quest)
	self.qid = qid
	self.quest = quest
	self.QuestOpen = true

	self:SetNWBool("QuestOpen", self.QuestOpen)
end

function ENT:QuestAccepted()
	self.QuestOpen = false

	self:SetNWBool("QuestOpen", self.QuestOpen)
end

function ENT:QuestFailed()
	self.QuestOpen = true

	self:SetNWBool("QuestOpen", self.QuestOpen)
end

function ENT:QuestFinished()
	self.qid = nil
	self.quest = nil
	self.QuestOpen = false

	self:SetNWBool("QuestOpen", self.QuestOpen)
end

function ENT:SetMonitor(bool)
	self.IsNotMonitoring = bool
	self:SetNWBool("IsNotMonitoring", bool)
end
