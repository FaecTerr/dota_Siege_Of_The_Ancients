item_monoculars = class({})

LinkLuaModifier( "modifier_item_monoculars", "items/item_monoculars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_monoculars_buff", "items/item_monoculars", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_monoculars_gem", "items/item_monoculars", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_monoculars:GetIntrinsicModifierName()
    return "modifier_item_monoculars"
end

function item_monoculars:GetAbilityTextureName()
	if self:GetCaster() == nil then	return "monoculars_off"	end
    if self:GetCaster():HasModifier("modifier_item_monoculars_buff") then
        return "monoculars"
    else
        return "monoculars_off"
    end
end


function item_monoculars:OnToggle()
    local caster = self:GetCaster()
    local toggle = self:GetToggleState()
    if caster == nil then
  
    	return 
    end
    if not IsServer() then return end
    if toggle then    
        self:EndCooldown()
        self.modifier = caster:AddNewModifier( caster, self, "modifier_item_monoculars_buff", {} )
        self.modifier2 = caster:AddNewModifier( caster, self, "modifier_item_monoculars_gem", {} )
        --self:GetCaster():EmitSound("ghoul_mask")
    else
        local mod = self:GetCaster():FindModifierByName("modifier_item_monoculars_buff")
        if mod then
            mod:Destroy()
            self:UseResources(false, false, false, true)
        end
        local gem = self:GetCaster():FindModifierByName("modifier_item_monoculars_gem")
        if gem then
            gem:Destroy()
            self:UseResources(false, false, false, true)
        end
    end
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_monoculars = class({})

function modifier_item_monoculars:IsDebuff() return false end
function modifier_item_monoculars:IsHidden() return true end
function modifier_item_monoculars:IsPurgable() return false end
function modifier_item_monoculars:IsPurgeException() return false end
function modifier_item_monoculars:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_monoculars:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_monoculars:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_monoculars:OnDestroy()
    if not IsServer() then return end
    local mod = self:GetParent():FindModifierByName("modifier_item_monoculars_buff")
    if mod then
        mod:Destroy()
    end    
	local gem = self:GetParent():FindModifierByName("modifier_item_monoculars_gem")
    if gem then
        gem:Destroy()
    end
end

function modifier_item_monoculars:DeclareFunctions()
    return 
    {
    	MODIFIER_PROPERTY_CAST_RANGE_BONUS,
    	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    	MODIFIER_PROPERTY_MANA_BONUS,
    	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_item_monoculars:GetModifierCastRangeBonus()
    return self:GetAbility():GetSpecialValueFor("cast_range_passive")
end

function modifier_item_monoculars:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_item_monoculars:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor("mana_bonus")
end

function modifier_item_monoculars:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("attributes_bonus")
end

function modifier_item_monoculars:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("attributes_bonus")
end

function modifier_item_monoculars:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("attributes_bonus")
end
--------------------------------------------------------------------------------
--Active effect
--------------------------------------------------------------------------------

modifier_item_monoculars_buff = class({})

function modifier_item_monoculars:IsDebuff() return false end
function modifier_item_monoculars_buff:IsHidden() return false end
function modifier_item_monoculars_buff:IsPurgable() return false end
function modifier_item_monoculars_buff:IsPurgeException() return false end
function modifier_item_monoculars_buff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_monoculars_buff:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_monoculars_buff:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_monoculars_buff:DeclareFunctions()
    return 
    {
    	MODIFIER_PROPERTY_BONUS_DAY_VISION,
    	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_item_monoculars_buff:GetBonusDayVision()
    return self:GetAbility():GetSpecialValueFor("negative_vision_active")
end

function modifier_item_monoculars_buff:GetModifierCastRangeBonusStacking()
    return self:GetAbility():GetSpecialValueFor("cast_range_active") * -1
end

function modifier_item_monoculars_buff:GetTexture()
	return "items/monoculars"
end

--------------------------------------------------------------------------------
--Invis Revealing Aura
--------------------------------------------------------------------------------


modifier_item_monoculars_gem = class({})

function modifier_item_monoculars_gem:IsAura() return true end
function modifier_item_monoculars_gem:IsHidden() return true end
function modifier_item_monoculars_gem:IsPurgable() return false end

function modifier_item_monoculars_gem:GetAuraRadius()
    return 600
end

function modifier_item_monoculars_gem:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_item_monoculars_gem:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_item_monoculars_gem:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_monoculars_gem:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_item_monoculars_gem:GetAuraDuration()
    return 0.1
end

function modifier_item_monoculars_gem:GetTexture()
	return "items/monoculars"
end
