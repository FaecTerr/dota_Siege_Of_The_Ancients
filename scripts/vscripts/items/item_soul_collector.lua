item_soul_collector = class({})

LinkLuaModifier( "modifier_item_soul_collector", "items/item_soul_collector", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_soul_collector_buff", "items/item_soul_collector", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_soul_collector:GetIntrinsicModifierName()
  return "modifier_item_soul_collector"
end

function item_soul_collector:OnSpellStart()
    local caster = self:GetCaster()
    local mod = self:GetCaster():FindModifierByName("modifier_item_soul_collector_buff")    
    if self:GetCurrentCharges() > 0 and mod == nil then
    	local dur = self:GetSpecialValueFor('Duration')
    	local newmod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_soul_collector_buff", { duration = dur })
    	
    	EmitSoundOnEntityForPlayer( "siegeoftheancients.Spook", caster, caster:GetPlayerOwnerID() )
    end
end

--------------------------------------------------------------------------------

modifier_item_soul_collector = class({})

function modifier_item_soul_collector:IsHidden() return true end
function modifier_item_soul_collector:IsPurgable() return false end
function modifier_item_soul_collector:IsPurgeException() return false end
function modifier_item_soul_collector:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_soul_collector:DeclareFunctions()
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

function modifier_item_soul_collector:OnDeath(params)
	local caster = self:GetCaster()	
    local mod = self:GetCaster():FindModifierByName("modifier_item_soul_collector_buff")  
    
    local attacker = params.attacker
    
    if mod == nil and attacker ~= nil and attacker == caster and params.unit:GetTeam() ~= attacker:GetTeam() then
		if self:GetAbility():GetCurrentCharges() < self:GetAbility():GetSpecialValueFor("MaximumStacks") then
  			self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
  		end
  	end
end

function modifier_item_soul_collector:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("ManaRegen")
end

function modifier_item_soul_collector:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("HealthBonus")
end

function modifier_item_soul_collector:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("ArmorBonus")
end

function modifier_item_soul_collector:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("BonusAttribute")
end

function modifier_item_soul_collector:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("BonusAttribute")
end

function modifier_item_soul_collector:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("BonusAttribute")
end

--------------------------------------------------------------------------------
modifier_item_soul_collector_buff = class({})

function modifier_item_soul_collector_buff:IsHidden() return false end
function modifier_item_soul_collector_buff:IsPurgable() return true end
function modifier_item_soul_collector_buff:IsPurgeException() return false end
function modifier_item_soul_collector_buff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_soul_collector_buff:DeclareFunctions()
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


function modifier_item_soul_collector_buff:OnCreated()
	self.mcdr = self:GetAbility():GetSpecialValueFor('ManaCostReductionPerStack') * self:GetAbility():GetCurrentCharges()
	self.mr = self:GetAbility():GetSpecialValueFor("ManaRegenPerStack")* self:GetAbility():GetCurrentCharges()
	self.aps = self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_buff:OnDestroy()
	if self ~= nil and self:GetAbility() ~= nil and IsServer() then
    	self:GetAbility():SetCurrentCharges(0)
    end
end

function modifier_item_soul_collector_buff:GetModifierPercentageManacostStacking()
	if self.mcdr ~= nil then
		return self.mcdr
	end
	return self:GetAbility():GetSpecialValueFor('ManaCostReductionPerStack') * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_buff:GetModifierConstantManaRegen()
	if self.mr ~= nil then
		return self.mr
	end
	return self:GetAbility():GetSpecialValueFor("ManaRegenPerStack")* self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_buff:GetModifierBonusStats_Strength()
	if self.aps ~= nil then
		return self.aps
	end
	return self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_buff:GetModifierBonusStats_Agility()
	if self.aps ~= nil then
		return self.aps
	end
	return self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_soul_collector_buff:GetModifierBonusStats_Intellect()
	if self.aps ~= nil then
		return self.aps
	end
	return self:GetAbility():GetSpecialValueFor("AttributePerStack") * self:GetAbility():GetCurrentCharges()
end


function modifier_item_soul_collector_buff:GetTexture()
	return "items/soul_collector"
end



