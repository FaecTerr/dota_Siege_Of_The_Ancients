LinkLuaModifier( "modifier_bonus_attack_speed_aura", "modifiers/modifier_bonus_attack_speed_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_attack_speed_aura_buff", "modifiers/modifier_bonus_attack_speed_aura", LUA_MODIFIER_MOTION_NONE )

modifier_bonus_attack_speed_aura = class({})

function modifier_bonus_attack_speed_aura:IsAura() return true end
function modifier_bonus_attack_speed_aura:IsHidden() return true end
function modifier_bonus_attack_speed_aura:IsPurgable() return false end

function modifier_bonus_attack_speed_aura:GetAuraRadius()
    return -1
end

function modifier_bonus_attack_speed_aura:GetModifierAura()
    return "modifier_bonus_attack_speed_aura_buff"
end
   
function modifier_bonus_attack_speed_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_bonus_attack_speed_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_bonus_attack_speed_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BUILDING
end

function modifier_bonus_attack_speed_aura:GetAuraDuration()
    return 0.1
end

modifier_bonus_attack_speed_aura_buff = class({})

function modifier_bonus_attack_speed_aura_buff:IsAura() return false end
function modifier_bonus_attack_speed_aura_buff:IsHidden() return false end
function modifier_bonus_attack_speed_aura_buff:IsPurgable() return false end

function modifier_bonus_attack_speed_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end

function modifier_bonus_attack_speed_aura_buff:GetModifierAttackSpeedBonus_Constant()
	return 30
end

function modifier_bonus_attack_speed_aura_buff:GetModifierBaseAttackTimeConstant()
	return 0.5
end