item_slowing_veins = class({})

LinkLuaModifier( "modifier_item_slowing_veins", "items/item_slowing_veins", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_slowing_veins_aura", "items/item_slowing_veins", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_slowing_veins_aura_slow", "items/item_slowing_veins", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_slowing_veins_thinker", "items/item_slowing_veins", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_slowing_veins:GetIntrinsicModifierName()
    return "modifier_item_slowing_veins"
end

--particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small_cable.vpcf

function item_slowing_veins:OnSpellStart()
    --local kv = {}
	--CreateModifierThinker( self:GetCaster(), self, "modifier_item_slowing_veins_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
	if not IsServer() then return end
	local veins = CreateUnitByName("item_veins", self:GetCaster():GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	veins:AddNewModifier(veins, self, "modifier_item_slowing_veins_aura", {duration = -1})
	veins:AddNewModifier(veins, self, "modifier_item_slowing_veins_thinker", {duration = -1})
	veins:SetDayTimeVisionRange(600)
	veins:SetNightTimeVisionRange(600)
	
	veins:SetHullRadius(40)
	
	self:SetCurrentCharges(self:GetCurrentCharges() - 1)
end

function item_slowing_veins:GetAOERadius()
	return self:GetSpecialValueFor( "AOERadius" )
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_slowing_veins = class({})

function modifier_item_slowing_veins:IsDebuff() return false end
function modifier_item_slowing_veins:IsHidden() return true end
function modifier_item_slowing_veins:IsPurgable() return false end
function modifier_item_slowing_veins:IsPurgeException() return false end
function modifier_item_slowing_veins:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_slowing_veins:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_slowing_veins:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_slowing_veins:OnDestroy()
    if not IsServer() then return end
	local aura = self:GetParent():FindModifierByName("modifier_item_slowing_veins_aura")
    if aura then
        aura:Destroy()
    end
    local slow = self:GetParent():FindModifierByName("modifier_item_slowing_veins_aura_slow")
    if slow then
        slow:Destroy()
    end
    local thinker = self:GetParent():FindModifierByName("modifier_item_slowing_veins_thinker")
    if thinker then
        thinker:Destroy()
    end
end

function modifier_item_slowing_veins:DeclareFunctions()
    return 
    {
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

--------------------------------------------------------------------------------
--Thinker
--------------------------------------------------------------------------------
modifier_item_slowing_veins_thinker = ({})

function modifier_item_slowing_veins_thinker:OnCreated( kv )
	if IsServer() then
		-- attacks
		self.health = self:GetAbility():GetSpecialValueFor( "destroy_attacks" )
		self.hero_attack = self.health/self:GetAbility():GetSpecialValueFor( "destroy_hero_attacks" )
		self.max_health = self.health
	end
end

function modifier_item_slowing_veins_thinker:OnDestroy( kv )
	if IsServer() then
		self:GetParent():Destroy()
	end
end

function modifier_item_slowing_veins_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
    	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    	MODIFIER_PROPERTY_HEALTHBAR_PIPS 
	}

	return funcs
end

function modifier_item_slowing_veins_thinker:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_item_slowing_veins_thinker:GetModifierHealthBarPips()
	return self:GetAbility():GetSpecialValueFor( "destroy_hero_attacks" )
end

function modifier_item_slowing_veins_thinker:OnAttacked( params )
	if params.target~=self:GetParent() then return end

	-- reduce health
	if params.attacker:IsHero() then
		self.health = math.max(self.health - self.hero_attack, 0)
	else
		self.health = math.max(self.health - 1, 0)
	end
	self:GetParent():SetHealth( self.health/self.max_health * self:GetParent():GetMaxHealth() )
	
	if self.health <= 0 then
		self:Destroy()
	end
end


--------------------------------------------------------------------------------
--Aura
--------------------------------------------------------------------------------
modifier_item_slowing_veins_aura = class({})

function modifier_item_slowing_veins_aura:IsAura() return true end
function modifier_item_slowing_veins_aura:IsHidden() return false end
function modifier_item_slowing_veins_aura:IsPurgable() return false end

function modifier_item_slowing_veins_aura:OnCreated()
	
	self.particle_drain_fx = ParticleManager:CreateParticle("particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	self:AddParticle(self.particle_drain_fx, false, false, -1, false, false)
		
	self.particle_drain_fx1 = ParticleManager:CreateParticle("particles/items_fx/seeds_of_serenity_pulse.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	self:AddParticle(self.particle_drain_fx1, false, false, -1, false, false)
	
	self.aoe = self:GetAbility():GetSpecialValueFor("AOERadius")
	self.slow = self:GetAbility():GetSpecialValueFor("slowdown")
end

function modifier_item_slowing_veins_aura:OnDestroy()
	ParticleManager:DestroyParticle(self.particle_drain_fx, false)
	ParticleManager:DestroyParticle(self.particle_drain_fx1, false)	
	
	if IsServer() and self:GetAbility() ~= nil then
		self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
	end
end

function modifier_item_slowing_veins_aura:CheckState()
    return 
    { 
    	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = false,
		[MODIFIER_STATE_UNSELECTABLE] = false,
		[MODIFIER_STATE_INVULNERABLE] = false,
	}
end

function modifier_item_slowing_veins_aura:GetAuraRadius()
    return self.aoe
end

function modifier_item_slowing_veins_aura:GetModifierAura()
    return "modifier_item_slowing_veins_aura_slow"
end
   
function modifier_item_slowing_veins_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_slowing_veins_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_slowing_veins_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_item_slowing_veins_aura:GetAuraDuration()
    return 0.1
end

function modifier_item_slowing_veins_aura:GetTexture()
	return "items/slowing_veins"
end

--------------------------------------------------------------------------------
--Slow modifier
--------------------------------------------------------------------------------
modifier_item_slowing_veins_aura_slow = class({})

function modifier_item_slowing_veins_aura_slow:IsAura() return false end
function modifier_item_slowing_veins_aura_slow:IsHidden() return true end
function modifier_item_slowing_veins_aura_slow:IsPurgable() return false end

function modifier_item_slowing_veins_aura_slow:OnCreated()
	self.slow = 30
end

function modifier_item_slowing_veins_aura_slow:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
end

--slowdown effect
function modifier_item_slowing_veins_aura_slow:GetModifierMoveSpeedBonus_Percentage()
	return -1 * self.slow
end

--Restrict attack distance while affected to Target Units
function modifier_item_slowing_veins_aura_slow:GetModifierAttackRangeBonus()
	if not IsServer() then return end	
	local target = 200
	local parent = self:GetParent()
	
	local BAR = parent:GetBaseAttackRange()
	
	return -(BAR - target)
end

function modifier_item_slowing_veins_aura_slow:GetTexture()
	return "items/slowing_veins"
end