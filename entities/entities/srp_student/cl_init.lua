
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont( "npcs_teacher_name", {
	font 		= "Arial",
	size 		= 36,
	weight 		= 700,
})

surface.CreateFont( "npcs_teacher_title", {
	font 		= "Arial",
	size 		= 22,
	weight 		= 700,
})

surface.CreateFont( "npcs_teacher_mission", {
	font 		= "Arial",
	size 		= 50,
	weight 		= 700,
})

function ENT:Post()
	local dist = self:GetPos():Distance(LocalPlayer():GetPos())

	if dist > 300 then return end

	local angles = self:GetAngles();
	local position = self:GetPos();
	local aboveoffset = angles:Up() * -0 + angles:Forward() * 0 + angles:Right() * 0;

	local alphaStrength = 1 - (dist) / 300
	if alphaStrength < 0 then
		alphaStrength = 0
	end

	angles:RotateAroundAxis(angles:Forward(), 90);
	-- angles:RotateAroundAxis(angles:Right(), LocalPlayer():GetAngles().yaw);
	local eyeang = LocalPlayer():EyeAngles().y - 90 -- Face upwards
	local SpinAng = Angle( 0, eyeang, 90 )

	cam.Start3D2D(position + aboveoffset, SpinAng, 0.2);
		if not IsDoingQuest and self:GetNWBool("QuestOpen") then
			draw.SimpleText(
				"Mission Available",
				"npcs_teacher_mission",
				-0,
				-485,
				Color(155, 89, 182, 255 * alphaStrength),
				1,
				1
			)
		end

		local xpos = 0
		local clique = self:GetNWInt("Clique")
		local cliqueColor = ClientConfig.OverheadGradeColor(self, alphaStrength)

		if clique and ClientConfig.CliqueMats[clique] then
			local x = -16
			if self:GetNWBool("IsLeader") then
				surface.SetDrawColor(Color(241, 196, 15, 255 * alphaStrength))
				surface.SetMaterial(ClientConfig.CliqueMats.Leader)
				surface.DrawTexturedRect(-46, -460, 32, 32)
				x = 0
			end
			surface.SetDrawColor(cliqueColor)
			surface.SetMaterial(ClientConfig.CliqueMats[clique])
			surface.DrawTexturedRect(x, -460, 32, 32)
		end

		draw.SimpleText(
				self:GetNWString("Name"),
				"npcs_teacher_name",
				xpos,
				-410,
				Color(255, 255, 255, 255 * alphaStrength),
				TEXT_ALIGN_CENTER,
				1
			)

		draw.SimpleText(
			self:GetNWString("Title"),
			"npcs_teacher_title",
			-0,
			-375,
			-- Color(142, 68, 173, 255 * alphaStrength),
			cliqueColor,
			1,
			1
		)
	cam.End3D2D();
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:DrawTranslucent()
    self:Post()
end

function ENT:GetClique()
	return self:GetNWInt("Clique", 1)
end
