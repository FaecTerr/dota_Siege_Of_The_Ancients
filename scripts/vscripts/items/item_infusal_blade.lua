item_infusal_blade = class({})

LinkLuaModifier( "modifier_item_infusal_blade", "items/item_infusal_blade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_infusal_blade_debuff", "items/item_infusal_blade", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_infusal_blade:GetIntrinsicModifierName()
  return "modifier_item_infusal_blade"
end

function item_infusal_blade:OnSpellStart()
    local caster = self:GetCaster()   	
    local target = self:GetCursorTarget()
    
    if target ~= nil then
    	target:AddNewModifier(caster, self, "modifier_item_infusal_blade_debuff", { duration = 4 })
    end  
end

--------------------------------------------------------------------------------

modifier_item_infusal_blade = class({})

function modifier_item_infusal_blade:IsHidden() return true end
function modifier_item_infusal_blade:IsPurgable() return false end
function modifier_item_infusal_blade:IsPurgeException() return false end
function modifier_item_infusal_blade:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_infusal_blade:DeclareFunctions()
  local funcs = 
  {
  	MODIFIER_EVENT_ON_ATTACK_LANDED,
  	  	
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  }
  return funcs
end

function modifier_item_infusal_blade:OnAttackLanded(params)
	local caster = self:GetParent()	
	
	if params.target == nil then return end
	
	local target = params.target
	
	local Manaburn = target:GetMana()
	local ManaBreak = self:GetAbility():GetSpecialValueFor("ManaBreak")
	if Manaburn > ManaBreak then
		Manaburn = ManaBreak
	end
		
	target:SetMana(target:GetMana() - Manaburn)	
	caster:SetMana(caster:GetMana() + Manaburn * 0.5 * (1 - target:GetBaseMagicalResistanceValue() * 0.01))
	
	local damageInfo =  {
                    victim = target,
                    attacker = caster,
                    damage = Manaburn,
                    damage_flags = DOTA_DAMAGE_FLAG_NONE,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility()
                }
	
	ApplyDamage(damageInfo)
end

function modifier_item_infusal_blade:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("AgilityBonus")
end

function modifier_item_infusal_blade:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("IntelligenceBonus")
end

--------------------------------------------------------------------------------
modifier_item_infusal_blade_debuff = class({})

function modifier_item_infusal_blade_debuff:IsDebuff() return true end
function modifier_item_infusal_blade_debuff:IsHidden() return false end
function modifier_item_infusal_blade_debuff:IsPurgable() return true end
function modifier_item_infusal_blade_debuff:IsPurgeException() return false end
function modifier_item_infusal_blade_debuff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_infusal_blade_debuff:DeclareFunctions()
  	local funcs = 
  	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  	}
  	return funcs
end


function modifier_item_infusal_blade_debuff:OnCreated()
	self:StartIntervalThink(0.8)
	self.effectivness = 1.0
end

function modifier_item_infusal_blade_debuff:OnIntervalThink()
  	self.effectivness = self.effectivness - 0.2
end

function modifier_item_infusal_blade_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -1.0 * self.effectivness * 100.0
end

function modifier_item_infusal_blade_debuff:GetTexture()
	return "items/infusal_blade"
end




