item_snare = class({})

LinkLuaModifier( "modifier_item_snare", "items/item_snare", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_snare_debuff", "items/item_snare", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_snare_thinker", "items/item_snare", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_snare:GetIntrinsicModifierName()
    return "modifier_item_snare"
end

--particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small_cable.vpcf

function item_snare:OnSpellStart()
    --local kv = {}
	--CreateModifierThinker( self:GetCaster(), self, "modifier_item_snare_thinker", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
	if not IsServer() then return end
	local snare = CreateUnitByName("npc_dota_item_snare", self:GetCaster():GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	snare:AddNewModifier(snare, self, "modifier_item_snare_thinker", {duration = -1})
	snare:SetDayTimeVisionRange(50)
	snare:SetNightTimeVisionRange(50)
	self:SetCurrentCharges(self:GetCurrentCharges() - 1)
end

function item_snare:GetAOERadius()
	return self:GetSpecialValueFor( "AOERadius" )
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_snare = class({})

function modifier_item_snare:IsDebuff() return false end
function modifier_item_snare:IsHidden() return true end
function modifier_item_snare:IsPurgable() return false end
function modifier_item_snare:IsPurgeException() return false end
function modifier_item_snare:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_snare:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_snare:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_snare:OnDestroy()
    if not IsServer() then return end
	local aura = self:GetParent():FindModifierByName("modifier_item_snare_aura")
    if aura then
        aura:Destroy()
    end
    local slow = self:GetParent():FindModifierByName("modifier_item_snare_aura_slow")
    if slow then
        slow:Destroy()
    end
    local thinker = self:GetParent():FindModifierByName("modifier_item_snare_thinker")
    if thinker then
        thinker:Destroy()
    end
end

function modifier_item_snare:DeclareFunctions()
    return 
    {
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

--------------------------------------------------------------------------------
--Thinker
--------------------------------------------------------------------------------
modifier_item_snare_thinker = ({})

function modifier_item_snare_thinker:OnCreated( kv )
	self.ensnare = true
	self:StartIntervalThink(0.2)
	if IsServer() then
		-- attacks
		self.health = self:GetAbility():GetSpecialValueFor( "destroy_attacks" )
		self.hero_attack = self.health/self:GetAbility():GetSpecialValueFor( "destroy_hero_attacks" )
		self.max_health = self.health
	end
end

function modifier_item_snare_thinker:OnDestroy( kv )
	if IsServer() then
		if self:GetAbility() ~= nil then
			self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
		end
		self:GetParent():Destroy()
	end
end

function modifier_item_snare_thinker:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_INVISIBLE]								 = true	
	end
	return state
end

function modifier_item_snare_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
    	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_item_snare_thinker:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_item_snare_thinker:OnAttacked( params )
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

function modifier_item_snare_thinker:OnIntervalThink()
	local parent = self:GetParent()
	
	if IsServer() then
		local targets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, true)	
		for _,enemy in pairs(targets) do
			if self.ensnare == true then
				enemy:AddNewModifier(parent, self:GetAbility(), "modifier_item_snare_debuff", { duration = 2.5 })
				--enemy:AddNewModifier(parent, self:GetAbility(), "modifier_lina_light_strike_array_lua", { duration = 1.5 })
				enemy:AddNewModifier(parent, self:GetAbility(), "modifier_truesight", { duration = 2.5 })
				ApplyDamage({victim = enemy, attacker = parent, damage = 140, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
				self.ensnare = false
				Timers:CreateTimer(2.5, function() 
					self:Destroy()
				end)
			end
		end	
	end
end

--------------------------------------------------------------------------------
--Slow modifier
--------------------------------------------------------------------------------
modifier_item_snare_debuff = class({})

function modifier_item_snare_debuff:IsPurgable() return true end
function modifier_item_snare_debuff:IsDebuff() return true end
--function modifier_item_snare_debuff:IsStunDebuff() return true end

function modifier_item_snare_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_item_snare_debuff:CheckState()
	local state = {}
		--state[MODIFIER_STATE_STUNNED]									= true
		state[MODIFIER_STATE_ROOTED]								= true	
		state[MODIFIER_STATE_DISARMED]								= true	
	
	return state
end

function  modifier_item_snare_debuff:OnCreated()
	if IsServer() then
		self.caster_team = self:GetCaster():GetTeamNumber()
		AddFOWViewer(self.caster_team, self:GetParent():GetAbsOrigin(), 25, 2, false)
	end
end
 
function modifier_item_snare_debuff:GetOverrideAnimation( params )
	--return ACT_DOTA_DISABLED
	return ACT_DOTA_IDLE
end

function modifier_item_snare_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_item_snare_debuff:GetEffectName()
	--return "particles/generic_gameplay/generic_stunned.vpcf"
	--return "particles/generic_gameplay/generic_root.vpcf"
	--return "particles/dev/library/base_overhead_follow.vpcf"
	--return "particles/generic_gameplay/generic_break.vpcf"
end

function modifier_item_snare_debuff:GetTexture()
	return "items/snare"
end