item_great_power_treads = class({})

LinkLuaModifier( "modifier_item_great_power_treads", "items/item_great_power_treads", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_great_power_treads_buff", "items/item_great_power_treads", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_great_power_treads:GetIntrinsicModifierName()
    return "modifier_item_great_power_treads"
end


function item_great_power_treads:OnCreated()
	self.mode = 0
	if parent ~= nil and parent:HasModifier("modifier_item_great_power_treads") then
		local parent = self:GetParent()	
		local mod = parent:FindModifierByName("modifier_item_great_power_treads")
		local mode = 0
		--Strength		0
		--Intellect 	1
		--Agility 		2
		self.mode = 0
		mod:SetStackCount(mode)
	end
end

function item_great_power_treads:Spawn()
	self.mode = 0
end

function item_great_power_treads:OnToggle()
	local caster = self:GetCaster()
	
	self.mode = self.mode + 1
	if self.mode > 2 then
		self.mode = 0
	end
	
	self:SetSecondaryCharges(self.mode)
	
    if caster == nil then return end

	if caster ~= nil and caster:HasModifier("modifier_item_great_power_treads") and IsServer() then
		local mod = caster:FindModifierByName("modifier_item_great_power_treads")
    	local mode = mod:GetStackCount()
    	mode = mode + 1
    	
    	if mode > 2 then
    		mode = 0
    	end
    	
		mod:SetStackCount(mode)
		caster:CalculateStatBonus(true)
	end
end

function item_great_power_treads:GetAbilityTextureName()	
    --print(self.m)
    self.mode = self:GetSecondaryCharges()
	if self.mode == 0 then
		return "great_power_treads_0"
   	elseif self.mode == 1 then
		return "great_power_treads_1"
	elseif self.mode == 2 then
		return "great_power_treads_2"
	else 
		return "great_power_treads"
	end
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_great_power_treads = class({})

function modifier_item_great_power_treads:IsDebuff() return false end
function modifier_item_great_power_treads:IsHidden() return true end
function modifier_item_great_power_treads:IsPurgable() return false end
function modifier_item_great_power_treads:IsPurgeException() return false end
function modifier_item_great_power_treads:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_great_power_treads:OnCreated( kv )
	self:StartIntervalThink(0.25)
end

function modifier_item_great_power_treads:OnIntervalThink()
	local parent = self:GetParent()
	self.isParentRange = false
	
	if parent ~= nil then
		if parent:IsRangedAttacker() then
			self.isParentRange = true
		end
	end
end

function modifier_item_great_power_treads:DeclareFunctions()
    return 
    {
    	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,    	
    	
    	MODIFIER_PROPERTY_HEALTH_BONUS,
    	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    	
    	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    	
    	MODIFIER_PROPERTY_EXTRA_MANA_BONUS_PERCENTAGE,
    	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    	
    	    	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
    }
end

	--Strength		0
	--Intellect 	1
	--Agility 		2



--Bracers
function modifier_item_great_power_treads:GetModifierConstantHealthRegen()
    if self:GetStackCount() == 0 then
    	return self:GetAbility():GetSpecialValueFor("str_health_regen_bonus")
    else
   		return 0
    end
end

function modifier_item_great_power_treads:GetModifierHealthBonus()
    if self:GetStackCount() == 0 then
    	return self:GetAbility():GetSpecialValueFor("str_max_health_bonus")
    else
   		return 0
    end
end

--Wraith Band
function modifier_item_great_power_treads:GetModifierPhysicalArmorBonus()
    if self:GetStackCount() == 2 then
    	return self:GetAbility():GetSpecialValueFor("bonus_Armor")
    else
   		return 0
    end
end

function modifier_item_great_power_treads:GetModifierAttackSpeedBonus_Constant()
	local base = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
    if self:GetStackCount() == 2 then
    	return base + self:GetAbility():GetSpecialValueFor("agi_attack_speed_bonus")
    else
   		return base
    end
end

--Null Talisman
function modifier_item_great_power_treads:GetModifierExtraManaBonusPercentage()
    if self:GetStackCount() == 1 then
    	return self:GetAbility():GetSpecialValueFor("int_mana_pool_bonus")
    else
   		return 0
    end
end

function modifier_item_great_power_treads:GetModifierConstantManaRegen()
    if self:GetStackCount() == 1 then
    	return self:GetAbility():GetSpecialValueFor("int_mana_regen_bonus")
    else
   		return 0
    end
end

--MoveSpeed
function modifier_item_great_power_treads:GetModifierMoveSpeedBonus_Special_Boots()
   	if self.isParentRange then return self:GetAbility():GetSpecialValueFor("range_bonus_MS") end
    return self:GetAbility():GetSpecialValueFor("melee_bonus_MS")
end

--Attributes
function modifier_item_great_power_treads:GetModifierBonusStats_Strength()
    if self:GetStackCount() == 0 then
    	return self:GetAbility():GetSpecialValueFor("primary_stat_bonus")
    else
    	return self:GetAbility():GetSpecialValueFor("secondary_stat_bonus")
    end
end

function modifier_item_great_power_treads:GetModifierBonusStats_Agility()
   	if self:GetStackCount() == 2 then
    	return self:GetAbility():GetSpecialValueFor("primary_stat_bonus")
    else
    	return self:GetAbility():GetSpecialValueFor("secondary_stat_bonus")
    end
end

function modifier_item_great_power_treads:GetModifierBonusStats_Intellect()
    if self:GetStackCount() == 1 then
    	return self:GetAbility():GetSpecialValueFor("primary_stat_bonus")
    else
    	return self:GetAbility():GetSpecialValueFor("secondary_stat_bonus")
    end
end


function modifier_item_great_power_treads:GetTexture()
	return "items/great_power_treads_on"
end




