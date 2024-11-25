item_molotov = class({})

LinkLuaModifier( "modifier_item_molotov", "items/item_molotov", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_molotov_debuff", "items/item_molotov", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_molotov_thinker", "items/item_molotov", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_molotov:GetIntrinsicModifierName()
    return "modifier_item_molotov"
end

function item_molotov:OnSpellStart()
	local caster = self:GetCaster()
	
	local cursorPoint = self:GetCursorPosition()
	local casterPoint = caster:GetAbsOrigin()
	
	self.targetPoint = cursorPoint
	
	local direction = cursorPoint - casterPoint
	local distance = direction:Length()
	direction = direction:Normalized()
	
	local speed = self:GetSpecialValueFor("Speed")
	
	local info =
	{
		Ability = self,
		EffectName = "",
		vSpawnOrigin = casterPoint,
		fDistance = distance,
		fStartRadius = 1,
		fEndRadius = self:GetSpecialValueFor("AOERadius"),
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_NONE,
		fExpireTime = GameRules:GetGameTime() + distance / speed + 0.1,
		bDeleteOnHit = false,
		vVelocity = direction * speed,
		bProvidesVision = false
	}
	--particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball.vpcf
	ProjectileManager:CreateLinearProjectile(info)
	
	local t = cursorPoint - casterPoint
	
	local pos = Vector(t.x * 0.5, t.y * 0.5, 100)
	self.p = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_shard_concussive_grenade_model.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(self.p, 0, casterPoint)
	ParticleManager:SetParticleControl(self.p, 1, Vector(speed, 1, 1))
	ParticleManager:SetParticleControl(self.p, 4, cursorPoint + pos) 
	ParticleManager:SetParticleControl(self.p, 5, cursorPoint) 
	--

end

function item_molotov:GetAOERadius()
	return self:GetSpecialValueFor("AOERadius" )
end

function item_molotov:OnProjectileHit(hTarget, vLocation)
	local kv = {}
	if IsServer() then
		CreateModifierThinker(self:GetCaster(), self, "modifier_item_molotov_thinker", kv, vLocation, self:GetCaster():GetTeamNumber(), false)
	end
	ParticleManager:DestroyParticle(self.p, true)
	ParticleManager:ReleaseParticleIndex(self.p)
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_molotov = class({})

function modifier_item_molotov:IsDebuff() return false end
function modifier_item_molotov:IsHidden() return true end
function modifier_item_molotov:IsPurgable() return false end
function modifier_item_molotov:IsPurgeException() return false end
function modifier_item_molotov:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_molotov:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_molotov:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_molotov:OnDestroy()
    if not IsServer() then return end
    local slow = self:GetParent():FindModifierByName("modifier_item_molotov_debuff")
    if slow then
        slow:Destroy()
    end
    local thinker = self:GetParent():FindModifierByName("modifier_item_molotov_thinker")
    if thinker then
        thinker:Destroy()
    end
end

function modifier_item_molotov:DeclareFunctions()
    return 
    {
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

--------------------------------------------------------------------------------
--Thinker
--------------------------------------------------------------------------------
modifier_item_molotov_thinker = ({})

function modifier_item_molotov_thinker:IsHidden()	return true end
function modifier_item_molotov_thinker:IsAura()	return true end

function modifier_item_molotov_thinker:OnCreated( kv )
	self:StartIntervalThink(0.2)
	self.aoe = self:GetAbility():GetSpecialValueFor( "AOERadius" )
	if IsServer() then
		p = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(p, 0, self:GetParent():GetOrigin())
		ParticleManager:SetParticleControl(p, 1, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl(p, 2, Vector( 8, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex(p)
		
		Timers:CreateTimer(8, function() 
			ParticleManager:DestroyParticle(p, false)
			
			UTIL_Remove( self:GetParent() )
		end)
	end
end

function modifier_item_molotov_thinker:OnDestroy( kv )
	if IsServer() then
		self:GetParent():Destroy()
	end
end

function modifier_item_molotov_thinker:CheckState()
	local state = {}
	if IsServer() then
		
	end
	return state
end

function modifier_item_molotov_thinker:GetAuraRadius()
    return self.aoe
end

function modifier_item_molotov_thinker:GetModifierAura()
    return "modifier_item_molotov_debuff"
end
   
function modifier_item_molotov_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_molotov_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_molotov_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_item_molotov_thinker:GetAuraDuration()
    return 0.2
end


function modifier_item_molotov_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
    	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------
--Slow modifier
--------------------------------------------------------------------------------
modifier_item_molotov_debuff = class({})

function modifier_item_molotov_debuff:IsPurgable() return true end
function modifier_item_molotov_debuff:IsDebuff() return true end
--function modifier_item_molotov_debuff:IsStunDebuff() return true end

function modifier_item_molotov_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_item_molotov_debuff:CheckState()
	local state = {}
		--state[MODIFIER_STATE_STUNNED]									= true
		--state[MODIFIER_STATE_ROOTED]								= true	
		--state[MODIFIER_STATE_DISARMED]								= true	
	
	return state
end

function  modifier_item_molotov_debuff:OnCreated()
	self:StartIntervalThink(0.25)
end

function modifier_item_molotov_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	
	if IsServer() then
		ApplyDamage({victim = parent, attacker = caster, damage = 15, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
	end
end

function modifier_item_molotov_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -25 
end


function modifier_item_molotov_debuff:GetTexture()
	return "items/molotov"
end