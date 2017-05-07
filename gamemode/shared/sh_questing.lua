
QUEST_ITEMS = {
	[1] = {
		["Name"] = "Green Sofa",
		["Model"] = "models/props_c17/FurnitureCouch002a.mdl",
	},
	[2] = {
		["Name"] = "Wooden Chair",
		["Model"] = "models/props_c17/FurnitureChair001a.mdl",
	},
	[3] = {
		["Name"] = "Canister",
		["Model"] = "models/props_c17/canister01a.mdl",
	},
	[4] = {
		["Name"] = "Blue Chair",
		["Model"] = "models/props_c17/chair02a.mdl",
	},
	[5] = {
		["Name"] = "Bath Tub",
		["Model"] = "models/props_c17/FurnitureBathtub001a.mdl",
	},
	[6] = {
		["Name"] = "Small Chair",
		["Model"] = "models/props_interiors/Furniture_chair01a.mdl",
	},
	[7] = {
		["Name"] = "Metal Chair",
		["Model"] = "models/props_interiors/Furniture_chair03a.mdl",
	},
	[8] = {
		["Name"] = "Yellow Chair",
		["Model"] = "models/props_interiors/Furniture_Couch02a.mdl",
	},
	[9] = {
		["Name"] = "Clock",
		["Model"] = "models/props_trainstation/trainstation_clock001.mdl",
	},
	[10] = {
		["Name"] = "Package",
		["Model"] = "models/props_junk/cardboard_box001a.mdl",
	},
	[11] = {
		["Name"] = "Brown Package",
		["Model"] = "models/props_junk/cardboard_box002a.mdl",
	},
	[12] = {
		["Name"] = "Big Package",
		["Model"] = "models/props_junk/cardboard_box003a.mdl",
	},
	[13] = {
		["Name"] = "Small Package",
		["Model"] = "models/props_junk/cardboard_box004a.mdl",
	},
	[14] = {
		["Name"] = "Metal Bucket",
		["Model"] = "models/props_junk/MetalBucket02a.mdl",
	},
	[15] = {
		["Name"] = "Gas Can",
		["Model"] = "models/props_junk/metalgascan.mdl",
	},
	[16] = {
		["Name"] = "Kennel",
		["Model"] = "models/props_lab/kennel_physics.mdl",
	},
	[17] = {
		["Name"] = "Folding Chair",
		["Model"] = "models/props_wasteland/controlroom_chair001a.mdl",
	},
	[18] = {
		["Name"] = "Traffic Cone",
		["Model"] = "models/props_junk/TrafficCone001a.mdl",
	},
	[19] = {
		["Name"] = "Wheel",
		["Model"] = "models/props_wasteland/wheel01.mdl",
	},
	[20] = {
		["Name"] = "Saw Blade",
		["Model"] = "models/props_junk/sawblade001a.mdl",
	},
	[21] = {
		["Name"] = "Lamp",
		["Model"] = "models/props_lab/desklamp01.mdl",
	},
	[22] = {
		["Name"] = "Gray Crate",
		["Model"] = "models/props_junk/PlasticCrate01a.mdl",
	},
	[23] = {
		["Name"] = "Pot",
		["Model"] = "models/props_interiors/pot02a.mdl",
	},
	[24] = {
		["Name"] = "Hook",
		["Model"] = "models/props_junk/meathook001a.mdl",
	},
	[25] = {
		["Name"] = "Crate",
		["Model"] = "models/props_junk/wood_crate001a.mdl",
	},
	[26] = {
		["Name"] = "Barricade",
		["Model"] = "models/props_wasteland/barricade001a.mdl",
	},
	[27] = {
		["Name"] = "Trash Bin",
		["Model"] = "models/props_junk/TrashBin01a.mdl",
	},
	[28] = {
		["Name"] = "Doll",
		["Model"] = "models/props_c17/doll01.mdl",
	},
	[29] = {
		["Name"] = "Monitor",
		["Model"] = "models/props_lab/monitor01a.mdl",
	},
	[30] = {
		["Name"] = "Door",
		["Model"] = "models/props_vehicles/carparts_door01a.mdl",
	},
	[31] = {
		["Name"] = "Breen Clock",
		["Model"] = "models/props_combine/breenclock.mdl",
	},
	[32] = {
		["Name"] = "Jar",
		["Model"] = "models/props_lab/jar01a.mdl",
	},
	[33] = {
		["Name"] = "Hula Girl",
		["Model"] = "models/props_lab/huladoll.mdl",
	},
	[34] = {
		["Name"] = "Skull",
		["Model"] = "models/Gibs/HGIBS.mdl",
	},
	[35] = {
		["Name"] = "Pay Phone",
		["Model"] = "models/props_trainstation/payphone001a.mdl",
	},
}

QUEST_POINTS = {
	
}

QUEST_GREETINGS1 = {
	"Hey!",
	"Hey man!",
	"Hi!",
	"Good to see you!",
	"I'm glad you're here!",
	"Nice to see you!",
	"Long time no see!",
	"It's been a while!",
	"Nice to meet you.",
	"Yo!",
	"Howdy!",
	"Sup?",
	"Whazzup?!",
	"Hiya!",
	"Hey b0ss!",
	"Greetings.",
}

QUEST_GREETINGS2 = {
	"How's it going?",
	"How are you doing?",
	"What's up?",
	"What's new?",
	"What's going on?",
	"How's everything?",
	"How are things?",
	"What's good?",
	"Alright mate?",
	"How've you been?",
	"You alright?",
}

QUEST_GREETINGS3 = {
	"I need some help with something.",
	"I NEED some help with something!",
	"I'm in some trouble.",
	"You gotta help me out here.",
	"I'm in need of assistance.",
	"Can you give me a hand?",
	"I'm in a spot of trouble.",
}

QUEST_TYPES = {
	[1] = {
		Name = "FindItem", ID = 1,
		Description = "Please find it!",
		Lines = function(strs, meta) 
			strs[2] = Color(39, 174, 96)
			strs[3] = QUEST_ITEMS[meta.ItemID].Name
			strs[4] = Color(255,255,255)
			return strs
		end,
		GetMeta = function()
			return {
				ItemID = math.random(#QUEST_ITEMS),
				Points = math.random(10,20),
			}
		end,
		QuestAccepted = function(ply, meta)
			return SpawnQuestItem(ply, meta.ItemID)
		end,
		QuestFailedCleanup = function(meta)
			meta.qents:Remove()
		end,
		QuestCompleted = function(ply, meta)
			ply:dbChangeValue("xp", 10)
		end,
		QuestReward = function(ply, meta)
			local e = Entity(meta.entID)

			if e then
				local c = e:GetClique()
				local cname = CLIQUES[c].GroupName

				return {
					"+" .. meta.Points,
					ClientConfig.OverheadGradeColor(e, 1),
					cname,
					Color(255,255,255),
					"XP"
				}
			else
				print ("Entity was null, lol.")
				return "None."
			end
		end,
	},
}

-- Quest type indexed
QUEST_CHOICES_DIALOGUE = {
	[1] = {
		{"I lost my", nil, nil, nil, "and I need your help finding it!"},
		{"Someone stole my", nil, nil, nil, "and I can't seem to find it anywhere!"},
		{"On my way to school, I dropped my", nil, nil, nil, "on the ground!"},
		{"I need a", nil, nil, nil, "to, ah, finish an assignment for school."},
		{"There is an ingredient I'm missing for my love potion. It calls for a", nil, nil, nil, "but I can't find any anywhere."},
	}
}

QUEST_GREETINGS4 = {
	"What do you say, could you pleeeeease give me a hand?",
	"I could really use your help!",
	"Will you help me out?",
	"Time is short, please?",
}

QUEST_CHOICES_DIALOGUE_FAILURE = {
	[1] = {
		"I can't believe you would let me down like that!",
		"I'll remember not to ask you again next time!",
	}
}

QUEST_CHOICES_DIALOGUE_SUCCESS = {
	[1] = {
		"Thank you for your help! I'll never forget it!",
		"You're a life-saver man!",
		"I owe you big time for doing this for me!",
	}
}
