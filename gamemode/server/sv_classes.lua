
DayTime = 0
CurPeriod = -1

Students = {}

local function PutEveryoneRoam()
	for k,v in pairs(TEACHERS) do
		if v.ent then
			v.ent:Roam()
		end
	end

	for k,v in pairs(Students) do
		if v.ent then
			v.ent:Roam()
		end
	end
end

function StartNewDay(timeStart)
	if not timeStart then
		timeStart = 0
	end

	CurPeriod = 0
	-- Clean up if refreshing
	timer.Remove("DayTimeTimer")
	timer.Remove("StartClasses")
	timer.Remove("PeriodTimer")
	PutEveryoneRoam()

	DayTime = CurTime() - timeStart * CalcMinute
	SetGlobalInt("DayTime", DayTime)
	SetGlobalInt("ClassPeriod", CurPeriod)
	SetGlobalInt("ClassPeriodEnds", -1)

	timer.Create(
		"DayTimeTimer",
		LengthOfDay - timeStart * CalcMinute,
		0,
		function()
			StartNewDay()
		end
	)

	-- Start classes at 7:00 AM
	-- CalcHour == 1 in-game hour
	if CalcMinute * SchoolStarts - timeStart * CalcMinute > 0 then
		timer.Create(
			"StartClasses",
			CalcMinute * SchoolStarts - timeStart * CalcMinute,
			1,
			function()
				CreatePeriods()
			end
		)
	end
end

function CreatePeriods()
	CurPeriod = 0

	-- Start the initial period.
	CurPeriod = CurPeriod + 1
	StartPeriod(CurPeriod)

	timer.Create(
		"PeriodTimer",
		LengthOfPeriod + PeriodIntermission,
		NumberOfPeriods,
		function()
			CurPeriod = CurPeriod + 1
			StartPeriod(CurPeriod)
		end
	)
end

local last = 1

function StartPeriod(period)
	if period > NumberOfPeriods then
		SetGlobalInt("ClassPeriod", 0)
		SetGlobalInt("ClassPeriodEnds", -1)
		PutEveryoneRoam()
	else
		SetGlobalInt("ClassPeriod", period)
		SetGlobalInt("ClassPeriodEnds", CurTime() + LengthOfPeriod + PeriodIntermission)

		if SCHEDULE[period] then
			if SCHEDULE[period][-1] then
				local filled = 1
				local ran = 1

				for k,v in pairs(TEACHERS) do
					if ran >= last and v.ent and filled <= 6 then
						local d = 't_Cafe' .. filled
						filled = filled + 1

						v.ent:SetDestination(d)
						v.ent:SetIsTeaching(false)
					else
						v.ent:Roam(SCHOOL_POINTS)
					end
					ran = ran + 1
				end

				last = ((last) % (#TEACHERS-6)) + 1

				for k,v in pairs(Students) do
					if v.ent then
						local d = 's_Cafe' .. math.random(1, 3)

						v.ent:SetDestination(d)
					end
				end
			else
				for k,v in pairs(TEACHERS) do
					if v.ent then
						if SCHEDULE[period][k] then
							local c = SCHEDULE[period][k]
							local r = CLASSES[c].Room
							local d = 't_' .. r

							v.ent:SetDestination(d)
							v.ent:SetIsTeaching(true)
						else
							v.ent:Roam(SCHOOL_POINTS)
						end
					end
				end

				for k,v in pairs(Students) do
					if v.ent then
						local c = CLASSES[v.Schedule[period]]
						local d = 's_' .. c.Room

						v.ent:SetDestination(d)
					else
						v.ent:Roam(SCHOOL_POINTS)
					end
				end
			end
		end
	end
end

function SpawnTeacher(meta)
	local entTable = nil

	local SpawnableEntities = list.Get( "SpawnableEntities" )
	entTable = SpawnableEntities["srp_teacher"]
	local entClass = entTable.ClassName

	local ent = ents.Create(entClass)

	if entTable then
		if (entTable.KeyValues) then
			for k, v in pairs(entTable.KeyValues) do
				ent:SetKeyValue(k, v)
			end
		end

		local p = POINTS[ROAMING_POINTS[math.random(#ROAMING_POINTS)]]
		ent:SetPos(p[1] + Vector(math.random(-50, 50), math.random(-50, 50), 0))
		ent:SetAngles(p[2])
		ent:Spawn()
		ent:Activate()
		ent:SetNWName(meta.Name)
		ent:AltModel(meta.Model)
		ent:SetTitle(meta.Title)

		return ent
	end
end

function SpawnStudent(meta)
	local entTable = nil

	local SpawnableEntities = list.Get( "SpawnableEntities" )
	entTable = SpawnableEntities["srp_student"]
	local entClass = entTable.ClassName

	local ent = ents.Create(entClass)

	if entTable then
		if (entTable.KeyValues) then
			for k, v in pairs(entTable.KeyValues) do
				ent:SetKeyValue(k, v)
			end
		end

		local p = POINTS[ROAMING_POINTS[math.random(#ROAMING_POINTS)]]
		ent:SetPos(p[1] + Vector(math.random(-50, 50), math.random(-50, 50), 0))
		ent:SetAngles(p[2])
		ent:Spawn()
		ent:Activate()
		ent:SetNWName(meta.Name)
		ent:AltModel(meta.Model)
		ent:SetTitle(meta.Title)

		return ent
	end
end

function NewStudent(i, c)
	local clique = 1

	if i then
		clique = (i % #CLIQUES) + 1
	elseif not c then
		clique = CLIQUES[math.random(#CLIQUES)]
	elseif c then
		clique = c
	end

	local gender = math.random(1,2)
	local grade = math.random(9,12)
	local sch = GenerateSchedule(grade)

	local names = MALE_NAMES

	if gender == 2 then
		names = FEMALE_NAMES
	end

	local s = {
		["Name"] = names[math.random(#names)] .. " " .. TEACHER_NAMES[math.random(#TEACHER_NAMES)],
		["Title"] = grade .. "th Grader",
		["Model"] = STUDENT_MODELS[gender][math.random(#STUDENT_MODELS[gender])],
		["Schedule"] = sch,
		["Clique"] = clique,
	}
	s.ent = SpawnStudent(s)
	s.ent:SetGender(gender)

	if s.Clique ~= 1 then
		s.ent:SetClique(s.Clique)
	end

	return s
end

-- Clean up all teachers
for k,v in pairs(ents.GetAll()) do
	if v:GetClass() == "srp_teacher" or v:GetClass() == "srp_student" then
		v:Remove()
	end
end

timer.Simple(
	2,
	function()
		-- Spawn all teachers
		for k,v in pairs(TEACHERS) do
			v.ent = SpawnTeacher(v)
		end

		local principal = {
			["Name"] = "Principal Skinner",
			["Title"] = "Principal",
			["Model"] = "models/monk.mdl"
		}
		principal.ent = SpawnTeacher(principal)
		principal.ent:Roam(SCHOOL_POINTS)

		local securityGuard1 = {
			["Name"] = "Officer " .. TEACHER_NAMES[math.random(#TEACHER_NAMES)],
			["Title"] = "Security Guard",
			["Model"] = "models/odessa.mdl"
		}
		securityGuard1.ent = SpawnTeacher(securityGuard1)
		securityGuard1.ent:Roam(ROAMING_POINTS)

		local securityGuard2 = {
			["Name"] = "Officer " .. TEACHER_NAMES[math.random(#TEACHER_NAMES)],
			["Title"] = "Security Guard",
			["Model"] = "models/odessa.mdl"
		}
		securityGuard2.ent = SpawnTeacher(securityGuard2)
		securityGuard2.ent:Roam(ROAMING_POINTS)

		local detentionTeacher = {
			["Name"] = "Mr. " .. TEACHER_NAMES[math.random(#TEACHER_NAMES)],
			["Title"] = "Detention Teacher",
			["Model"] = TEACHER_MODELS[1][math.random(#TEACHER_MODELS[1])]
		}
		detentionTeacher.ent = SpawnTeacher(detentionTeacher)
		detentionTeacher.ent:SetPos(POINTS['t_StudyingRoom1'][1])
		detentionTeacher.ent:SetDestination('t_StudyingRoom1')
		detentionTeacher.ent:SetMonitor(true)

		for i=1,20 do
			table.insert(Students, NewStudent(i))
		end

		local NerdLeader = NewStudent(nil, 2)
		NerdLeader.ent:SetLeader(true)
		local BullyLeader = NewStudent(nil, 3)
		BullyLeader.ent:SetLeader(true)
		local PreppyLeader = NewStudent(nil, 4)
		PreppyLeader.ent:SetLeader(true)
		local BurnoutLeader = NewStudent(nil, 5)
		BurnoutLeader.ent:SetLeader(true)
		local JockLeader = NewStudent(nil, 6)
		JockLeader.ent:SetLeader(true)
	end
)

-- Start a new day.
StartNewDay(StartAtTime)
