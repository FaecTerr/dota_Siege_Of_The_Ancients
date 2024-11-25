item_one_way_mirror = class({})

LinkLuaModifier( "modifier_item_one_way_mirror", "items/item_one_way_mirror", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_one_way_mirror_buff", "items/item_one_way_mirror", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_one_way_mirror:GetIntrinsicModifierName()
  return "modifier_item_one_way_mirror"
end

function item_one_way_mirror:OnSpellStart()
    local caster = self:GetCaster()
    local mod = self:GetCaster():FindModifierByName("modifier_item_one_way_mirror_buff")    
    if self:GetCurrentCharges() > 0 and mod == nil then
    	local dur = self:GetSpecialValueFor('duration') + self:GetSpecialValueFor('bonus_duration_per_stack') * self:GetCurrentCharges()
    	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_one_way_mirror_buff", { duration = dur })
    	self:SetCurrentCharges(0)
    	EmitSoundOnEntityForPlayer( "siegeoftheancients.Mirror", caster, caster:GetPlayerOwnerID() )
    end
end

--------------------------------------------------------------------------------
modifier_item_one_way_mirror = class({})

function modifier_item_one_way_mirror:IsHidden() return true end
function modifier_item_one_way_mirror:IsPurgable() return false end
function modifier_item_one_way_mirror:IsPurgeException() return false end
function modifier_item_one_way_mirror:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_one_way_mirror:OnCreated()
	if not IsServer() then return end
	self.critProc = false
end

function modifier_item_one_way_mirror:DeclareFunctions()
  local funcs = 
  {
  	MODIFIER_EVENT_ON_ATTACK_FAIL,
    MODIFIER_EVENT_ON_ATTACK_START,        
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_SLOW_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_SLOW_RESISTANCE_UNIQUE,
    --MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,  
    --MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  }
  return funcs
end

function modifier_item_one_way_mirror:CheckState()
	local state = {}
		state[MODIFIER_STATE_CANNOT_MISS] = self.critProc
	
	return state
end

function modifier_item_one_way_mirror:OnAttackFail(kv)
	--print(kv)
	local caster = self:GetParent()
	if kv.attacker ~= caster then return end
    local mod = self:GetCaster():FindModifierByName("modifier_item_one_way_mirror_buff")  
	if kv.target:IsHero() and mod == nil then
		if self:GetAbility():GetCurrentCharges() < 8 then
  			self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
  		end
  	end
end

function modifier_item_one_way_mirror:OnAttackStart(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsWard() then return end
	if self:GetParent():FindAllModifiersByName("modifier_item_one_way_mirror")[1] ~= self then return end
	if RollPercentage(25) then
		self.critProc = true
	else
		self.critProc = false
	end
end

function modifier_item_one_way_mirror:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsWard() then return end
	if self:GetParent():FindAllModifiersByName("modifier_item_one_way_mirror")[1] ~= self then return end
	if not params.attacker:IsIllusion() and self.critProc then
	
        local damage = self:GetAbility():GetSpecialValueFor("bonus_dmg")
		local caster = self:GetCaster()

	    if not self:GetCaster():IsHero() then
	        caster = caster:GetOwner()
	    end

		Timers:CreateTimer(0.6, function ()			
			ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
		end)        
        params.target:EmitSound("DOTA_Item.MKB.melee")
        params.target:EmitSound("DOTA_Item.MKB.Minibash")
    end
end

function modifier_item_one_way_mirror:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_item_one_way_mirror:GetModifierSlowResistance_Stacking()
	return self:GetAbility():GetSpecialValueFor("slow_resist")
end

function modifier_item_one_way_mirror:GetModifierSlowResistance_Unique()
	return self:GetAbility():GetSpecialValueFor("slow_resist")
end

--------------------------------------------------------------------------------
modifier_item_one_way_mirror_buff = class({})

function modifier_item_one_way_mirror_buff:IsHidden() return false end
function modifier_item_one_way_mirror_buff:IsPurgable() return true end
function modifier_item_one_way_mirror_buff:IsPurgeException() return false end
function modifier_item_one_way_mirror_buff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

--Enable true strike
function modifier_item_one_way_mirror_buff:OnCreated()
	if not IsServer() then return end
	self.critProc = true
end

function modifier_item_one_way_mirror_buff:CheckState()
	local state = {}
	
	state[MODIFIER_STATE_CANNOT_MISS] = true
	
	return state
end

function modifier_item_one_way_mirror_buff:DeclareFunctions()
  local funcs = 
  {
  	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_EVENT_ON_ATTACK_START,        
    MODIFIER_EVENT_ON_ATTACK_LANDED,
  	MODIFIER_EVENT_ON_ATTACK_FAIL,
  }
  return funcs
end

function modifier_item_one_way_mirror_buff:GetModifierPreAttack_BonusDamage()
		return self:GetAbility():GetSpecialValueFor('bonus_dmg')
end

function modifier_item_one_way_mirror_buff:OnAttackStart(params)
	self:CheckState()
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsWard() then return end
	local state = { [MODIFIER_STATE_CANNOT_MISS] = true }
	return state
end

function modifier_item_one_way_mirror_buff:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsWard() then return end
	
	if not params.attacker:IsIllusion() then
		local target = params.target
        local damage = target:GetEvasion() * 2
		local caster = self:GetCaster()

	    if not self:GetCaster():IsHero() then
	        caster = caster:GetOwner()
	    end

	    local player = caster:GetPlayerID()		
		
		Timers:CreateTimer(0.3, function ()			
			ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
		end)
        
        params.target:EmitSound("DOTA_Item.MKB.melee")
        params.target:EmitSound("DOTA_Item.MKB.Minibash")
    end
end

function modifier_item_one_way_mirror_buff:OnAttackFail(params)
	if params.attacker ~= self:GetParent() then return end
	
	if not params.attacker:IsIllusion() then
		local victim = params.target
		
		local damage = self:GetAbility():GetSpecialValueFor("bonus_dmg")
		local evdamage = victim:GetEvasion() * 2
		
		self:GetParent():PerformAttack(victim, true, true, true, false, false, false, true)
						
		Timers:CreateTimer(0.3, function ()			
			ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = evdamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
		end)
		
		Timers:CreateTimer(0.6, function ()			
			ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
		end)  
		
  	end
end

function modifier_item_one_way_mirror_buff:GetTexture()
	return "items/one_way_mirror"
end