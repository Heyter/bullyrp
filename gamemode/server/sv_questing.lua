
PendingQuests = {}
CurrentQuests = {}

function SpawnQuestItem(ply, itemID)
	
end

local function ProcessQuestAccept(ply, qid)
	if PendingQuests[qid] and not caller.HasQuest then
		local q = PendingQuests[qid]

		CurrentQuests[ply:SteamID64()] = q
		q.ent:QuestAccepted()
		QUEST_TYPES[t].QuestAccepted(ply, q)
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

timer.Simple(
	2,
	function()
		local questTester = {
			["Name"] = "Mr. " .. TEACHER_NAMES[math.random(#TEACHER_NAMES)],
			["Title"] = "Detention Teacher",
			["Model"] = TEACHER_MODELS[1][math.random(#TEACHER_MODELS[1])]
		}

		PrintTable(questTester)

		questTester.ent = SpawnTeacher(questTester)
		questTester.ent:SetPos(Vector(16.68, -3140.97, 8.031))
		questTester.ent:SetDestinationByPos({Vector(690.305, -2381.635, 8.031), Angle(13.125, -156.706, 0.0)})
		
		local quest = GenerateQuest()
		quest.ent = questTester.ent

		local qid = table.insert(PendingQuests, quest)

		questTester.ent:SetQuest(qid, quest)
	end
)
