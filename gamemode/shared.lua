
GM.Name = "BullyRP"
GM.Author = "Fifteen"
GM.Email = "NA"
GM.Website = "NA"

-- In seconds
LengthOfDay = 2160.0 --2160.0
-- There are 5 periods.
NumberOfPeriods = 5

SecondsInDay = 86400.0
SecondsInHalfDay = 86400.0 / 2

CalcSecond = 1.0 / SecondsInDay * LengthOfDay
CalcMinute = CalcSecond * 60.0
CalcHour = CalcMinute * 60.0

-- In ingame minutes
LengthOfPeriodInGame = 60
PeriodIntermissionInGame = 30

-- Start school at 7:00 AM
SchoolStarts = 7 * 60
-- Start Day 1 at 6:50 AM
StartAtTime = 60 * 7 - 10
-- Start Day 1 at 12:00 AM
-- StartAtTime = 0

LengthOfPeriod = CalcMinute * LengthOfPeriodInGame
PeriodIntermission = CalcMinute * PeriodIntermissionInGame

function IsCurfew()
	return CurrentDayHour > 22 or CurrentDayHour < 5.5
end

WHITE = Color(255,255,255)
GREY1 = Color(50,50,50, 150)
GREY2 = Color(33,33,33, 150)
GREEN1 = Color(39, 174, 96, 255)
RED1 = Color(192, 57, 43)
YELLOW1 = Color(243, 156, 18)
SEA1 = Color(22, 160, 133)
BLUE1 = Color(41, 128, 185)

CliqueColorMap = {
	Nerd = GREEN1,
	Bully = RED1,
	Preppy = YELLOW1,
	Burnout = BLUE1,
	Jock = SEA1
}

function GetCliqueColor(clique)
	local clique = clique
	local c = WHITE

	if CLIQUES and CLIQUES[clique] then
		clique = CLIQUES[clique]
		if CliqueColorMap[clique.Name] then
			c = CliqueColorMap[clique.Name]
		end
	end

	return Color(c.r, c.g, c.b)
end

function GetGrade(g)
	local grade = g .. "th " .. GetTString("Grader")

	if g == 9 then
		grade = GetTString("Freshman")
	elseif g == 10 then
		grade = GetTString("Sophomore")
	elseif g == 11 then
		grade = GetTString("Junior")
	elseif g == 12 then
		grade = GetTString("Senior")
	end

	return grade
end
