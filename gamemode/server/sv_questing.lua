
local PendingQuests = {}
local CurrentQuests = {}

function ProcessQuestComplete(ply)
	if ply.HasQuest and CurrentQuests[ply:SteamID64()] then
		local q = CurrentQuests[ply:SteamID64()]
		print("Completing mission for " .. ply:GetName())

		QUEST_TYPES[q.Type].QuestCompleted(ply, q.Meta)

		if not q.AlwaysOpen then
			PendingQuests[q.qid] = nil
		end

		q.ent:QuestFinished()
		CurrentQuests[ply:SteamID64()] = nil
		ply.HasQuest = false

		net.Start("notification")
			net.WriteTable({
				["QuestSuccess"] = true
			})
		net.Send(ply)

		net.Start("quest_feedback")
			net.WriteEntity(q.ent)
			net.WriteUInt(1, 16)
			net.WriteUInt(q.Type, 16)
		net.Send(ply)
	end
end

function ProcessQuestAbort(ply)
	if ply.HasQuest and CurrentQuests[ply:SteamID64()] then
		local q = CurrentQuests[ply:SteamID64()]

		print("Aborting mission for " .. ply:GetName())

		QUEST_TYPES[q.Type].QuestFailedCleanup(q.Meta)
		QUEST_TYPES[q.Type].QuestAbort(ply, q.Meta)

		q.ent:QuestFailed()
		ply.HasQuest = false
		CurrentQuests[ply:SteamID64()] = nil

		net.Start("notification")
			net.WriteTable({
				["QuestAbort"] = true
			})
		net.Send(ply)

		net.Start("quest_feedback")
			net.WriteEntity(q.ent)
			net.WriteUInt(2, 16)
			net.WriteUInt(q.Type, 16)
		net.Send(ply)
	end
end

function SpawnQuestItem(ply, itemID)
	local item = QUEST_ITEMS[itemID]
	local entTable = nil

	local SpawnableEntities = list.Get( "SpawnableEntities" )
	entTable = SpawnableEntities["srp_quest_item"]
	local entClass = entTable.ClassName

	local ent = ents.Create(entClass)

	if entTable then
		if (entTable.KeyValues) then
			for k, v in pairs(entTable.KeyValues) do
				ent:SetKeyValue(k, v)
			end
		end

		local p = POINTS[ROAMING_POINTS[math.random(#ROAMING_POINTS)]]
		ent:SetPos(p[1] + Vector(math.random(-25, 25), math.random(-25, 25), 30))
		ent:SetAngles(p[2])
		ent:Spawn()
		ent:Activate()
		ent:SetNWItem(itemID)
		ent:SetPlayer(ply)
		ent:AltModel(item.Model)

		print ("spawning quest item for " .. ply:GetName())
		print (ent:GetPos())

		return ent
	end

	print ("Not spawning")
end

function ProcessQuestAccept(ply, qid)
	if PendingQuests[qid] and not ply.HasQuest then
		local q = PendingQuests[qid]
		q.qid = qid

		ply.HasQuest = true
		CurrentQuests[ply:SteamID64()] = q
		q.ent:QuestAccepted()
		q.Meta.qents = QUEST_TYPES[q.Type].QuestAccepted(ply, q.Meta)
	else
		net.Start("notification")
			net.WriteTable({
				["QuestAcceptFailed"] = true
			})
		net.Send(ply)
	end
end

net.Receive("quest_accept", function(len, ply)
	local qid = net.ReadUInt(32)
	ProcessQuestAccept(ply, qid)
end)

net.Receive("quest_abort", function(len, ply)
	local abort = net.ReadBool()
	if abort then
		ProcessQuestAbort(ply, qid)
	end
end)

function GenerateQuest(t)
	if not t then
		t = math.random(#RANDOM_QUESTS)
	end

	return {
		Type = t,
		questLine1 = math.random(#QUEST_GREETINGS1),
		questLine2 = math.random(#QUEST_GREETINGS2),
		questLine3 = math.random(#QUEST_GREETINGS3),
		questLine4 = math.random(#QUEST_CHOICES_DIALOGUE[t]),
		questLine5 = math.random(#QUEST_GREETINGS4),
		Meta = QUEST_TYPES[t].GetMeta()
	}
end

local function PickNewStudentForQuest()
	local s = Students[math.random(#Students)]

	local tries = 0

	if s then
		while s.ent:HasQuest() and tries < 20 do
			s = Students[math.random(#Students)]
			tries = tries + 1
		end
	end

	-- Failed to find a student.
	if tries >= 20 then
		s = nil
	end

	return s
end

function GenerateNewQuest(s, quest)
	if not s then
		s = PickNewStudentForQuest()
	end

	if s then
		if not quest then
			quest = GenerateQuest()
		end
		
		quest.ent = s.ent
		quest.Meta.entID = s.ent:EntIndex()

		local qid = table.insert(PendingQuests, quest)

		s.ent:SetQuest(qid, quest)
	end
end

QuestTester = nil

-- Clean up all quests
for k,v in pairs(ents.GetAll()) do
	if v:GetClass() == "srp_quest_item" then
		v:Remove()
	end
end

timer.Remove("quest_generation")

timer.Create(
	"quest_generation",
	CalcHour,
	0,
	function()
		for k,v in pairs(PendingQuests) do
			if not v.AlwaysOpen and v.ent:HasQuest() and v.ent:IsQuestOpen() then
				v.ent:QuestFinished()
				PendingQuests[k] = nil
			end
		end

		GenerateNewQuest()
		GenerateNewQuest()
		GenerateNewQuest()
	end
)
