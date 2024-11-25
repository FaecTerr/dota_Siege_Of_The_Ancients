modifier_shell_agility = class({})

LinkLuaModifier( "modifier_shell_agility", "modifiers/modifier_shell_agility", LUA_MODIFIER_MOTION_NONE )

function modifier_shell_agility:IsDebuff() return false end
function modifier_shell_agility:IsPurgable() return false end
function modifier_shell_agility:RemoveOnDeath() return false end
function modifier_shell_agility:IsPermanent() return true end
function modifier_shell_agility:IsHidden() return false end

function modifier_shell_agility:OnCreated( kv )
	self:StartIntervalThink(0.2)
	self.stacks = 0
    self:SetHasCustomTransmitterData(true)
end

function modifier_shell_agility:OnIntervalThink()
  	local parent = self:GetParent()

end


function modifier_shell_agility:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS ,
		MODIFIER_EVENT_SPELL_APPLIED_SUCCESSFULLY 
	}
	return funcs
end

function modifier_shell_agility:GetModifierBonusStats_Agility()

	return self:GetStackCount() * 0.50 * self:GetParent():GetLevel()
end



function modifier_shell_agility:OnSpellAppliedSuccessfully(event)
	local target = event.target
	local ability = event.ability
	
	local name = event.ability:GetAbilityName()

	
	
	if name == "dark_seer_ion_shell" then
		if target ~= nil then
			
			if not target:HasModifier("modifier_dark_seer_ion_shell") then
				self:IncrementStackCount()
				self:SendBuffRefreshToClients()
				
				local time = event.ability:GetSpecialValueFor("duration")
				
				Timers:CreateTimer(time, function() 
					self:DecrementStackCount()
					self:SendBuffRefreshToClients()
					--print("D")
				end)
			
				self:GetParent():CalculateStatBonus(true)
			else
				local shell = target:FindModifierByName("modifier_dark_seer_ion_shell")
				local remainingTime = shell:GetRemainingTime()
				
				local time = event.ability:GetSpecialValueFor("duration")
				
				Timers:CreateTimer(remainingTime, function() 
					self:IncrementStackCount()
					self:SendBuffRefreshToClients()
				end)
				Timers:CreateTimer(time, function() 
					self:DecrementStackCount()
					self:SendBuffRefreshToClients()
				end)
			end	
		end
	end
end

function modifier_shell_agility:AddCustomTransmitterData()
    return {
        stacks = self.stacks
    }
end

function modifier_shell_agility:HandleCustomTransmitterData( data )
    self.stacks = data.stacks
end



function modifier_shell_agility:GetTexture()
	return "modifier_shell_agility"
end















