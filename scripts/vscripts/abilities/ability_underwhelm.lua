ability_underwhelm = class({})

LinkLuaModifier( "modifier_underwhelm", "abilities/ability_underwhelm", LUA_MODIFIER_MOTION_NONE )

function ability_underwhelm:GetIntrinsicModifierName()
    return "modifier_underwhelm"
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_underwhelm = class({})

function modifier_underwhelm:IsDebuff() return false end
function modifier_underwhelm:IsHidden() return true end
function modifier_underwhelm:IsPurgable() return false end
function modifier_underwhelm:IsPurgeException() return false end
function modifier_underwhelm:RemoveOnDeath() return false end
function modifier_underwhelm:IsPermanent() return true end
function modifier_underwhelm:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_underwhelm:OnCreated()
	self.overwhelm = 0
	self:StartIntervalThink(0.05)
    self:SetHasCustomTransmitterData(true)
end

function modifier_underwhelm:OnIntervalThink()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local team = parent:GetTeamNumber()
    
    if not IsServer() then return end
    
    local enemies1 = FindUnitsInRadius(team, parent:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("AbilityAoE"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, true)
    local enemies2 = FindUnitsInRadius(team, parent:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("AbilityAoE"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, true)
    
    local enemies = #enemies1 * 3 + #enemies2
    
    self.overwhelm = enemies    
	self:SendBuffRefreshToClients()
end

function modifier_underwhelm:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_underwhelm:GetModifierPhysicalArmorBonus()
	return self.overwhelm * self:GetAbility():GetSpecialValueFor("Armor")
end

function modifier_underwhelm:GetModifierAttackSpeedBonus_Constant()
	return self.overwhelm * self:GetAbility():GetSpecialValueFor("AttackSpeed")
end


function modifier_underwhelm:AddCustomTransmitterData()
    return {
        overwhelm = self.overwhelm
    }
end

function modifier_underwhelm:HandleCustomTransmitterData( data )
    self.overwhelm = data.overwhelm
end

