ability_counter_attack_vision = class({})

LinkLuaModifier( "modifier_counter_attack_vision", "abilities/ability_counter_attack_vision", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_counter_attack_vision_debuff", "abilities/ability_counter_attack_vision", LUA_MODIFIER_MOTION_NONE )

function ability_counter_attack_vision:GetIntrinsicModifierName()
    return "modifier_counter_attack_vision"
end

modifier_counter_attack_vision = class({})

function modifier_counter_attack_vision:IsDebuff() return false end
function modifier_counter_attack_vision:IsPurgable() return false end
function modifier_counter_attack_vision:RemoveOnDeath() return false end
function modifier_counter_attack_vision:IsPermanent() return true end
function modifier_counter_attack_vision:IsHidden() return true end

function modifier_counter_attack_vision:OnCreated( kv )
	self:StartIntervalThink(0.1)
	if IsServer() then
		self.regen = 0
		self.agi = 0
		self.arb = 0
				
		local parent = self:GetParent()
		
		if parent ~= nil then
		
		end
    	self:SetHasCustomTransmitterData(true)
    end
end



function modifier_counter_attack_vision:DeclareFunctions()
	local funcs = {
    	MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_counter_attack_vision:OnAttackLanded(params)
	local duration = self:GetAbility():GetSpecialValueFor("VisionDuration")

	if params.target:IsWard() then return end
	if not params.attacker:IsIllusion() and params.target == self:GetParent() and IsServer() then
		params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_truesight", { duration = duration })
		params.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_counter_attack_vision_debuff", { duration = duration })
		params.attacker:MakeVisibleToTeam(self:GetParent():GetTeam(), duration)
    end
end

function modifier_counter_attack_vision:AddCustomTransmitterData()
    return {
        regen = self.regen,
        agi = self.agi,
        arb = self.arb
    }
end

function modifier_counter_attack_vision:HandleCustomTransmitterData( data )
    self.regen = data.regen
    self.agi = data.agi
    self.arb = data.arb
end


function modifier_counter_attack_vision:OnIntervalThink()
	local parent = self:GetParent()
end


modifier_counter_attack_vision_debuff = class({})

function modifier_counter_attack_vision_debuff:IsDebuff() return true end
function modifier_counter_attack_vision_debuff:IsPurgable() return true end
function modifier_counter_attack_vision_debuff:RemoveOnDeath() return true end
function modifier_counter_attack_vision_debuff:IsHidden() return false end


function modifier_counter_attack_vision_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_PROVIDES_VISION ] = true,
	}

	return state
end



