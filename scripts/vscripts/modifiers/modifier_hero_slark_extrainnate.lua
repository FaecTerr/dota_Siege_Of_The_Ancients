modifier_hero_slark_extrainnate = class({})

LinkLuaModifier( "modifier_hero_slark_extrainnate", "modifiers/modifier_hero_slark_extrainnate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_slark_extrainnate_buff", "modifiers/modifier_hero_slark_extrainnate", LUA_MODIFIER_MOTION_NONE )

function modifier_hero_slark_extrainnate:IsDebuff() return false end
function modifier_hero_slark_extrainnate:IsPurgable() return false end
function modifier_hero_slark_extrainnate:RemoveOnDeath() return false end
function modifier_hero_slark_extrainnate:IsPermanent() return true end
function modifier_hero_slark_extrainnate:IsHidden() return true end

function modifier_hero_slark_extrainnate:OnCreated( kv )
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

function modifier_hero_slark_extrainnate:DeclareFunctions()
	local funcs = {
  		MODIFIER_EVENT_ON_DEATH,
  		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return funcs
end

function modifier_hero_slark_extrainnate:GetModifierConstantManaRegen()
	return self.regen
end

function modifier_hero_slark_extrainnate:OnDeath(params)
	local caster = self:GetCaster()	
    
    local attacker = params.attacker
    local target = params.unit
    
	LinkLuaModifier("modifier_slark_essence_shift_buff", "modifiers/modifier_slark_essence_shift_buff", LUA_MODIFIER_MOTION_NONE )
		
    if mod == nil and attacker ~= nil and attacker == caster and target:GetTeam() ~= attacker:GetTeam() and not target:IsHero() then
		local ability = attacker:FindAbilityByName("slark_essence_shift")
		if IsServer() and ability ~= nil then
			local level = ability:GetLevel()			
			
			local mod = caster:FindModifierByName("modifier_hero_slark_extrainnate_buff")
			if mod ~= nil then
				mod:SetStackCount(mod:GetStackCount() + 1)
				mod:SetDuration(20 * level, true)
			else				
				mod = caster:AddNewModifier(caster, ability, "modifier_hero_slark_extrainnate_buff", {duration = 20 * level })				
				mod:SetStackCount(mod:GetStackCount() + 1)
			end
			
			Timers:CreateTimer(20 * level, function()
				if caster ~= nil and IsServer() then
					local mod = caster:FindModifierByName("modifier_hero_slark_extrainnate_buff")
					if mod ~= nil then
						mod:SetStackCount(mod:GetStackCount() - 1)
					end
				end
			end)	
		end
  	end
end

function modifier_hero_slark_extrainnate:AddCustomTransmitterData()
    return {
        regen = self.regen,
    }
end
function modifier_hero_slark_extrainnate:HandleCustomTransmitterData( data )
    self.regen = data.regen
end


function modifier_hero_slark_extrainnate:OnIntervalThink()
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

modifier_hero_slark_extrainnate_buff = class({})

function modifier_hero_slark_extrainnate_buff:IsDebuff() return false end
function modifier_hero_slark_extrainnate_buff:IsPurgable() return false end
function modifier_hero_slark_extrainnate_buff:RemoveOnDeath() return true end
function modifier_hero_slark_extrainnate_buff:IsPermanent() return false end
function modifier_hero_slark_extrainnate_buff:IsHidden() return false end

function modifier_hero_slark_extrainnate_buff:DeclareFunctions()
	local funcs = {
  		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_hero_slark_extrainnate_buff:GetModifierBonusStats_Agility()
	return 3 * self:GetStackCount()
end

function modifier_hero_slark_extrainnate_buff:GetTexture()
	return "Essence_Shift_icon"
end





