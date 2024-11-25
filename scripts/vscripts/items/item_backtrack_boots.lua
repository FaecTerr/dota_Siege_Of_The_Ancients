item_backtrack_boots = class({})

LinkLuaModifier( "modifier_item_backtrack_boots", "items/item_backtrack_boots", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_backtrack_boots_buff", "items/item_backtrack_boots", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_backtrack_boots:GetIntrinsicModifierName()
    return "modifier_item_backtrack_boots"
end

function item_backtrack_boots:GetAbilityTextureName()
	if self:GetCaster() == nil then	return "backtrack_boots"	end
    if self:GetCaster():HasModifier("modifier_item_backtrack_boots_buff") then
        return "backtrack_boots_on"
    else
        return "backtrack_boots"
    end
end

function item_backtrack_boots:OnToggle()
	local caster = self:GetCaster()
    if caster == nil then return end
    local toggle = true
	if self:GetCaster():HasModifier("modifier_item_backtrack_boots_buff") then
		toggle = true
	else
		toggle = false
	end
    if not IsServer() then return end
    
    --toggle ON
    if not toggle then    
        self:EndCooldown()
        
        self.casterHealth = caster:GetHealth()
        self.casterPosition = caster:GetAbsOrigin()
                
        self.modifier = caster:AddNewModifier( caster, self, "modifier_item_backtrack_boots_buff", { duration = self:GetSpecialValueFor("AbilityDuration") } )
        caster:EmitSound("DOTA_Item.PhaseBoots.Activate")
        
        Timers:CreateTimer(self:GetSpecialValueFor("AbilityDuration"), function() 
        	if self:GetCooldownTime() <= 0 then
        		self.casterHealth = nil
        		self.casterPosition = nil
        		        		
        		self:StartCooldown(self:GetSpecialValueFor("AbilityCooldown") - self:GetSpecialValueFor("AbilityDuration"))
        	end
        end)
    else
    --toggle OFF
        local mod = self:GetCaster():FindModifierByName("modifier_item_backtrack_boots_buff")
        if mod then
        	--Remaining duration
        	local leftovers = mod:GetRemainingTime()
        	
        	if self.casterPosition ~= nil and self.casterHealth ~= nil then
        		--Restore Health
        		if caster:GetHealth() < self.casterHealth then
        			caster:Heal((self.casterHealth - caster:GetHealth()) * 0.01 * self:GetSpecialValueFor("RestoreAmount"), this)
        		end
        		
        		--Restore position
        		caster:SetAbsOrigin(self.casterPosition)
        		
        		--Prep for next
        		self.casterHealth = nil
        		self.casterPosition = nil
        	end
        	
        	self:StartCooldown(self:GetSpecialValueFor("AbilityCooldown") - self:GetSpecialValueFor("AbilityDuration") + leftovers)
        	
            mod:Destroy()
        end
    end
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_backtrack_boots = class({})

function modifier_item_backtrack_boots:IsDebuff() return false end
function modifier_item_backtrack_boots:IsHidden() return true end
function modifier_item_backtrack_boots:IsPurgable() return false end
function modifier_item_backtrack_boots:IsPurgeException() return false end
function modifier_item_backtrack_boots:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_backtrack_boots:OnCreated( kv )
	self:StartIntervalThink(0.25)
end

function modifier_item_backtrack_boots:OnIntervalThink()
	local parent = self:GetParent()
	self.isParentRange = false
	
	if parent ~= nil then
		if parent:IsRangedAttacker() then
			self.isParentRange = true
		end
	end
end

function modifier_item_backtrack_boots:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_item_backtrack_boots:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_Armor")
end

function modifier_item_backtrack_boots:GetModifierMoveSpeedBonus_Special_Boots()
    return self:GetAbility():GetSpecialValueFor("bonus_MS")
end


function modifier_item_backtrack_boots:GetModifierPreAttack_BonusDamage()
	if self.isParentRange then return self:GetAbility():GetSpecialValueFor("range_bonus_DMG") end
    return self:GetAbility():GetSpecialValueFor("melee_bonus_DMG")
end


function modifier_item_backtrack_boots:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsWard() then return end
	
	local lifesteal = self:GetAbility():GetSpecialValueFor("Lifesteal")
	
	--Creep lifesteal reduced by 40%
	if not params.target:IsHero() then 
		lifesteal = lifesteal * (100 - self:GetAbility():GetSpecialValueFor("CreepLifestealReduction")) * 0.01
	end
	
    if params.damage > 0 and params.damage_type == DOTA_DAMAGE_CATEGORY_ATTACK then
    	--print('a: ' ..  lifesteal)
    	self:GetParent():HealWithParams(params.damage * lifesteal * 0.01, params.attacker, true, true, self:GetAbility(), false)
    end
end

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------

modifier_item_backtrack_boots_buff = class({})

function modifier_item_backtrack_boots_buff:IsDebuff() return false end
function modifier_item_backtrack_boots_buff:IsHidden() return false end
function modifier_item_backtrack_boots_buff:IsPurgable() return false end

function modifier_item_backtrack_boots_buff:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE 
    }
end

function modifier_item_backtrack_boots_buff:CheckState()
	local state = {}
	
		state[MODIFIER_STATE_NO_UNIT_COLLISION]			 = true
	
	return state
end

function modifier_item_backtrack_boots_buff:GetModifierMoveSpeedBonus_Percentage()
	if self.isParentRange then return self:GetAbility():GetSpecialValueFor("range_bonus_MS") end
    return self:GetAbility():GetSpecialValueFor("melee_bonus_MS")
end

function modifier_item_backtrack_boots_buff:GetModifierTurnRate_Override()
	if self.isParentRange then return end
    return self:GetAbility():GetSpecialValueFor("melee_turn_rate")
end


function modifier_item_backtrack_boots_buff:OnCreated( kv )
	self:StartIntervalThink(0.25)
end

function modifier_item_backtrack_boots_buff:OnIntervalThink()
	local parent = self:GetParent()
	self.isParentRange = false
	
	if parent ~= nil then
		if parent:IsRangedAttacker() then
			self.isParentRange = true
		end
	end
end


function modifier_item_backtrack_boots_buff:GetTexture()
	return "items/backtrack_boots_on"
end




