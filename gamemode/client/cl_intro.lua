
local Roll = true

local scrolls = {
	-- high school front
	[1] = {
		StartVec = Vector(-872.704834, -2351.010742, 642.994019),
		StartAng = Angle(6.562334, 80.893242, 0.000000),
		EndVec = Vector(646.259338, -2257.489014, 494.649048),
		EndAng = Angle(0.860590, 104.238182, 0.000000),
		EndTime = 7,
		Text = GetTString("Part1"),
		Language = {
			[1] = "Welcome to BullyRP here at Black Lake High. I'll be your tour guide today.",
		},
	},
-- 	-- high school lobby
	[2] = {
		StartVec = Vector(-265.943115, 336.700470, 163.192047),
		StartAng = Angle(7.100227, 120.698029, 0.000000),
		EndVec = Vector(199.733078, -125.496880, 627.423401),
		EndAng = Angle(-6.347269, -14.099856, 0.000000),
		EndTime = 9,
		Text = GetTString("Part2"),
		Language = {
			[1] = "This generous school has 12 spacious classrooms with knowledgeable teachers that will guide you in your journey of education.",
		},
	},

	-- detention
	[3] = {
		StartVec = Vector(265.777771, 295.117310, 169.332947),
		StartAng = Angle(2.797026, -154.595306, 0.000000),
		EndVec = Vector(-561.208, -148.964, 160.62),
		EndAng = Angle(2.797026, -160, 0.000000),
		EndTime = 14,
		NoEnding = true,
		Text = GetTString("Part3"),
		Language = {
			[1] = "Here you'll find the detention room. This is where naughty boys and girls go. If you're caught breaking the rules, you'll be sent here for a time out. This is where you’ll end up too, if caught after lights out.",
		},
	},

	-- counselor
	[4] = {
		StartVec = Vector(-561.208, -148.964, 160.62),
		StartAng = Angle(2.797026, -160, 0.000000),
		EndVec = Vector(-1286.223, -148.1, 150.32),
		EndAng = Angle(1.152, -111.413, 0.0),
		EndTime = 13,
		NoEnding = true,
		Text = GetTString("Part4"),
		Language = {
			[1] = "Next door is the counselor's office. This is where you'll want to go next so you can officially enroll in Black Lake High. You'll also choose your preferred semester for this year.",
		},
	},

	-- lockers
	[5] = {
		StartVec = Vector(-1286.223, -148.1, 150.32),
		StartAng = Angle(1.152, -111.413, 0.0),
		EndVec = Vector(-1556.096, 950.77, 162.254),
		EndAng = Angle(5.24, -34.994, 0.0),
		EndTime = 19,
		Text = GetTString("Part5"),
		Language = {
			[1] = "On each sides of the first floor, you'll find the lockers. Each year, you are assigned a new locker. This is where you could keep your school books, materials, and love letters from all the girls - unless you turn out to be a nerd. Then you could keep all of your 'kick me' signs in there I guess.",
		},
	},

	-- lunch room
	[6] = {
		StartVec = Vector(-3813.924, -241.57, 140.605),
		StartAng = Angle(1.69, 83.201, 0.0),
		EndVec = Vector(-5135.938, 1484.186, 145.726),
		EndAng = Angle(-4.119, 45.645+150, 0.0),
		EndTime = 15,
		Text = GetTString("Part6"),
		Language = {
			[1] = "Each day, there will be classes that you'll have to attend. Mid-day you’ll find yourself in the cafeteria. This is where everyone gathers around to eat. You'll want to come and eat here about once a day to keep from starving.",
		},
	},

	-- library front
	[7] = {
		StartVec = Vector(1813.608, 3638.754, 368.851),
		StartAng = Angle(0.829, 64.592, 0.0),
		EndVec = Vector(3754.309, 3671.178, 373.478),
		EndAng = Angle(-1.753, 124.944, 0.0),
		EndTime = 11,
		Text = GetTString("Part7"),
		Language = {
			[1] = "Over here you'll find the library. Inside are these things with paper called books. If you're the studying type, you'll probably find yourself in here quite often.",
		},
	},

	-- Inside of library
	[8] = {
		StartVec = Vector(3883.408, 4776.128, 441.34),
		StartAng = Angle(5.348, 156.933, 0.0),
		EndVec = Vector(1793.257, 5335.401, 271.205),
		EndAng = Angle(-6.271, -34.92+180, 0.0),
		EndTime = 10,
		Text = GetTString("Part8"),
		Language = {
			[1] = "There are also computers in here to do things such as check your Facebook or play video games such as Minecraft. Maybe even do a little research for school.",
		},
	},

	-- Media center front
	[9] = {
		StartVec = Vector(-2946.593, 3655.483, 150.732),
		StartAng = Angle(3.035, 79.335, 0.0),
		EndVec = Vector(-2772.926, 5132.631, 150.875),
		EndAng = Angle(2.604, -16.411, 0.0),
		EndTime = 14,
		NoEnding = true,
		Text = GetTString("Part9"),
		Language = {
			[1] = "The next place on our tour is the media center. Sometimes a teacher may hold class in here so you can work online. There are also some computer classes to learn how basic programming and internet surfing skills.",
		},
	},

	-- Media center inside
	[10] = {
		StartVec = Vector(-2772.926, 5132.631, 150.875),
		StartAng = Angle(2.604, -16.411, 0.0),
		EndVec = Vector(-2242.9, 4489.154, 150.941),
		EndAng = Angle(9.92, -176.813, 0.0),
		EndTime = 17,
		Text = GetTString("Part10"),
		Language = {
			[1] = "In the back of the media center is the nurse’s station. If you get into a fight and get knocked out by some chap, this is where you'll be taken to. Remember: Fights are for naughty students so you should try to avoid that so you don't get kicked out of your fifth school.",
		},
	},

	-- Gym front
	[11] = {
		StartVec = Vector(16.001, 5550.568, 104.069),
		StartAng = Angle(-2.022, 90.814, 0.0),
		EndVec = Vector(3.949, 8051.819, 46.078),
		EndAng = Angle(3.68, 91.029, 0.0),
		EndTime = 14,
		NoEnding = true,
		Text = GetTString("Part11"),
		Language = {
			[1] = "Here is the gym. This is where you'll get all of your exercise - that is when you're not running from the bullies. Here is where you'll play classics such as basketball, kickball, and my personal favorite: dodge ball.",
		},
	},

	-- gym around
	[12] = {
		StartVec = Vector(3.949, 8051.819, 46.078),
		StartAng = Angle(3.68, 91.029, 0.0),
		EndVec = Vector(349.602, 8164.182, 56.614),
		EndAng = Angle(-1.699, 270.336, 0.0),
		EndTime = 8,
		Text = GetTString("Part12"),
		Language = {
			[1] = "This is also where assemblies and school-wide presentations are held so be on the lookout for those on your schedule.",
		},
	},

	-- Soccer field
	[13] = {
		StartVec = Vector(-3.439, 8577.254, 304.578),
		StartAng = Angle(8.521, 90.781, 0.0),
		EndVec = Vector(-1793.956, 11886.974, 83.036),
		EndAng = Angle(6.692, -32.021, 0.0),
		EndTime = 15,
		Text = GetTString("Part13"),
		Language = {
			[1] = "Behind the gym, is the sports field. Every Friday night the school hosts a soccer game that you don't want to miss. Unless you're busy studying for class of course. School does come first here at Blake Lake High. ",
		},
	},

	-- dorms front
	[14] = {
		StartVec = Vector(3040.489, 1620.495, 575.924),
		StartAng = Angle(9.059, -32.075, 0.0),
		EndVec = Vector(4189.798, 391.881, 160.829),
		EndAng = Angle(-0.623, -3.566, 0.0),
		EndTime = 13,
		NoEnding = true,
		Text = GetTString("Part14"),
		Language = {
			[1] = "The last stop on this tour is the dorms - the place where you'll be spending the next four years of your life. On the bottom floor you'll find the girl dorms. On the top floor you'll find the boys dorm.",
		},
	},

	-- dorms inside lower
	[15] = {
		StartVec = Vector(4189.798, 391.881, 160.829),
		StartAng = Angle(-0.623, -3.566, 0.0),
		EndVec = Vector(4965.035, 322.717, 300.387),
		EndAng = Angle(0.991, 141.129, 0.0),
		EndTime = 9,
		NoEnding = true,
		Text = GetTString("Part15"),
		Language = {
			[1] = "Make sure you stay within the dorms during the curfew hours at night. You'll know it's curfew because the clock at the top will turn red.",
		},
	},

	-- dorms inside upper
	[16] = {
		StartVec = Vector(4965.035, 322.717, 300.387),
		StartAng = Angle(0.991, 141.129, 0.0),
		EndVec = Vector(4969.066, 269.364, 397.825),
		EndAng = Angle(2.604, 203.463, 0.0),
		EndTime = 11,
		Text = GetTString("Part16"),
		Language = {
			[1] = "If you happen to identify as an Apache Helicopter, there is a special dorm area just for you - on the roof of the dorms next to the school's swimming pool.",
		},
	},

	-- pan back high school
	[17] = {
		StartVec = Vector(-42.968, 5096.783, 252.974),
		StartAng = Angle(-0.408, -62.627, 0.0),
		EndVec = Vector(92.366, 2454.309, 160.231),
		EndAng = Angle(-0.193, -132.339, 0.0),
		EndTime = 32,
		Text = GetTString("Part17"),
		Language = {
			[1] = "Now before we conclude our tour, there's one last thing you should know: Here at Black Lake High, there are 5 main cliques: the nerds, the bullies, the preppies, the burnouts and the jocks. Before you can join a clique, you must win their respect. To do this you'll have to help them out by doing things like completing missions for members of their groups. Once you have earned enough street cred, find their leader and complete the initiation quest. You can only be in one clique at a time. If you join another, you'll lose your current clique’s status.",
		},
	},

	-- Library desks
	[18] = {
		StartVec = Vector(2095.004, 5116.858, 198.139),
		StartAng = Angle(6.477, 10.354, 0.0),
		EndVec = Vector(3284.312, 5384.925, 180.487),
		EndAng = Angle(4.11, -59.358, 0.0),
		EndTime = 8,
		Text = GetTString("Part18"),
		Language = {
			[1] = "The Nerds hang out in the library,",
		},
	},

	-- school 2nd floor
	[19] = {
		StartVec = Vector(548.169, 624.042, 400.586),
		StartAng = Angle(-2.559, -123.583, 0.0),
		EndVec = Vector(-541.257, 552.119, 420.838),
		EndAng = Angle(-1.269, -53.763, 0.0),
		EndTime = 8,
		Text = GetTString("Part19"),
		Language = {
			[1] = "the bullies roam the inside of the school,",
		},
	},

	-- front court yard
	[20] = {
		StartVec = Vector(-412.824, -2707.294, 262.026),
		StartAng = Angle(22.937, 55.463, 0.0),
		EndVec = Vector(560.017, -2774.52, 339.573),
		EndAng = Angle(19.064, 132.168, 0.0),
		EndTime = 8,
		Text = GetTString("Part20"),
		Language = {
			[1] = "the preppies kick rocks outside in front of the statue,",
		},
	},

	-- back cafe
	[21] = {
		StartVec = Vector(-3821.609, -40.514, 195.634),
		StartAng = Angle(11.426, 136.799, 0.0),
		EndVec = Vector(-5358.379, -245.003, 338.381),
		EndAng = Angle(40.472, 120.34, 0.0),
		EndTime = 8,
		Text = GetTString("Part21"),
		Language = {
			[1] = "the burnouts blaze it up behind the cafeteria,",
		},
	},

	-- down soccer field
	[22] = {
		StartVec = Vector(-1511.635, 10361.201, -55.729),
		StartAng = Angle(8.629, 13.513, 0.0),
		EndVec = Vector(966.075, 11489.856, -111.222),
		EndAng = Angle(10.673, -95.143, 0.0),
		EndTime = 8,
		Text = GetTString("Part22"),
		Language = {
			[1] = "and the jocks spend their time tearing up the soccer field.",
		},
	},

	-- ending fly by front 
	[23] = {
		StartVec = Vector(1738.464, -2268.177, 300.093),
		StartAng = Angle(-4.819, 156.528, 0.0),
		EndVec = Vector(-10.647, -982.497, 100.031),
		EndAng = Angle(-10.198, 90.044, 0.0),
		EndTime = 13,
		Text = GetTString("Part23"),
		Language = {
			[1] = "Well, this concludes your tour of the campus! I hope you enjoy your time here at Black Lake High and remember: your parents only sent you here because they love deep down inside - they just don't know how to show it.",
		},
	},
}

totalLength = 0

for k,v in pairs(scrolls) do
	totalLength = totalLength + v.EndTime
end

local backgroundChannel = nil
local lastTalking = nil

function PlaySound(track, level)
    sound.PlayFile(track, "", function(channel, error, errorName)
        if (IsValid(channel)) then
            channel:Play()
            channel:SetVolume(level)

            if not backgroundChannel then
            	backgroundChannel = channel
            else
            	lastTalking = channel
            end
        end
    end)
end

local start = -1
local estart = -1
local send = -1
local fadedowntriggered = false
local audiotriggered = false
local started = -1
local sstart = -1

local rolling = false

local dProgressBar = nil

function RollCutscene()
	start = 1
	estart = CurTime()
	send = scrolls[1].EndTime
	fadedowntriggered = false
	audiotriggered = false

	sstart = CurTime()
	started = CurTime()

	DisableHud()
	HUDTriggerFade()

	if dProgressBar and IsValid(dProgressBar) then
		dProgressBar:Remove()
	end

	dProgressBar = vgui.Create("DPanel")
	dProgressBar:SetPos(0,ScrH()-45)
	dProgressBar:SetSize(ScrW(), 45)
	dProgressBar:MakePopup()
	dProgressBar.Paint = function(s,w,h)
		draw.RoundedBox(
			0,
			0,35,
			w * ((CurTime() - started) / totalLength), 10,
			Color(192, 57, 43, 100)
		)
	end

	timer.Simple(
		10,
		function()
			dSkipButton = vgui.Create("DButton", dProgressBar)
			dSkipButton:SetPos(dProgressBar:GetWide() - 100, 0)
			dSkipButton:SetSize(100-30, 25)
			dSkipButton:SetText(GetTString("Skip"))
			dSkipButton:SetTextColor(Color(255,255,255))

			dSkipButton.DoClick = function()
				start = #scrolls+1
				dProgressBar:Remove()

				if backgroundChannel then
					backgroundChannel:Stop()
					backgroundChannel = nil
				end
			end

			dSkipButton:SetAlpha(0)
			dSkipButton:AlphaTo(
				255,
				10
			)

			dSkipButton.Paint = function(s,w,h)
				draw.RoundedBox(
					3,
					0,0,
					w,h,
					Color(33,33,33,100)
				)
				draw.RoundedBox(
					3,
					3,3,
					w-6,h-6,
					Color(33,33,33,200)
				)
			end
		end
	)

	timer.Simple(
		totalLength,
		function()
			if dProgressBar and IsValid(dProgressBar) then
				dProgressBar:Remove()
			end
		end
	)

	rolling = true

	PlaySound("sound/voice/intro/background.mp3", 0.15)
end

function GM:CalcView( ply, pos, angles, fov )
	if rolling then
		draw.RoundedBox(
			0,
			0,0,
			ScrW(), 15,
			Color(44, 62, 80, 150)
		)

		if start <= #scrolls then
			local s = scrolls[math.ceil(start)]

			if not s then
				start = start + 1
			end

			local cal = (sstart - estart) / send

			if not s.NoEnding and not fadedowntriggered and send - (sstart - estart) <= 4 then
				HUDTriggerFadeDown()
				fadedowntriggered = true
			end

			if not audiotriggered and (sstart - estart) >= 1 then
				PlaySound("sound/voice/intro/part" .. start .. ".mp3", 1)
				-- LocalPlayer():EmitSound("introTalking" .. start)
				audiotriggered = true
				DrawQuestFeedback("models/props_lab/monitor01a.mdl",
					-1, -1,
					s.EndTime - 6,
					s.Text)
				
			end

			if cal >= 1 then
				start = start + 1
				estart = CurTime()
				sstart = CurTime()
				audiotriggered = false
				if not s.NoEnding then
					HUDTriggerFade()
					fadedowntriggered = false
				end

				local nextEnd = scrolls[math.ceil(start)]
				if nextEnd then
					send = nextEnd.EndTime
				end
			end

			sstart = CurTime()

			local view = {}

			view.origin = s.StartVec - (s.StartVec - s.EndVec) * cal / 1.0
			-- pos-( angles:Forward() * -500)
			view.angles = Angle(0, s.StartAng.yaw - (s.StartAng.yaw - s.EndAng.yaw) * cal / 1.0, 0)
			view.fov = fov
			view.drawviewer = true

			return view
		else
			-- We're done
			print ("stopping rolling")
			rolling = false
			if backgroundChannel then
				backgroundChannel:Stop()
			end
			if lastTalking then
				lastTalking:Stop()
			end
			backgroundChannel = nil
			lastTalking = nil
			if dProgressBar and IsValid(dProgressBar) then
				dProgressBar:Remove()
			end
			EnableHud()
		end
	end
end

local dCutScene = nil

local CutSceneFontHeader = surface.CreateFont("CutSceneFontHeader", {
	font = "Arial",
	size = 70,
	weight = 500
})

local CutSceneFontSubHeader = surface.CreateFont("CutSceneFontSubHeader", {
	font = "Arial",
	size = 30,
	weight = 500
})

function RepromptCutScene()
	if IsValid(dCutScene) then
		dCutScene:Remove()
		PromptCutScene(1)
	end
end

function PromptCutScene(cutscene)
	dCutScene = vgui.Create("DPanel")
	dCutScene:SetSize(ScrW(), ScrH())
	dCutScene:Center()
	gui.EnableScreenClicker(true)
	dCutScene:SetKeyboardInputEnabled(true)
	local hh = 450
	local sh = ScrH() / 2 - hh/2
	dCutScene.Paint = function(s,w,h)
		draw.RoundedBox(
			0,
			0,0,
			w,h,
			Color(33,33,33,170)
		)

		draw.RoundedBox(
			0,
			0,sh,
			w,hh,
			Color(33,33,33,230)
		)

		draw.SimpleText(
			GetTString("Watch The Introduction Cut Scene") .. "!",
			"CutSceneFontHeader",
			w/2,sh+15,
			Color(255,255,255),
			TEXT_ALIGN_CENTER
		)

		draw.SimpleText(
			GetTString("No need to call for a trainer and wait 30 minutes") .. "!",
			"CutSceneFontSubHeader",
			w/2,sh+100,
			Color(255,255,255),
			TEXT_ALIGN_CENTER
		)

		draw.SimpleText(
			GetTString("Language") .. ":",
			"CutSceneFontSubHeader",
			w/2-30,sh+160,
			Color(255,255,255),
			TEXT_ALIGN_RIGHT
		)
	end

	local dDropDown = vgui.Create("DComboBox", dCutScene)
	dDropDown:SetSize(100, 30)
	dDropDown:Center()
	dDropDown:SetPos(dDropDown:GetPos() + 30, sh+160)
	dDropDown:SetValue(GetTString("English"), 1)
	dDropDown:AddChoice(GetTString("English"), 1)
	dDropDown.OnSelect = function(s, index, value, data)
		RunConsoleCommand("changelanguage", data)
	end

	local dButton = vgui.Create("DButton", dCutScene)
	dButton:SetSize(600, 200)
	dButton:Center()
	dButton:SetPos(dButton:GetPos(), sh+220)
	dButton:SetFont("CutSceneFontHeader")
	dButton:SetText(GetTString("Play!"))
	dButton:SetTextColor(Color(255,255,255))
	dButton.Paint = function(s,w,h)
		draw.RoundedBox(
			5,
			0,0,
			w,h,
			Color(210,210,210,210)
		)
		draw.RoundedBox(
			5,
			5,5,
			w-10,h-10,
			Color(46, 204, 113)
		)
	end
	dButton.DoClick = function()
		RunConsoleCommand("watchedcutscene")
		dCutScene:Remove()
		gui.EnableScreenClicker(false)
		RollCutscene()
	end
end
