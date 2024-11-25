modifier_hero_tidehunter_extrainnate = class({})

LinkLuaModifier( "modifier_hero_tidehunter_extrainnate", "modifiers/modifier_hero_tidehunter_extrainnate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_tidehunter_extrainnate_buff", "modifiers/modifier_hero_tidehunter_extrainnate", LUA_MODIFIER_MOTION_NONE )

function modifier_hero_tidehunter_extrainnate:IsDebuff() return false end
function modifier_hero_tidehunter_extrainnate:IsPurgable() return false end
function modifier_hero_tidehunter_extrainnate:RemoveOnDeath() return false end
function modifier_hero_tidehunter_extrainnate:IsPermanent() return true end
function modifier_hero_tidehunter_extrainnate:IsHidden() return true end

function modifier_hero_tidehunter_extrainnate:OnCreated( kv )
	self:StartIntervalThink(0.2)
	if IsServer() then
		self.regen = 0
		
		local parent = self:GetParent()
		if parent ~= nil then
			self.regen = parent:GetHealthRegen() * 0.01
		end
    	self:SetHasCustomTransmitterData(true)
    end
end

function modifier_hero_tidehunter_extrainnate:DeclareFunctions()
	local funcs = {
  		MODIFIER_EVENT_ON_ABILITY_START,
  		--MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_hero_tidehunter_extrainnate:GetModifierConstantManaRegen()
	return self.regen
end

function modifier_hero_tidehunter_extrainnate:OnAbilityStart(params)
	local caster = self:GetCaster()	
    local target = params.target
    local ability = params.ability
    
	LinkLuaModifier("modifier_tidehunter_essence_shift_buff", "modifiers/modifier_tidehunter_essence_shift_buff", LUA_MODIFIER_MOTION_NONE )
		
    if params.ability:GetName() == "tidehunter_anchor_smash" then
		if IsServer() and ability ~= nil then
			local level = ability:GetLevel()
			local damage = 0
			
			local damage_reduction = 0.2 + level * 0.1
			
			if self:GetCaster():HasAbility("special_bonus_unique_tidehunter_3") then
				damage_reduction = damage_reduction + 0.3
			end
			
			local enemies = FindUnitsInRadius(
        		caster:GetTeam(), 
        		caster:GetAbsOrigin(),    
        		nil,    
        		375,  
        		DOTA_UNIT_TARGET_TEAM_ENEMY,
       			DOTA_UNIT_TARGET_ALL, 
        		DOTA_UNIT_TARGET_FLAG_NONE,
        		FIND_ANY_ORDER,
        		true
    		)
			local e = 1
			
			for _,enemy in pairs(enemies) do
				e = 1
				
				if enemy:IsHero() then
					e = 0.5
				end
				
				--print(enemy:GetUnitName())
			
				damage = damage + enemy:GetAverageTrueAttackDamage(nil) * damage_reduction * e
			end	
			
			local mod = caster:FindModifierByName("modifier_hero_tidehunter_extrainnate_buff")
			if mod ~= nil then
				mod:SetStackCount(mod:GetStackCount() + damage)
				mod:SetDuration(6, true)
			else				
				mod = caster:AddNewModifier(caster, ability, "modifier_hero_tidehunter_extrainnate_buff", {duration =  6 })				
				mod:SetStackCount(mod:GetStackCount() + damage)
			end
			
			Timers:CreateTimer(6, function()
				local mod = caster:FindModifierByName("modifier_hero_tidehunter_extrainnate_buff")
				if mod ~= nil then
					mod:SetStackCount(mod:GetStackCount() - damage)
				end
			end)	
		end
  	end
end

function modifier_hero_tidehunter_extrainnate:AddCustomTransmitterData()
    return {
        regen = self.regen,
    }
end
function modifier_hero_tidehunter_extrainnate:HandleCustomTransmitterData( data )
    self.regen = data.regen
end


function modifier_hero_tidehunter_extrainnate:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
	
		self.regen = 0
	
		if parent ~= nil then
			self.regen = parent:GetHealthRegen() * 0.01
		end
	
		self:SendBuffRefreshToClients()
	end
end


--------------------------------------------------------------------------------

modifier_hero_tidehunter_extrainnate_buff = class({})

function modifier_hero_tidehunter_extrainnate_buff:IsDebuff() return false end
function modifier_hero_tidehunter_extrainnate_buff:IsPurgable() return false end
function modifier_hero_tidehunter_extrainnate_buff:RemoveOnDeath() return true end
function modifier_hero_tidehunter_extrainnate_buff:IsPermanent() return false end
function modifier_hero_tidehunter_extrainnate_buff:IsHidden() return false end

function modifier_hero_tidehunter_extrainnate_buff:DeclareFunctions()
	local funcs = {
  		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_hero_tidehunter_extrainnate_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * 1
end

function modifier_hero_tidehunter_extrainnate_buff:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * 1
end

function modifier_hero_tidehunter_extrainnate_buff:GetTexture()
	return "tidehunter_anchor_smash"
end





