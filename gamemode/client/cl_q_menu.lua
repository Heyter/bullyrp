
local dQMenu = nil

local CurrentMenu = 2
local dPanel = nil

local movingOut = false
local movingIn = false
local movedIn = true
local movedOut = false

local QMenuButtonFont = surface.CreateFont("QMenuButtonFont", {
	font = "Arial",
	size = 18,
	weight = 500
})

local QMenuCliqueFont = surface.CreateFont("QMenuCliqueFont", {
	font = "Arial",
	size = 18,
	weight = 750
})

local QMenuScheduleFont = surface.CreateFont("QMenuScheduleFont", {
	font = "Arial",
	size = 22,
	weight = 750
})

local Menus = {
	[1] = {
		Name = GetTString("Grades"),
		Panel = function(panel, topbar)
			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)
			dPanel.Paint = function(s,w,h) end
		end,
	},
	[2] = {
		Name = GetTString("Cliques"),
		Panel = function(panel, topbar)
			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)

			local maxXP = 100

			local cliqueDefaultXPs = {
				[1] = maxXP,
				[2] = maxXP,
				[3] = maxXP,
				[4] = maxXP,
				[5] = maxXP,
				[6] = maxXP,
			}

			local norm = function(x) if x > 100 then return 100 else return x end end

			dPanel.Paint = function(s,w,h)
				local x, y = w/2, h/2
				local seg = #CLIQUES
				local radius = w/5.5

				local cxp = tonumber(databaseGetValue("cliques" .. seg)) or 10
				local a = math.rad( ( (seg - 1) / seg ) * 360 )
				local lastx, lasty = 
							x + math.sin( a ) * (radius * norm(cxp) / maxXP),
							y + math.cos( a ) * (radius * norm(cxp) / maxXP)

				for i=1,seg do
					local cxp = tonumber(databaseGetValue("cliques" .. i)) or 10
					local a = math.rad( ( (i-1) / seg ) * 360 )
					local newx, newy =
							x + math.sin( a ) * (radius * norm(cxp) / maxXP),
							y + math.cos( a ) * (radius * norm(cxp) / maxXP)
					local c = ClientConfig.GetCliqueColor(i)
					c.a = 100
					surface.SetDrawColor(c)
					draw.NoTexture()
					-- This draws just a line going from center to each
					-- surface.DrawLine(
					-- 	x,
					-- 	y,
					-- 	newx,
					-- 	newy
					-- )
					-- This draws a hexagon
					-- surface.DrawLine(
					-- 	lastx,
					-- 	lasty,
					-- 	newx,
					-- 	newy
					-- )
					-- This draws a piechart hexgon colored in thing
					surface.DrawPoly({
						{x = lastx, y = lasty},
						{x = x, y = y},
						{x = newx, y = newy},
					})
					surface.DrawCircle(newx, newy, 3, c)
					lastx, lasty = newx, newy
				end

				local a = math.rad( ( (seg - 1) / seg ) * 360 )
				local lastx, lasty = 
							x + math.sin( a ) * (radius * cliqueDefaultXPs[seg] / maxXP),
							y + math.cos( a ) * (radius * cliqueDefaultXPs[seg] / maxXP)

				for i=1,seg do
					local a = math.rad( ( (i-1) / seg ) * 360 )
					local newx, newy =
							x + math.sin( a ) * (radius * cliqueDefaultXPs[i] / maxXP),
							y + math.cos( a ) * (radius * cliqueDefaultXPs[i] / maxXP)
					local newxText, newyText =
							x + math.sin( a ) * (radius + 40),
							y + math.cos( a ) * (radius + 40)

					local c = ClientConfig.GetCliqueColor(i)
					c.a = 20
					surface.SetDrawColor(c)
					surface.DrawLine(
						lastx,
						lasty,
						newx,
						newy
					)
					surface.DrawCircle(newx, newy, 3, c)

					local align = TEXT_ALIGN_RIGHT
					if i == 1 or i == 4 then
						align = TEXT_ALIGN_CENTER
					elseif a < math.pi then
						align = TEXT_ALIGN_LEFT
					end

					c.a = 150
					local cxp = tonumber(databaseGetValue("cliques" .. i)) or 10
					draw.SimpleText(
						CLIQUES[i].GroupName .. " (" .. cxp .. ")",
						"QMenuCliqueFont",
						newxText,
						newyText,
						c,
						align
					)
					lastx, lasty = newx, newy
				end
			end
		end,
	},
	[3] = {
		Name = GetTString("Homework"),
		Panel = function(panel, topbar)
			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)
			dPanel.Paint = function(s,w,h) end
		end,
	},
	[4] = {
		Name = GetTString("Schedule"),
		Panel = function(panel, topbar)
			local padding = 20
			dPanel = vgui.Create("RichText", panel)
			dPanel:SetPos(padding,topbar+padding)
			dPanel:SetSize(panel:GetWide()-padding*2, panel:GetTall() - topbar-padding*2)
			function dPanel:PerformLayout()
				self:SetFontInternal( "QMenuScheduleFont" )
			end
			dPanel:DockPadding(10,10,10,10)
			for k,v in pairs(databaseGetValue("schedule") or {}) do
				dPanel:AppendText(GetTString("Class") .. " " .. k .. ":\n")

				local c = CLASSES[v]
				dPanel:AppendText(" - " .. GetTString("Name") .. ": " .. c.Name .. "\n")
				dPanel:AppendText(" - " .. GetTString("Room") .. ": " .. c.Room .. "\n")
				dPanel:AppendText(" - " .. GetTString("Subject") .. ": " .. c.Subject .. "\n")

				dPanel:AppendText("\n")
			end
		end,
	},
}

local topbar = 50

local function DrawQMenu()
	local W,H = ScrW(), ScrH()
	local w,h = 700, 450

	dQMenu = vgui.Create("DPanel")
	dQMenu:SetSize(w, h)
	dQMenu:Center()
	dQMenu:MakePopup()
	dQMenu:SetKeyboardInputEnabled(false)

	dQMenu.Paint = function(s,w,h)
		draw.RoundedBox(
			1,
			0,topbar,
			w,h-topbar,
			Color(33,33,33,250)
		)
	end

	local len = #Menus
	local padding = 10
	local bw, bh = math.ceil(dQMenu:GetWide() / len), topbar

	for k,v in pairs(Menus) do
		local dButton = vgui.Create("DButton", dQMenu)
		dButton:SetPos((k - 1) * bw, 0)
		dButton:SetSize(bw, bh)
		dButton:SetFont("QMenuButtonFont")
		dButton:SetText(v.Name)
		dButton.Paint = function(s,w,h)
			if k == CurrentMenu or s:IsHovered() then
				draw.RoundedBox(
					1,
					0,0,
					w,h,
					Color(41, 128, 185, 230)
				)
			else
				draw.RoundedBox(
					1,
					0,0,
					w,h,
					Color(44, 62, 80, 230)
				)
			end
		end
		dButton.DoClick = function()
			if IsValid(dPanel) then
				dPanel:Remove()
			end
			Menus[k].Panel(dQMenu, topbar)
			CurrentMenu = k
		end
		dButton:SetTextColor(Color(255,255,255))
	end

	Menus[CurrentMenu].Panel(dQMenu, topbar)

	movingOut = true

	dQMenu:SetVisible(true)
	dQMenu:SetAlpha(0)
	dQMenu:AlphaTo(255, 0.25, 0, function()
		movingOut = false
		movedOut = true
		movedIn = false
	end)
end

function GM:OnSpawnMenuOpen()
	if IsValid(dQMenu) then
		if not movingOut and not movingIn then
			if movedIn then
				movingOut = true
				
				if IsValid(dPanel) then
					dPanel:Remove()
				end
				Menus[CurrentMenu].Panel(dQMenu, topbar)

				dQMenu:SetVisible(true)
				dQMenu:SetAlpha(0)
				dQMenu:AlphaTo(255, 0.25, 0, function()
					movingOut = false
					movedOut = true
					movedIn = false
				end)
			else
				movingIn = true
				dQMenu:AlphaTo(0, 0.25, 0, function()
					movingIn = false
					movedOut = false
					movedIn = true
					dQMenu:SetVisible(false)
				end)
			end
		end
	else
		DrawQMenu()
	end
end

function GM:OnSpawnMenuClose()
	if IsValid(dQMenu) then
		if not movingOut and not movingIn and movedOut then
			movingIn = true
			dQMenu:AlphaTo(0, 0.25, 0, function()
				movingIn = false
				movedIn = true
				movedOut = false
				dQMenu:SetVisible(false)
			end)
		end
	end
end
