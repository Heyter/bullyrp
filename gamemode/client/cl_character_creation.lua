
local dCharacterCreation = nil

local CurrentMenu = 1
local dPanel = nil

local firstName = nil
local lastName = nil
local model = nil
local schedule = databaseGetValue("schedule") or {}

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

local function SubmitChanges()
	net.Start("update_character")
		net.WriteTable({
			firstName = firstName,
			lastName = lastName,
			model = model,
			schedule = schedule,
		})
	net.SendToServer()
end

local Menus = {
	[1] = {
		Name = "Name",
		Panel = function(panel, topbar)
			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)
			dPanel.Paint = function(s,w,h)
				draw.SimpleText(
					"First Name:",
					"QMenuScheduleFont",
					30,30
				)

				draw.SimpleText(
					"First Name:",
					"QMenuScheduleFont",
					30,120
				)
			end

			if not firstName then
				firstName = LocalPlayer():GetNWString("firstName")
			end

			if not lastName then
				lastName = LocalPlayer():GetNWString("lastName")
			end

			local dFirstName = vgui.Create( "DTextEntry", dPanel)
			dFirstName:SetSize(300, 40)
			dFirstName:SetPos(30, 60)
			dFirstName:SetText(firstName)
			dFirstName:SetFont("QMenuButtonFont")
			dFirstName:SetUpdateOnType(true)
			dFirstName.OnValueChange = function()
				firstName = string.sub(dFirstName:GetValue(), 1, 15):gsub('%W.','')
			end

			local dLastName = vgui.Create( "DTextEntry", dPanel)
			dLastName:SetSize(300, 40)
			dLastName:SetPos(30, 150)
			dLastName:SetText(lastName)
			dLastName:SetFont("QMenuButtonFont")
			dLastName:SetUpdateOnType(true)
			dLastName.OnValueChange = function()
				lastName = string.sub(dLastName:GetValue(), 1, 15):gsub('%W.','')
			end

			local dFinished = vgui.Create("DButton", dPanel)
			dFinished:SetSize(140, 40)
			dFinished:SetPos(dPanel:GetWide() - 145, dPanel:GetTall() - 45)
			dFinished:SetText("Finished!")
			dFinished:SetFont("QMenuCliqueFont")
			dFinished.DoClick = function()
				SubmitChanges()
				CloseCharacterCreation()
			end
			dFinished:SetTextColor(Color(255,255,255))
			dFinished.Paint = function(s,w,h)
				draw.RoundedBox(
					5,
					0,0,
					w,h,
					Color(39, 174, 96)
				)
			end
		end,
	},
	[2] = {
		Name = "Player Model",
		Panel = function(panel, topbar)
			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)
			dPanel.Paint = function(s,w,h) end

			local dModels = vgui.Create("DScrollPanel", dPanel)
			dModels:SetPos(0, 0)
			dModels:SetSize(dPanel:GetWide()-0, dPanel:GetTall()-60)

			local modelPanel = 1
			local nameMode = databaseGetValue("model")
			local perRow = 3

			local panelWide = (dPanel:GetWide() - 10) / perRow

			for i=1,#STUDENT_PLAYER_MODELS do
				for k,v in pairs(STUDENT_PLAYER_MODELS[i]) do
					if not model and nameMode == v then
						model = i.."."..k
					end

					local p = (modelPanel - 1)
					local dicon = vgui.Create("DPanel", dModels)
					dicon:SetSize(panelWide, panelWide)
					dicon:SetPos((p % perRow) * panelWide, math.floor(p / perRow) * panelWide)
					dicon.Paint = function(s,w,h)
						if model == i.."."..k then
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
								Color(0,0,0,200)
							)
						end
					end

					local icon = vgui.Create( "DModelPanel", dicon )
					icon:SetSize(dicon:GetWide(), dicon:GetTall())
					icon:SetPos(0, 0)
					timer.Simple(
						modelPanel * 0.25,
						function()
							if IsValid(icon) then
								icon:SetModel(v)
							end
						end
					)
					function icon:LayoutEntity( Entity ) return end
					icon.DoClick = function()
						if model ~= i.."."..k then
							model = i.."."..k
						end
					end

					modelPanel = modelPanel + 1
				end
			end

			local dFinished = vgui.Create("DButton", dPanel)
			dFinished:SetSize(140, 40)
			dFinished:SetPos(dPanel:GetWide() - 145, dPanel:GetTall() - 45)
			dFinished:SetText("Finished!")
			dFinished:SetFont("QMenuCliqueFont")
			dFinished.DoClick = function()
				SubmitChanges()
				CloseCharacterCreation()
			end
			dFinished:SetTextColor(Color(255,255,255))
			dFinished.Paint = function(s,w,h)
				draw.RoundedBox(
					5,
					0,0,
					w,h,
					Color(39, 174, 96)
				)
			end
		end,
	},
	[3] = {
		Name = "Schedule",
		Panel = function(panel, topbar)
			local psch = POSSIBLE_SCHEDULES[9]

			dPanel = vgui.Create("DPanel", panel)
			dPanel:SetPos(0,topbar)
			dPanel:SetSize(panel:GetWide(), panel:GetTall() - topbar)
			dPanel.Paint = function(s,w,h)
				for i=1,#psch do
					draw.SimpleText(
						"Class " .. i .. ":",
						"QMenuScheduleFont",
						w/2-60, (i - 1) * 50 + 40,
						Color(255,255,255),
						TEXT_ALIGN_RIGHT,
						TEXT_ALIGN_CENTER
					)
				end
			end

			for i=1,#psch do
				local dDropDown = vgui.Create("DComboBox", dPanel)
				dDropDown:SetSize(250, 40)
				dDropDown:Center()
				dDropDown:SetPos(dDropDown:GetPos() + dDropDown:GetWide()/3, (i - 1) * 50 + 20)
				dDropDown:SetFont("QMenuScheduleFont")

				if schedule[i] then
					print(schedule[i])
					dDropDown:SetValue(CLASSES[schedule[i]].Name, schedule[i])
				else
					dDropDown:SetValue(CLASSES[psch[i][1]].Name, psch[i][1])
				end

				for j=1,#psch[i] do
					dDropDown:AddChoice(CLASSES[psch[i][j]].Name, psch[i][j])
				end

				dDropDown.OnSelect = function(s, index, value, data)
					schedule[i] = data
				end
			end

			local dFinished = vgui.Create("DButton", dPanel)
			dFinished:SetSize(140, 40)
			dFinished:SetPos(dPanel:GetWide() - 145, dPanel:GetTall() - 45)
			dFinished:SetText("Finished!")
			dFinished:SetFont("QMenuCliqueFont")
			dFinished.DoClick = function()
				SubmitChanges()
				CloseCharacterCreation()
			end
			dFinished:SetTextColor(Color(255,255,255))
			dFinished.Paint = function(s,w,h)
				draw.RoundedBox(
					5,
					0,0,
					w,h,
					Color(39, 174, 96)
				)
			end
		end,
	},
}

local topbar = 50

local function DrawCharacterCreation()
	local W,H = ScrW(), ScrH()
	local w,h = 700, 450

	dCharacterCreation = vgui.Create("DFrame")
	dCharacterCreation:SetSize(w, h)
	dCharacterCreation:Center()
	dCharacterCreation:MakePopup()
	dCharacterCreation:SetTitle("")
	dCharacterCreation:ShowCloseButton(false)

	dCharacterCreation.Paint = function(s,w,h)
		draw.RoundedBox(
			1,
			0,topbar,
			w,h-topbar,
			Color(33,33,33,250)
		)
	end

	local len = #Menus
	local padding = 10
	local bw, bh = math.ceil(dCharacterCreation:GetWide() / len), topbar

	for k,v in pairs(Menus) do
		local dButton = vgui.Create("DButton", dCharacterCreation)
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
			Menus[k].Panel(dCharacterCreation, topbar)
			CurrentMenu = k
		end
		dButton:SetTextColor(Color(255,255,255))
	end

	schedule = databaseGetValue("schedule") or {}

	Menus[CurrentMenu].Panel(dCharacterCreation, topbar)

	movingOut = true

	dCharacterCreation:SetVisible(true)
	dCharacterCreation:SetAlpha(0)
	dCharacterCreation:AlphaTo(255, 0.25, 0, function()
		movingOut = false
		movedOut = true
		movedIn = false
	end)
end

function CloseCharacterCreation()
	if IsValid(dCharacterCreation) then
		if not movingOut and not movingIn and movedOut then
			movingIn = true
			dCharacterCreation:AlphaTo(0, 0.25, 0, function()
				movingIn = false
				movedIn = true
				movedOut = false
				dCharacterCreation:SetVisible(false)
			end)
		end
	end
end

function OpenCharacterCreation()
	if IsValid(dCharacterCreation) then
		dCharacterCreation:Remove()
	end
	dCharacterCreation = nil

	DrawCharacterCreation()
end
