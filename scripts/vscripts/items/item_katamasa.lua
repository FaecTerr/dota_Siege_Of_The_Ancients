item_katamasa = class({})

LinkLuaModifier( "modifier_item_katamasa", "items/item_katamasa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_katamasa_debuff", "items/item_katamasa", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_katamasa:GetIntrinsicModifierName()
    return "modifier_item_katamasa"
end

--particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small_cable.vpcf

function item_katamasa:OnSpellStart()
	local caster = self:GetCaster()
	
	local cursorPoint = self:GetCursorPosition()
	local casterPoint = caster:GetAbsOrigin()
	
	EmitSoundOn( "Hero_VoidSpirit.AstralStep.Start", caster)
	
	local direction = cursorPoint - casterPoint
	local distance = direction:Length2D()
	
    cursorPoint = casterPoint + (direction):Normalized() * self:GetSpecialValueFor("AbilityCastRange")
  
	space = FindClearSpaceForUnit( caster, cursorPoint, true )
	if not space then
		caster:SetAbsOrigin(cursorPoint)
	end
	
	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", PATTACH_WORLDORIGIN , caster)
	ParticleManager:SetParticleControl(p, 0, casterPoint) 
	ParticleManager:SetParticleControl(p, 1, cursorPoint) 
	
	local enemies = FindUnitsInLine(
        caster:GetTeam(), 
        casterPoint,    
        cursorPoint,
        nil,    
        250,  
        DOTA_UNIT_TARGET_TEAM_ENEMY,
       	DOTA_UNIT_TARGET_ALL, 
        DOTA_UNIT_TARGET_FLAG_NONE
    )
	
	local hitHero = false
	
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_item_katamasa_debuff", { duration = self:GetSpecialValueFor("BreakDuration") })
		caster:PerformAttack(enemy, true, true, true, false, false, false, true)
		
        --SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, enemy, caster:GetAverageTrueAttackDamage(), caster)
		--local damageInfo =  {
                    --victim = enemy,
                    --attacker = caster,
                    --damage = caster:GetAverageTrueAttackDamage(nil),
                    --damage_flags = DOTA_DAMAGE_FLAG_NONE,
                    --damage_type = DAMAGE_TYPE_PHYSICAL,
                    --ability = self
        --}
		--ApplyDamage(damageInfo)
		EmitSoundOn( "Hero_VoidSpirit.AstralStep.Target", enemy )		
		EmitSoundOn( "siegeoftheancients.Headshot", enemy )
		if enemy:IsHero()  then
			hitHero = true
		end
	end	
	
	if hitHero == true and self:GetLevel() > 1 and IsServer() then
		self:SetLevel(self:GetLevel() - 1)
	end
	
	EmitSoundOn( "Hero_VoidSpirit.AstralStep.End", caster )
end

function item_katamasa:GetCastRange()
    if IsServer() then
    	return 0
    end
    return self:GetSpecialValueFor("AbilityCastRange")
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_katamasa = class({})

function modifier_item_katamasa:IsDebuff() return false end
function modifier_item_katamasa:IsHidden() return true end
function modifier_item_katamasa:IsPurgable() return false end
function modifier_item_katamasa:IsPurgeException() return false end
function modifier_item_katamasa:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_katamasa:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_katamasa:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_katamasa:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        
  		MODIFIER_EVENT_ON_HERO_KILLED,
    }
end

function modifier_item_katamasa:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("BonusDamage")
end

function modifier_item_katamasa:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("BonusInt")
end

function modifier_item_katamasa:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("BonusHealth")
end

function modifier_item_katamasa:OnHeroKilled(params)
    local parent = self:GetParent()
    if parent == nil then return end
    if IsServer() and params.attacker == parent  then
    	if self:GetAbility():GetLevel() < 4 then
    		self:GetAbility():SetLevel(self:GetAbility():GetLevel() + 2)
    	else
    		self:GetAbility():SetLevel(5)
    	end
    end
    return 
end

--------------------------------------------------------------------------------
--Slow modifier
--------------------------------------------------------------------------------
--
modifier_item_katamasa_debuff = class({})

function modifier_item_katamasa_debuff:IsDebuff() return true end
function modifier_item_katamasa_debuff:IsStunDebuff() return false end
function modifier_item_katamasa_debuff:IsHidden() return false end
function modifier_item_katamasa_debuff:IsPurgable() return true end
function modifier_item_katamasa_debuff:ShouldUseOverheadOffset() return true end

function modifier_item_katamasa_debuff:CheckState()
	local state = {}
	
		state[MODIFIER_STATE_PASSIVES_DISABLED]			 = true
	
	return state
end

function modifier_item_katamasa_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end


function modifier_item_katamasa_debuff:GetEffectName()

	--return "particles/dev/library/base_overhead_follow.vpcf"
	return "particles/generic_gameplay/generic_break.vpcf"
end

function modifier_item_katamasa_debuff:GetTexture()
	return "items/katamasa"
end
