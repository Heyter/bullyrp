
local PendingQuests = {}
local CurrentQuests = {}

function ProcessQuestComplete(ply)
	if ply.HasQuest and CurrentQuests[ply:SteamID64()] then
		local q = CurrentQuests[ply:SteamID64()]

		QUEST_TYPES[q.Type].QuestCompleted(ply, q.Meta)

		q.ent:QuestFinished()
		ply.HasQuest = false
		CurrentQuests[ply:SteamID64()] = nil
		PendingQuests[q.qid] = nil

		net.Start("notification")
			net.WriteTable({
				["QuestSuccess"] = true
			})
		net.Send(ply)
	end

	local quest = GenerateQuest()
	quest.ent = QuestTester.ent

	local qid = table.insert(PendingQuests, quest)

	QuestTester.ent:SetQuest(qid, quest)
end

function ProcessQuestAbort(ply)
	print("Aborting!")
	if ply.HasQuest and CurrentQuests[ply:SteamID64()] then
		print("Here we go! aborting")
		local q = CurrentQuests[ply:SteamID64()]

		QUEST_TYPES[q.Type].QuestFailedCleanup(q.Meta)

		q.ent:QuestFailed()
		ply.HasQuest = false
		CurrentQuests[ply:SteamID64()] = nil
		PendingQuests[q.qid] = nil

		net.Start("notification")
			net.WriteTable({
				["QuestAbort"] = true
			})
		net.Send(ply)
	end

	local quest = GenerateQuest()
	quest.ent = QuestTester.ent

	local qid = table.insert(PendingQuests, quest)

	QuestTester.ent:SetQuest(qid, quest)
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
		ent:SetPos(p[1] + Vector(math.random(-50, 50), math.random(-50, 50), 20))
		ent:SetAngles(p[2])
		ent:Spawn()
		ent:Activate()
		ent:SetNWItem(itemID)
		ent:SetPlayer(ply)
		ent:AltModel(item.Model)

		print ("spawning quest item")
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
	print("Got new quest accept")
	local qid = net.ReadUInt(32)
	ProcessQuestAccept(ply, qid)
end)

net.Receive("quest_abort", function(len, ply)
	print("Got new quest abort")
	local abort = net.ReadBool()
	if abort then
		ProcessQuestAbort(ply, qid)
	end
end)

function GenerateQuest()
	local t = math.random(#QUEST_TYPES)

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

QuestTester = nil

-- Clean up all quests
for k,v in pairs(ents.GetAll()) do
	if v:GetClass() == "srp_quest_item" then
		v:Remove()
	end
end

timer.Simple(
	2,
	function()
		QuestTester = {
			["Name"] = "Mr. " .. TEACHER_NAMES[math.random(#TEACHER_NAMES)],
			["Title"] = "Detention Teacher",
			["Model"] = TEACHER_MODELS[1][math.random(#TEACHER_MODELS[1])]
		}

		PrintTable(QuestTester)

		QuestTester.ent = SpawnTeacher(QuestTester)
		QuestTester.ent:SetPos(Vector(16.68, -3140.97, 8.031))
		QuestTester.ent:SetDestinationByPos({Vector(690.305, -2381.635, 8.031), Angle(13.125, -156.706, 0.0)})
		
		local quest = GenerateQuest()
		quest.ent = QuestTester.ent

		local qid = table.insert(PendingQuests, quest)

		QuestTester.ent:SetQuest(qid, quest)
	end
)


