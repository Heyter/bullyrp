
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont( "quest_item_name", {
	font 		= "Arial",
	size 		= 40,
	weight 		= 700,
})

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function ENT:Post()
	local dist = self:GetPos():Distance(LocalPlayer():GetPos())

	if dist > 250 then return end

	local ply = self:GetNWEntity("Player")

	if not ply or not IsValid(ply) then return end

	local firstName = "Barack"
	local lastName = "Obama"

	if ply:GetNWString("firstName") ~= "" then
		firstName = ply:GetNWString("firstName")
	end

	if ply:GetNWString("lastName") ~= "" then
		lastName = ply:GetNWString("lastName")
	end

	local angles = self:GetAngles();
	local position = self:GetPos();
	local aboveoffset = angles:Up() * -0 + angles:Forward() * 0 + angles:Right() * 0;

	local alphaStrength = 1 - (dist) / 250
	if alphaStrength < 0 then
		alphaStrength = 0
	end

	angles:RotateAroundAxis(angles:Forward(), 90);
	-- angles:RotateAroundAxis(angles:Right(), LocalPlayer():GetAngles().yaw);
	local eyeang = LocalPlayer():EyeAngles().y - 90 -- Face upwards
	local SpinAng = Angle( 0, eyeang, 90 )

	cam.Start3D2D(position + aboveoffset, SpinAng, 0.2);
		draw.SimpleText(
			firstName .. " " .. lastName,
			"quest_item_name",
			-0,
			-200 + self.delta * 10,
			Color(255, 255, 255, 255 * alphaStrength),
			1,
			1
		)
	cam.End3D2D();

	cam.Start3D2D(self.spos + Vector(0,0,-15), Angle(0,0,0), 1);
		surface.SetDrawColor(41, 128, 185, 75 * alphaStrength )
		draw.NoTexture()
		draw.Circle(0, 0, 20, 10)
	cam.End3D2D()
end

function ENT:Draw()
	self.delta = math.sin(CurTime() * 2)
	self:SetPos(self.spos + Vector(0, 0, self.delta * 10))
	self:SetAngles(Angle(0,CurTime() * 10, 0))
    self:DrawModel()
end

function ENT:DrawTranslucent()
    self:Post()
end

function ENT:Initialize()
	self.spos = self:GetPos()
	-- if LocalPlayer() ~= self:GetNWEntity("Player") then
	-- 	self:SetMaterial("models/wireframe", true)
	-- 	self:SetColor(Color(41, 128, 185))
	-- end
end

function ENT:GetPlayer()
	return self:GetNWEntity("Player")
end
