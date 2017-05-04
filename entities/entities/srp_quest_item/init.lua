
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/monk.mdl" )
	self:SetTrigger(true)
	player:SetCustomCollisionCheck( true )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end
	self.shouldShow = true
end

function ENT:SetNWItem(itemID)
	self:SetNWInt("itemID", itemID)
end

function ENT:SetPlayer(ply)
	self.playerToWatch = ply
	self:SetNWEntity("Player", ply)
end

function ENT:AltModel(model)
	self:SetModel(model)
end

function ENT:StartTouch(ent)
	print ("Starting touch!!!")
	if self.shouldShow and ent and IsValid(ent) and ent:IsPlayer() and ent.HasQuest and ent == self.playerToWatch then
		ProcessQuestComplete(ent)
		self.shouldShow = false
		self:Remove()
	end
end
