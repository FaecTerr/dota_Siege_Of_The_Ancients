modifier_damage_resist = class({})

function modifier_damage_resist:IsDebuff() return false end
function modifier_damage_resist:IsPurgable() return false end
function modifier_damage_resist:RemoveOnDeath() return false end
function modifier_damage_resist:IsPermanent() return true end
function modifier_damage_resist:IsHidden() return false end

function modifier_damage_resist:DeclareFunctions()
	local funcs = {
  		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_damage_resist:GetModifierIncomingDamage_Percentage(event)
	local damageMod = self:GetStackCount() * 0.12
	local damage = (1 - damageMod)
	
	if not IsServer() then
		return damageMod * 100
	end
	
	if event.target ~= self:GetParent() then
		return
	end
	
	--print(event.damage .. " / " ..event.original_damage .. " (" .. damageMod * 100 .. ")")
	return -damageMod * 100
end