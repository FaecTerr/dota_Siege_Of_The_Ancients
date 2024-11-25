modifier_teleport_controlled_units = class({})

LinkLuaModifier( "modifier_teleport_controlled_units", "modifiers/modifier_teleport_controlled_units", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_teleport_controlled_units_buff", "modifiers/modifier_teleport_controlled_units", LUA_MODIFIER_MOTION_NONE )

function modifier_teleport_controlled_units:IsDebuff() return false end
function modifier_teleport_controlled_units:IsPurgable() return false end
function modifier_teleport_controlled_units:RemoveOnDeath() return false end
function modifier_teleport_controlled_units:IsPermanent() return true end
function modifier_teleport_controlled_units:IsHidden() return true end

function modifier_teleport_controlled_units:OnCreated( kv )
    	self.regenCountdown = 0
		self.disabled = false        	
		self:StartIntervalThink(0.2)
end

function modifier_teleport_controlled_units:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TELEPORTED,
	}
	return funcs
end


function modifier_teleport_controlled_units:OnIntervalThink()
  	local parent = self:GetParent()

end

function modifier_teleport_controlled_units:GetTexture()
	return "modifier_teleport_controlled_units"
end


function modifier_teleport_controlled_units:OnTeleported(event)
    local parent = self:GetParent()
   	local unit = event.unit
   	local origin = parent:GetAbsOrigin()
   	
   	if unit == parent then
   		--GetPlayerOwner
   		local units = Entities:FindAllByClassname("npc_dota_broodmother_spiderling")
		parent:AddNewModifier(parent, nil, "modifier_teleport_controlled_units_buff", { duration = 8.0 })
		for _,unit in pairs(units) do
			unit:SetAbsOrigin(origin)
			unit:AddNewModifier(parent, nil, "modifier_teleport_controlled_units_buff", { duration = 8.0 })
		end	
   	end
end

--------------------------------------------------------------------------------

modifier_teleport_controlled_units_buff = class({})

function modifier_teleport_controlled_units_buff:RemoveOnDeath() return true end
function modifier_teleport_controlled_units_buff:IsHidden() return true end
function modifier_teleport_controlled_units_buff:IsPurgable() return false end
function modifier_teleport_controlled_units_buff:IsPurgeException() return false end

function modifier_teleport_controlled_units_buff:OnCreated( kv )   	
	self:StartIntervalThink(0.4)
end

function modifier_teleport_controlled_units_buff:OnIntervalThink( kv )   	
	local parent = self:GetParent()

end

function modifier_teleport_controlled_units_buff:CheckState()
	local state = {}
		state[MODIFIER_STATE_NO_UNIT_COLLISION]			 = true
	return state
end













