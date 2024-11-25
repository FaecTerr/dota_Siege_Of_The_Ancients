modifier_courier_invul = class({})

function modifier_courier_invul:IsDebuff() return false end
function modifier_courier_invul:IsPurgable() return false end
function modifier_courier_invul:RemoveOnDeath() return false end
function modifier_courier_invul:IsPermanent() return true end
function modifier_courier_invul:IsHidden() return true end

function modifier_courier_invul:OnCreated( kv )   	
		self:StartIntervalThink(0.2)
end

function modifier_courier_invul:OnIntervalThink()
  	local parent = self:GetParent()
  	
  	if parent:IsCourier() then
  		self.buff_active = true
  	else
  		self:Destroy()
  	end
  	
end


function modifier_courier_invul:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_DAY_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,		
	}
	return funcs
end

function modifier_courier_invul:CheckState()
	local state = {}
	if IsServer() then	
		state[MODIFIER_STATE_INVULNERABLE]							 = self.buff_active
		state[MODIFIER_STATE_MAGIC_IMMUNE]							 = self.buff_active
		state[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES ]			 = self.buff_active
		state[MODIFIER_STATE_UNSLOWABLE]							 = self.buff_active
		state[MODIFIER_STATE_UNTARGETABLE]							 = self.buff_active
		state[MODIFIER_STATE_DEBUFF_IMMUNE]							 = self.buff_active
	end
	return state
end

function modifier_courier_invul:GetModifierMoveSpeedBonus_Constant()
	return 2000
end

function modifier_courier_invul:GetBonusDayVisionPercentage()
	return -100
end

function modifier_courier_invul:GetBonusVisionPercentage()
	return -100
end






















