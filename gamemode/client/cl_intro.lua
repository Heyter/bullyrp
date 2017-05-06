
local Roll = true

local scrolls = {
	-- high school front
	[1] = {
		StartVec = Vector(-872.704834, -2351.010742, 642.994019),
		StartAng = Angle(6.562334, 80.893242, 0.000000),
		EndVec = Vector(646.259338, -2257.489014, 494.649048),
		EndAng = Angle(0.860590, 104.238182, 0.000000),
		EndTime = 7,
	},
-- 	-- high school lobby
	[2] = {
		StartVec = Vector(-265.943115, 336.700470, 163.192047),
		StartAng = Angle(7.100227, 120.698029, 0.000000),
		EndVec = Vector(199.733078, -125.496880, 627.423401),
		EndAng = Angle(-6.347269, -14.099856, 0.000000),
		EndTime = 9,
	},

	-- detention
	[3] = {
		StartVec = Vector(265.777771, 295.117310, 169.332947),
		StartAng = Angle(2.797026, -154.595306, 0.000000),
		EndVec = Vector(-561.208, -148.964, 160.62),
		EndAng = Angle(2.797026, -160, 0.000000),
		EndTime = 14,
		NoEnding = true
	},

	-- counselor
	[4] = {
		StartVec = Vector(-561.208, -148.964, 160.62),
		StartAng = Angle(2.797026, -160, 0.000000),
		EndVec = Vector(-1286.223, -148.1, 150.32),
		EndAng = Angle(1.152, -111.413, 0.0),
		EndTime = 13,
		NoEnding = true
	},

	-- lockers
	[5] = {
		StartVec = Vector(-1286.223, -148.1, 150.32),
		StartAng = Angle(1.152, -111.413, 0.0),
		EndVec = Vector(-1556.096, 950.77, 162.254),
		EndAng = Angle(5.24, -34.994, 0.0),
		EndTime = 19,
	},

	-- lunch room
	[6] = {
		StartVec = Vector(-3813.924, -241.57, 140.605),
		StartAng = Angle(1.69, 83.201, 0.0),
		EndVec = Vector(-5135.938, 1484.186, 145.726),
		EndAng = Angle(-4.119, 45.645+150, 0.0),
		EndTime = 15,
	},

	-- library front
	[7] = {
		StartVec = Vector(1813.608, 3638.754, 368.851),
		StartAng = Angle(0.829, 64.592, 0.0),
		EndVec = Vector(3754.309, 3671.178, 373.478),
		EndAng = Angle(-1.753, 124.944, 0.0),
		EndTime = 11,
	},

	-- Inside of library
	[8] = {
		StartVec = Vector(3883.408, 4776.128, 441.34),
		StartAng = Angle(5.348, 156.933, 0.0),
		EndVec = Vector(1793.257, 5335.401, 271.205),
		EndAng = Angle(-6.271, -34.92+180, 0.0),
		EndTime = 10,
	},

	-- Media center front
	[9] = {
		StartVec = Vector(-2946.593, 3655.483, 150.732),
		StartAng = Angle(3.035, 79.335, 0.0),
		EndVec = Vector(-2772.926, 5132.631, 150.875),
		EndAng = Angle(2.604, -16.411, 0.0),
		EndTime = 14,
		NoEnding = true
	},

	-- Media center inside
	[10] = {
		StartVec = Vector(-2772.926, 5132.631, 150.875),
		StartAng = Angle(2.604, -16.411, 0.0),
		EndVec = Vector(-2242.9, 4489.154, 150.941),
		EndAng = Angle(9.92, -176.813, 0.0),
		EndTime = 17,
	},

	-- Gym front
	[11] = {
		StartVec = Vector(16.001, 5550.568, 104.069),
		StartAng = Angle(-2.022, 90.814, 0.0),
		EndVec = Vector(3.949, 8051.819, 46.078),
		EndAng = Angle(3.68, 91.029, 0.0),
		EndTime = 14,
		NoEnding = true
	},

	-- gym around
	[12] = {
		StartVec = Vector(3.949, 8051.819, 46.078),
		StartAng = Angle(3.68, 91.029, 0.0),
		EndVec = Vector(349.602, 8164.182, 56.614),
		EndAng = Angle(-1.699, 270.336, 0.0),
		EndTime = 8,
	},

	-- Soccer field
	[13] = {
		StartVec = Vector(-3.439, 8577.254, 304.578),
		StartAng = Angle(8.521, 90.781, 0.0),
		EndVec = Vector(-1793.956, 11886.974, 83.036),
		EndAng = Angle(6.692, -32.021, 0.0),
		EndTime = 15,
	},

	-- dorms front
	[14] = {
		StartVec = Vector(3040.489, 1620.495, 575.924),
		StartAng = Angle(9.059, -32.075, 0.0),
		EndVec = Vector(4189.798, 391.881, 160.829),
		EndAng = Angle(-0.623, -3.566, 0.0),
		EndTime = 13,
		NoEnding = true
	},

	-- dorms inside lower
	[15] = {
		StartVec = Vector(4189.798, 391.881, 160.829),
		StartAng = Angle(-0.623, -3.566, 0.0),
		EndVec = Vector(4965.035, 322.717, 300.387),
		EndAng = Angle(0.991, 141.129, 0.0),
		EndTime = 9,
		NoEnding = true
	},

	-- dorms inside upper
	[16] = {
		StartVec = Vector(4965.035, 322.717, 300.387),
		StartAng = Angle(0.991, 141.129, 0.0),
		EndVec = Vector(4969.066, 269.364, 397.825),
		EndAng = Angle(2.604, 203.463, 0.0),
		EndTime = 11,
	},

	-- pan back high school
	[17] = {
		StartVec = Vector(-42.968, 5096.783, 252.974),
		StartAng = Angle(-0.408, -62.627, 0.0),
		EndVec = Vector(92.366, 2454.309, 160.231),
		EndAng = Angle(-0.193, -132.339, 0.0),
		EndTime = 32,
	},

	-- Library desks
	[18] = {
		StartVec = Vector(2095.004, 5116.858, 198.139),
		StartAng = Angle(6.477, 10.354, 0.0),
		EndVec = Vector(3284.312, 5384.925, 180.487),
		EndAng = Angle(4.11, -59.358, 0.0),
		EndTime = 8,
	},

	-- school 2nd floor
	[19] = {
		StartVec = Vector(548.169, 624.042, 400.586),
		StartAng = Angle(-2.559, -123.583, 0.0),
		EndVec = Vector(-541.257, 552.119, 420.838),
		EndAng = Angle(-1.269, -53.763, 0.0),
		EndTime = 8,
	},

	-- front court yard
	[20] = {
		StartVec = Vector(-412.824, -2707.294, 262.026),
		StartAng = Angle(22.937, 55.463, 0.0),
		EndVec = Vector(560.017, -2774.52, 339.573),
		EndAng = Angle(19.064, 132.168, 0.0),
		EndTime = 8,
	},

	-- back cafe
	[21] = {
		StartVec = Vector(-3821.609, -40.514, 195.634),
		StartAng = Angle(11.426, 136.799, 0.0),
		EndVec = Vector(-5358.379, -245.003, 338.381),
		EndAng = Angle(40.472, 120.34, 0.0),
		EndTime = 8,
	},

	-- down soccer field
	[22] = {
		StartVec = Vector(-1511.635, 10361.201, -55.729),
		StartAng = Angle(8.629, 13.513, 0.0),
		EndVec = Vector(966.075, 11489.856, -111.222),
		EndAng = Angle(10.673, -95.143, 0.0),
		EndTime = 8,
	},

	-- ending fly by front 
	[23] = {
		StartVec = Vector(1738.464, -2268.177, 300.093),
		StartAng = Angle(-4.819, 156.528, 0.0),
		EndVec = Vector(-10.647, -982.497, 100.031),
		EndAng = Angle(-10.198, 90.044, 0.0),
		EndTime = 13,
	},
}

-- for k,v in pairs(scrolls) do
-- 	sound.Add({
-- 		name = "introTalking" .. k,
-- 		channel = CHAN_STATIC,
-- 		volume = 0.8,
-- 		level = 80,
-- 		sound = "sound/voice/intro/part" .. k .. ".mp3"
-- 	})
-- end

function PlaySound(track, level)
    sound.PlayFile(track, "", function(channel, error, errorName)
        if (IsValid(channel)) then
            channel:Play()
            channel:SetVolume(level)
        end
    end)
end

local start = 1
local estart = CurTime()
local send = scrolls[1].EndTime
local fadedowntriggered = false
local audiotriggered = false

local sstart = CurTime()

HUDTriggerFade()

PlaySound("sound/voice/intro/background.mp3", 0.025)

timer.Simple(
	228,
	function()
		PlaySound("sound/voice/intro/background.mp3", 0.025)
	end
)

timer.Simple(
	228 * 2,
	function()
		PlaySound("sound/voice/intro/background.mp3", 0.025)
	end
)

function GM:CalcView( ply, pos, angles, fov )
	-- return false
	if start <= #scrolls then
		local s = scrolls[math.ceil(start)]

		local cal = (sstart - estart) / send

		if not s.NoEnding and not fadedowntriggered and send - (sstart - estart) <= 4 then
			HUDTriggerFadeDown()
			fadedowntriggered = true
		end

		if not audiotriggered and (sstart - estart) >= 1 then
			PlaySound("sound/voice/intro/part" .. start .. ".mp3", 1)
			-- LocalPlayer():EmitSound("introTalking" .. start)
			audiotriggered = true
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
	end

end
