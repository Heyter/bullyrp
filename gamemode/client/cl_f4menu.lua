
local dF4 = nil

local movingOut = false
local movingIn = false
local movedIn = true
local movedOut = false

local function DrawF4()
	local W,H = ScrW(), ScrH()
	local w,h = W * 0.75, H * 0.75
	local topHeight = 50

	dF4 = vgui.Create("DFrame")
	dF4:SetSize(w, h)
	dF4:SetTitle(ClientConfig.F4URL)
	dF4:Center()
	dF4:MakePopup()

	dF4.Paint = function(s,w,h)
		draw.RoundedBox(
			5,
			0,0,
			w,h,
			Color(33,33,33,230)
		)
	end

	local html = vgui.Create( "HTML", dF4 )
	html:Dock( FILL )
	html:OpenURL( ClientConfig.F4URL )

	movingOut = true
				
	dF4:SetVisible(true)
	dF4:SetAlpha(0)
	dF4:AlphaTo(255, 0.25, 0, function()
		movingOut = false
		movedOut = true
		movedIn = false
	end)
end

function OpenF4( ply, bind, pressed )
    if ( bind == "gm_showspare2" ) then 
		if IsValid(dF4) then
			if not movingOut and not movingIn then
				if movedIn then
					movingOut = true
					
					dF4:SetVisible(true)
					dF4:SetAlpha(0)
					dF4:AlphaTo(255, 0.25, 0, function()
						movingOut = false
						movedOut = true
						movedIn = false
					end)
				else
					movingIn = true
					dF4:AlphaTo(0, 0.25, 0, function()
						movingIn = false
						movedOut = false
						movedIn = true
						dF4:SetVisible(false)
					end)
				end
			end
		else
			DrawF4()
		end 
	end
end

hook.Add("PlayerBindPress", "OpenF4", OpenF4)
