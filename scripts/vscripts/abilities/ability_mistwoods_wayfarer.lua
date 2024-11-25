ability_mistwoods_wayfarer = class({})

LinkLuaModifier( "modifier_hero_hoodwink_extrainnate", "abilities/ability_mistwoods_wayfarer", LUA_MODIFIER_MOTION_NONE )

function ability_mistwoods_wayfarer:GetIntrinsicModifierName()
    return "modifier_hero_hoodwink_extrainnate"
end

modifier_hero_hoodwink_extrainnate = class({})

function modifier_hero_hoodwink_extrainnate:IsDebuff() return false end
function modifier_hero_hoodwink_extrainnate:IsPurgable() return false end
function modifier_hero_hoodwink_extrainnate:RemoveOnDeath() return false end
function modifier_hero_hoodwink_extrainnate:IsPermanent() return true end
function modifier_hero_hoodwink_extrainnate:IsHidden() return false end

function modifier_hero_hoodwink_extrainnate:OnCreated( kv )
	self:StartIntervalThink(0.1)
	if IsServer() then
		self.regen = 0
		self.agi = 0
		self.arb = 0
		self.vision = false
		self.resetStacksTimer = 0
		self.gainStacksTimer = 0
				
		local parent = self:GetParent()
		
		if parent ~= nil then
		
			local ability = parent:FindAbilityByName("hoodwink_scurry")		
			local level = 0
			
			if ability ~= nil then	
				level = ability:GetLevel()
			end
			local treeTable = GridNav:GetAllTreesAroundPoint(parent:GetAbsOrigin(), 275, false)
			
			self.agi = (level * self:GetAbility():GetSpecialValueFor("BaseAgi") + self:GetAbility():GetSpecialValueFor("BonusAgi")) * 1					
			self.regen = (parent:GetAgility() + self.agi) * 0.01 + 1 * 0.1
			
			self:SetStackCount(#treeTable)
		end
    	self:SetHasCustomTransmitterData(true)
    end
end

function modifier_hero_hoodwink_extrainnate:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_FORCED_FLYING_VISION]			 = self.vision
	end
	return state
end

function modifier_hero_hoodwink_extrainnate:DeclareFunctions()
	local funcs = {
  		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
  		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,   
    	MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_hero_hoodwink_extrainnate:GetModifierConstantManaRegen()
	return self.regen
end

function modifier_hero_hoodwink_extrainnate:GetModifierConstantHealthRegen()
	return self.regen * 1.25
end

function modifier_hero_hoodwink_extrainnate:GetModifierBonusStats_Agility()
	return self.agi
end

function modifier_hero_hoodwink_extrainnate:GetModifierAttackRangeBonus()
	return self.arb
end

function modifier_hero_hoodwink_extrainnate:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsWard() then return end
	if not params.attacker:IsIllusion() and not params.target:IsHero() then
		Timers:CreateTimer(0.3, function ()			
			ApplyDamage({victim = params.target, attacker = self:GetParent(), damage = self.agi, damage_type = DAMAGE_TYPE_MAGICAL, nil })
		end)        
    end
end

function modifier_hero_hoodwink_extrainnate:AddCustomTransmitterData()
    return {
        regen = self.regen,
        agi = self.agi,
        arb = self.arb
    }
end

function modifier_hero_hoodwink_extrainnate:HandleCustomTransmitterData( data )
    self.regen = data.regen
    self.agi = data.agi
    self.arb = data.arb
end


function modifier_hero_hoodwink_extrainnate:OnIntervalThink()
	local parent = self:GetParent()
		
	if IsServer() then
			if parent:HasScepter() then
		self:GetAbility():SetLevel(2)
	else
		self:GetAbility():SetLevel(1)
	end
	
		self.regen = 0
		self.agi = 0
		self.arb = 0
	

	
		if parent ~= nil  then
			local ability = parent:FindAbilityByName("hoodwink_scurry")		
			local level = 0
						
			if ability ~= nil then	
				level = ability:GetLevel()
			end			
											
			local maximumStacks = self:GetAbility():GetSpecialValueFor("MaximumStacks")
			local lingerTimer = self:GetAbility():GetSpecialValueFor("LingerTimer")
			local gainTimer = self:GetAbility():GetSpecialValueFor("GainTimer")
			local range = self:GetAbility():GetSpecialValueFor("AbilityAoE")
			local stackPower = 2
			
			if parent:HasScepter() then
				maximumStacks = 10
				lingerTimer = 3
				range = self:GetAbility():GetSpecialValueFor("AbilityAoE") + 75
				stackPower = 3
			end
			
			local treeTable = GridNav:GetAllTreesAroundPoint(parent:GetAbsOrigin(), range, false)
			
			--Remove stacks on a cd
			if self.resetStacksTimer > 0 then
				self.resetStacksTimer = self.resetStacksTimer - 0.1
			else
				if self:GetStackCount() > 0 then
					self:SetStackCount(self:GetStackCount() - 1)
					self.resetStacksTimer = lingerTimer
				end
			end
			
			--Gain stacks cd
			if self.gainStacksTimer > 0 then
				self.gainStacksTimer = self.gainStacksTimer - 0.1
			end
			
			local effectiveStacks = #treeTable
			if effectiveStacks > maximumStacks then
				effectiveStacks = maximumStacks
			end
			
			--Gain stacks + Reset lose stacks cd
			if self:GetStackCount() < effectiveStacks and effectiveStacks > 0 and self.gainStacksTimer <= 0 then
				self:SetStackCount(self:GetStackCount() + 1)
				self.resetStacksTimer = lingerTimer
				self.gainStacksTimer = gainTimer / stackPower
			end
			
			
			self.agi = (level * stackPower * 0.5 + self:GetAbility():GetSpecialValueFor("BaseAgi")) * self:GetStackCount()
			self.regen = ((parent:GetAgility() + self.agi) * 0.05 + self:GetStackCount() * 0.5)
			
			--Attack Range Bonus: 30 lvl-0 scurry at max stacks, 150 lvl-4 scurry at max stacks, 225 lvl-4 scurry at max stacks with aghs
			self.arb = self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("AttackRangeBonus") * (level + 1)) * 0.5 * stackPower
			
			if not parent:HasModifier("modifier_attacker_respawn") then
				AddFOWViewer(parent:GetTeam(), parent:GetAbsOrigin(), (self:GetAbility():GetSpecialValueFor("VisionBase") + self:GetAbility():GetSpecialValueFor("VisionBonus") * level * self:GetStackCount()), 0.2, false)
			end
			
			if self:GetStackCount() >= 3 then
				self.vision = false
			else
				self.vision = false
			end
		end
		self:SendBuffRefreshToClients()
	end
end

function modifier_hero_hoodwink_extrainnate:GetTexture()
	return "Scurry_icon"
end


