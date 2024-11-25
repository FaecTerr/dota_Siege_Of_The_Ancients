modifier_raised_from_dead = class({})

function modifier_raised_from_dead:IsDebuff() return false end
function modifier_raised_from_dead:IsPurgable() return false end
function modifier_raised_from_dead:RemoveOnDeath() return true end
function modifier_raised_from_dead:IsPermanent() return false end
function modifier_raised_from_dead:IsHidden() return false end

function modifier_raised_from_dead:OnCreated( kv )   	
	self:StartIntervalThink(0.2)
	
	local parent = self:GetParent()
	
	self.max_hp_penalty = parent:GetMaxHealth() * 0.5
end

function modifier_raised_from_dead:OnIntervalThink()
  	local parent = self:GetParent()
  	  	
end


function modifier_raised_from_dead:DeclareFunctions()
	local funcs = {	
		MODIFIER_PROPERTY_FORCE_MAX_HEALTH,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_raised_from_dead:CheckState()
	local state = {}
	if IsServer() then	
	end
	return state
end

function modifier_raised_from_dead:GetModifierForceMaxHealth()
	return self.max_hp_penalty
end

function modifier_raised_from_dead:GetModifierHPRegenAmplify_Percentage()
	return -50
end






















