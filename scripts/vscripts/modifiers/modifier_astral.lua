modifier_astral = class({})

function modifier_astral:IsDebuff() return false end
function modifier_astral:IsPurgable() return false end
function modifier_astral:RemoveOnDeath() return false end
function modifier_astral:IsPermanent() return true end
function modifier_astral:IsHidden() return true end

function modifier_astral:OnCreated( kv )   	
		--self:StartIntervalThink(0.2)
	local parent = self:GetParent()
	if parent ~= nil and IsServer() then
		parent:AddNoDraw()
	end
end

function modifier_astral:OnDestroy( )   	
		--self:StartIntervalThink(0.2)
	local parent = self:GetParent()
	if parent ~= nil and IsServer() then
		parent:RemoveNoDraw()
	end
end

function modifier_astral:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		MODIFIER_PROPERTY_BONUS_DAY_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		
	}
	return funcs
end

function modifier_astral:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_ROOTED]								 = true
		state[MODIFIER_STATE_DISARMED]								 = true
		state[MODIFIER_STATE_SILENCED]								 = true		
		state[MODIFIER_STATE_MUTED]									 = true		
		state[MODIFIER_STATE_INVULNERABLE]							 = true
		state[MODIFIER_STATE_MAGIC_IMMUNE]							 = true
		state[MODIFIER_STATE_UNSELECTABLE]							 = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES ]			 = true
		state[MODIFIER_STATE_FLYING]								 = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION]						 = true
		state[MODIFIER_STATE_UNTARGETABLE]							 = true		
		state[MODIFIER_STATE_UNSLOWABLE]							 = true
		state[MODIFIER_STATE_UNTARGETABLE]							 = true
		state[MODIFIER_STATE_INVISIBLE]								 = true		
		state[MODIFIER_STATE_DEBUFF_IMMUNE]							 = true
		state[MODIFIER_STATE_TRUESIGHT_IMMUNE]						 = true
		state[MODIFIER_STATE_PASSIVES_DISABLED]						 = true		 
	end
	return state
end

function modifier_astral:GetModifierMoveSpeedBonus_Constant()
	return -2000
end

function modifier_astral:GetModifierIgnoreMovespeedLimit()
	return 0
end

function modifier_astral:GetFixedDayVision()
	return -90000
end

function modifier_astral:GetFixedNightVision()
	return -90000
end

function modifier_astral:GetBonusDayVisionPercentage()
	return -1000
end

function modifier_astral:GetBonusVisionPercentage()
	return -1000
end

function modifier_astral:GetModifierTurnRate_Percentage()
	return 1000
end

function modifier_astral:OnIntervalThink()
  	local parent = self:GetParent()
end

function modifier_astral:GetStatusEffectName()
  	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_astral:GetTexture()
	return "Reposition"
end




















