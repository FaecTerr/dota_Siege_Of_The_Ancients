item_soul_collector_lvl_2 = class({})

LinkLuaModifier( "modifier_item_soul_collector_lvl_2", "items/item_soul_collector_lvl_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_soul_collector_lvl_2_buff", "items/item_soul_collector_lvl_2", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_soul_collector_lvl_2:GetIntrinsicModifierName()
  return "modifier_item_soul_collector_lvl_2"
end

function item_soul_collector_lvl_2:OnSpellStart()
    local caster = self:GetCaster()
    local mod = self:GetCaster():FindModifierByName("modifier_item_soul_collector_lvl_2_buff")    
    if self:GetCurrentCharges() > 0 and mod == nil then
    	local dur = self:GetSpecialValueFor('Duration')
    	local newmod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_soul_collector_lvl_2_buff", { duration = dur })
    	
    	EmitSoundOnEntityForPlayer( "siegeoftheancients.Spook", caster, caster:GetPlayerOwnerID() )
    end
end

--------------------------------------------------------------------------------

modifier_item_soul_collector_lvl_2 = class({})

function modifier_item_soul_collector_lvl_2:IsHidden() return true end
function modifier_item_soul_collector_lvl_2:IsPurgable() return false end
function modifier_item_soul_collector_lvl_2:IsPurgeException() return false end
function modifier_item_soul_collector_lvl_2:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_soul_collector_lvl_2:DeclareFunctions()
  local funcs = 
  {
  	MODIFIER_EVENT_ON_KILL,
  	MODIFIER_EVENT_ON_HERO_KILLED,
  	MODIFIER_EVENT_ON_DEATH,
  	
    MODIFIER_PROPERTY_HEALTH_BONUS,    
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
  	
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  }
  return funcs
end

function modifier_item_soul_collector_lvl_2:OnDeath(params)
	local caster = self:GetCaster()	
    local mod = self:GetCaster():FindModifierByName("modifier_item_soul_collector_lvl_2_buff")  
    
    local attacker = params.attacker
    
    if mod == nil and attacker ~= nil and attacker == caster and params.unit:GetTeam() ~= attacker:GetTeam() then
		if self:GetAbility():GetCurrentCharges() < self:GetAbility():GetSpecialValueFor("MaximumStacks") then
  			self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
  		end
  	end
end

function modifier_item_soul_collector_lvl_2:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("ManaRegen")
end

function modifier_item_soul_collector_lvl_2:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("HealthBonus")
end

function modifier_item_soul_collector_lvl_2:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("ArmorBonus")
end

function modifier_item_soul_collector_lvl_2:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("BonusAttribute")
end

function modifier_item_soul_collector_lvl_2:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("BonusAttribute")
end

function modifier_item_soul_collector_lvl_2:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("BonusAttribute")
end

--------------------------------------------------------------------------------
modifier_item_soul_collector_lvl_2_buff = class({})

function modifier_item_soul_collector_lvl_2_buff:IsHidden() return false end
function modifier_item_soul_collector_lvl_2_buff:IsPurgable() return true end
function modifier_item_soul_collector_lvl_2_buff:IsPurgeException() return false end
function modifier_item_soul_collector_lvl_2_buff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_soul_collector_lvl_2_buff:DeclareFunctions()
  local funcs = 
  {
  	MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
  	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
  	
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  }
  return funcs
end


function modifier_item_soul_collector_lvl_2_buff:OnCreated()
	self.mcdr = self:GetAbility():GetSpecialValueFor('ManaCostReductionPerStack') * self:GetAbility():GetCurrentCharges()
	self.mr = self:GetAbility():GetSpecialValueFor("ManaRegenPerStack")* self:GetAbility():GetCurrentCharges()
	self.aps = self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_lvl_2_buff:OnDestroy()
	if self ~= nil and self:GetAbility() ~= nil and IsServer() then
    	self:GetAbility():SetCurrentCharges(0)
    end
end

function modifier_item_soul_collector_lvl_2_buff:GetModifierPercentageManacostStacking()
	if self.mcdr ~= nil then
		return self.mcdr
	end
	return self:GetAbility():GetSpecialValueFor('ManaCostReductionPerStack') * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_lvl_2_buff:GetModifierConstantManaRegen()
	if self.mr ~= nil then
		return self.mr
	end
	return self:GetAbility():GetSpecialValueFor("ManaRegenPerStack")* self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_lvl_2_buff:GetModifierBonusStats_Strength()
	if self.aps ~= nil then
		return self.aps
	end
	return self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_lvl_2_buff:GetModifierBonusStats_Agility()
	if self.aps ~= nil then
		return self.aps
	end
	return self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_lvl_2_buff:GetModifierBonusStats_Intellect()
	if self.aps ~= nil then
		return self.aps
	end
	return self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end


function modifier_item_soul_collector_lvl_2_buff:GetTexture()
	return "items/soul_collector"
end



