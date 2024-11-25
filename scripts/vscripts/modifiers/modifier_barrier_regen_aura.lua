LinkLuaModifier( "modifier_barrier_regen_aura", "modifiers/modifier_barrier_regen_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_barrier_regen_aura_buff", "modifiers/modifier_barrier_regen_aura", LUA_MODIFIER_MOTION_NONE )

modifier_barrier_regen_aura = class({})

function modifier_barrier_regen_aura:IsAura() return true end
function modifier_barrier_regen_aura:IsHidden() return true end
function modifier_barrier_regen_aura:IsPurgable() return false end

function modifier_barrier_regen_aura:GetAuraRadius()
    return -1
end

function modifier_barrier_regen_aura:GetModifierAura()
    return "modifier_barrier_regen_aura_buff"
end
   
function modifier_barrier_regen_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_barrier_regen_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_barrier_regen_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BUILDING
end

function modifier_barrier_regen_aura:GetAuraDuration()
    return 0.1
end

modifier_barrier_regen_aura_buff = class({})

function modifier_barrier_regen_aura_buff:IsAura() return false end
function modifier_barrier_regen_aura_buff:IsHidden() return false end
function modifier_barrier_regen_aura_buff:IsPurgable() return false end
