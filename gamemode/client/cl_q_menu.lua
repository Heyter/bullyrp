
local dQMenu = nil

local CurrentMenu = 3
local dPanel = nil

local movingOut = false
local movingIn = false
local movedIn = true
local movedOut = false

local QMenuInventoryFont = surface.CreateFont("QMenuInventoryFont", {
	font = "Arial",
	size = 16,
	weight = 500
})

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
		Name = GetTString("Inventory"),
		Panel = function(panel, topbar)
			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)
			dPanel.Paint = function(s,w,h) end

			local dUse = vgui.Create("DButton", dPanel)
			dUse:SetSize(140, 40)
			dUse:SetPos(20, dPanel:GetTall() - 50)
			dUse:SetText(GetTString("Use"))
			dUse:SetFont("QMenuCliqueFont")
			dUse.DoClick = function()
			end
			dUse:SetTextColor(Color(255,255,255))
			dUse.Paint = function(s,w,h)
				draw.RoundedBox(
					5,
					0,0,
					w,h,
					Color(39, 174, 96)
				)
			end
			dUse:SetVisible(false)

			local dDrop = vgui.Create("DButton", dPanel)
			dDrop:SetSize(140, 40)
			dDrop:SetPos(dPanel:GetWide() / 2 - dDrop:GetWide() / 2 - 25/2, dPanel:GetTall() - 50)
			dDrop:SetText(GetTString("Drop"))
			dDrop:SetFont("QMenuCliqueFont")
			dDrop.DoClick = function()
			end
			dDrop:SetTextColor(Color(255,255,255))
			dDrop.Paint = function(s,w,h)
				draw.RoundedBox(
					5,
					0,0,
					w,h,
					Color(211, 84, 0)
				)
			end
			dDrop:SetVisible(false)

			local dDestroy = vgui.Create("DButton", dPanel)
			dDestroy:SetSize(140, 40)
			dDestroy:SetPos(dPanel:GetWide() - 170, dPanel:GetTall() - 50)
			dDestroy:SetText(GetTString("Destroy"))
			dDestroy:SetFont("QMenuCliqueFont")
			dDestroy.DoClick = function()
			end
			dDestroy:SetTextColor(Color(255,255,255))
			dDestroy.Paint = function(s,w,h)
				draw.RoundedBox(
					5,
					0,0,
					w,h,
					Color(192, 57, 43)
				)
			end
			dDestroy:SetVisible(false)

			local inventoryLookup = {
				[1] = {
					Name = "Small Package",
					Model = "models/props_interiors/Furniture_chair03a.mdl",
					CamPos = Vector(0, 0, 15),
					CanUse = true,
					CanDrop = true,
				}
			}

			local inventory = {
				[1] = {[1] = 1, [2] = 1},
				[3] = {[1] = 1, [2] = 500},
				[6] = {[1] = 1, [2] = 85},
			}

			local maxInventory = 18

			local dModels = vgui.Create("DScrollPanel", dPanel)
			dModels:SetPos(0, 0)
			dModels:SetSize(dPanel:GetWide()-0, dPanel:GetTall()-60)

			local modelPanel = 1
			local perRow = 5.0
			local clicked = -1

			local panelWide = (dPanel:GetWide() - 20.0) / perRow
			local panelTall = 140

			for i=1,maxInventory do
				local p = (modelPanel - 1)
				local icon = nil

				local dicon = vgui.Create("DPanel", dModels)
				dicon:SetSize(panelWide + 15	, panelTall)
				dicon:SetPos((p % perRow) * panelWide, math.floor(p / perRow) * panelTall)
				dicon.Paint = function(s,w,h)
					if i == clicked or (icon and icon:IsHovered()) or s:IsHovered() then
						draw.RoundedBox(
							0,
							20,15,
							w-40,h,
							Color(44, 62, 80,200)
						)
					else
						draw.RoundedBox(
							0,
							20,15,
							w-40,h,
							Color(22,22,22,200)
						)
					end

					if inventory[i] then
						draw.SimpleText(
							inventoryLookup[inventory[i][1]].Name,
							"QMenuInventoryFont",
							w/2, 20,
							Color(255,255,255),
							TEXT_ALIGN_CENTER,
							TEXT_ALIGN_TOP
						)

						draw.SimpleText(
							inventory[i][2],
							"QMenuInventoryFont",
							w-25, h-5,
							Color(255,255,255),
							TEXT_ALIGN_RIGHT,
							TEXT_ALIGN_BOTTOM
						)
					end
				end

				if inventory[i] then
					icon = vgui.Create( "DModelPanel", dicon )
					icon:SetSize(dicon:GetWide(), dicon:GetTall())
					icon:SetPos(0, 0)
					if inventoryLookup[inventory[i][1]].CamPos then
						icon:SetLookAt(inventoryLookup[inventory[i][1]].CamPos)
					end
					timer.Simple(
						modelPanel * 0.1,
						function()
							if IsValid(icon) then
								icon:SetModel(inventoryLookup[inventory[i][1]].Model)
							end
						end
					)
					function icon:LayoutEntity( Entity ) return end
					icon.DoClick = function()
						if clicked ~= i then
							clicked = i
							if inventoryLookup[inventory[i][1]].CanUse then
								dUse:SetVisible(true)
							else
								dUse:SetVisible(false)
							end
							if inventoryLookup[inventory[i][1]].CanDrop then
								dDrop:SetVisible(true)
							else
								dDrop:SetVisible(false)
							end
							dDestroy:SetVisible(true)
						end
					end
				end

				modelPanel = modelPanel + 1
			end
		end,
	},
	[4] = {
		Name = GetTString("Homework"),
		Panel = function(panel, topbar)
			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)
			dPanel.Paint = function(s,w,h) end
		end,
	},
	[5] = {
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
