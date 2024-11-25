modifier_attacker_respawn = class({})

function modifier_attacker_respawn:IsDebuff() return false end
function modifier_attacker_respawn:IsPurgable() return false end
function modifier_attacker_respawn:RemoveOnDeath() return false end
function modifier_attacker_respawn:IsPermanent() return true end
function modifier_attacker_respawn:IsHidden() return false end

function modifier_attacker_respawn:OnCreated( kv )   	
		--self:StartIntervalThink(0.2)
end

function modifier_attacker_respawn:DeclareFunctions()
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

function modifier_attacker_respawn:CheckState()
	local state = {}
	if IsServer() then
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

function modifier_attacker_respawn:GetModifierMoveSpeedBonus_Constant()
	return 2000
end

function modifier_attacker_respawn:GetModifierIgnoreMovespeedLimit()
	return 2000
end

function modifier_attacker_respawn:GetFixedDayVision()
	return -90000
end

function modifier_attacker_respawn:GetFixedNightVision()
	return -90000
end

function modifier_attacker_respawn:GetBonusDayVisionPercentage()
	return -1000
end

function modifier_attacker_respawn:GetBonusVisionPercentage()
	return -1000
end

function modifier_attacker_respawn:GetModifierTurnRate_Percentage()
	return 1000
end

function modifier_attacker_respawn:OnIntervalThink()
  	local parent = self:GetParent()
end

function modifier_attacker_respawn:GetStatusEffectName()
  	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_attacker_respawn:GetTexture()
	return "Reposition"
end




















