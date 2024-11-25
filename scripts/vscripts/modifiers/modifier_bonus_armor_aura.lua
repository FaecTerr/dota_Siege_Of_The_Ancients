LinkLuaModifier( "modifier_bonus_armor_aura", "modifiers/modifier_bonus_armor_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_armor_aura_buff", "modifiers/modifier_bonus_armor_aura", LUA_MODIFIER_MOTION_NONE )

modifier_bonus_armor_aura = class({})

function modifier_bonus_armor_aura:IsAura() return true end
function modifier_bonus_armor_aura:IsHidden() return true end
function modifier_bonus_armor_aura:IsPurgable() return false end

function modifier_bonus_armor_aura:GetAuraRadius()
    return -1
end

function modifier_bonus_armor_aura:GetModifierAura()
    return "modifier_bonus_armor_aura_buff"
end
   
function modifier_bonus_armor_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_bonus_armor_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_bonus_armor_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BUILDING
end

function modifier_bonus_armor_aura:GetAuraDuration()
    return 0.1
end

modifier_bonus_armor_aura_buff = class({})

function modifier_bonus_armor_aura_buff:IsAura() return false end
function modifier_bonus_armor_aura_buff:IsHidden() return false end
function modifier_bonus_armor_aura_buff:IsPurgable() return false end

function modifier_bonus_armor_aura_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_bonus_armor_aura_buff:GetModifierPhysicalArmorBonus()
	return 4
end