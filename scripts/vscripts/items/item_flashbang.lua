item_flashbang = class({})

LinkLuaModifier( "modifier_item_flashbang", "items/item_flashbang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_flashbang_debuff", "items/item_flashbang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_flashbang_thinker", "items/item_flashbang", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_flashbang_stun", "items/item_flashbang", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_flashbang:GetIntrinsicModifierName()
    return "modifier_item_flashbang"
end

function item_flashbang:OnSpellStart()
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

function item_flashbang:GetAOERadius()
	return self:GetSpecialValueFor("AOERadius" )
end

function item_flashbang:OnProjectileHit(hTarget, vLocation)
	local kv = {}
	if IsServer() then
		CreateModifierThinker(self:GetCaster(), self, "modifier_item_flashbang_thinker", kv, vLocation, self:GetCaster():GetTeamNumber(), false)
	end
	ParticleManager:DestroyParticle(self.p, true)
	ParticleManager:ReleaseParticleIndex(self.p)
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_flashbang = class({})

function modifier_item_flashbang:IsDebuff() return false end
function modifier_item_flashbang:IsHidden() return true end
function modifier_item_flashbang:IsPurgable() return false end
function modifier_item_flashbang:IsPurgeException() return false end
function modifier_item_flashbang:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_flashbang:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_flashbang:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_flashbang:OnDestroy()
    if not IsServer() then return end
    local slow = self:GetParent():FindModifierByName("modifier_item_flashbang_debuff")
    if slow then
        slow:Destroy()
    end
    local thinker = self:GetParent():FindModifierByName("modifier_item_flashbang_thinker")
    if thinker then
        thinker:Destroy()
    end
end

function modifier_item_flashbang:DeclareFunctions()
    return 
    {
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

--------------------------------------------------------------------------------
--Thinker
--------------------------------------------------------------------------------
modifier_item_flashbang_thinker = ({})

function modifier_item_flashbang_thinker:IsHidden()	return true end
function modifier_item_flashbang_thinker:IsAura()	return true end

function modifier_item_flashbang_thinker:OnCreated( kv )
	self:StartIntervalThink(0.2)
	self.aoe = self:GetAbility():GetSpecialValueFor( "AOERadius" )
	
	EmitSoundOn( "Hero_Sven.StormBoltImpact", self:GetParent() )
	
	if IsServer() then
		
		local enemies = FindUnitsInRadius(
        self:GetCaster():GetTeam(), 
        self:GetParent():GetAbsOrigin(),  
        nil,    
        self.aoe,  
        DOTA_UNIT_TARGET_TEAM_BOTH,
       	DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        true
    	)
	
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_flashbang_debuff", { duration = self:GetAbility():GetSpecialValueFor( "BlindDuration" ) })
		end	
		
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_item_flashbang_thinker:OnDestroy( kv )
	if IsServer() then
		self:GetParent():Destroy()
	end
end

function modifier_item_flashbang_thinker:CheckState()
	local state = {}
	if IsServer() then
		
	end
	return state
end

function modifier_item_flashbang_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
    	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------
--Debuff
--------------------------------------------------------------------------------
modifier_item_flashbang_debuff = class({})

function modifier_item_flashbang_debuff:IsPurgable() return true end
function modifier_item_flashbang_debuff:IsDebuff() return true end

function modifier_item_flashbang_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FOW_TEAM,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_VISION_DEGREES_RESTRICTION,
	}

	return funcs
end

function  modifier_item_flashbang_debuff:GetModifierFoWTeam()
	return -1 
end

function  modifier_item_flashbang_debuff:GetModifierProvidesFOWVision()
	return -1
end

function  modifier_item_flashbang_debuff:GetVisionDegreeRestriction()
	return 360 
end

function modifier_item_flashbang_debuff:CheckState()
	local state = {}
		state[MODIFIER_STATE_BLIND]				= true
		state[MODIFIER_STATE_PROVIDES_VISION ] 	= false
	
	return state
end

function  modifier_item_flashbang_debuff:OnCreated()
	self:StartIntervalThink(0.25)
	
	local caster = self:GetCaster()
	local parent = self:GetParent()
	
	if parent ~= nil and IsServer() then
		if caster ~= parent and caster:GetTeam() ~= parent:GetTeam() or caster == parent then
			parent:AddNewModifier(caster, self, "modifier_item_flashbang_stun", { duration = 0.4 })
		end
	end
end

function modifier_item_flashbang_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	
	if IsServer() then
		
	end
end


function modifier_item_flashbang_debuff:GetTexture()
	return "items/flashbang"
end

--------------------------------------------------------------------------------
--Stun
--------------------------------------------------------------------------------
modifier_item_flashbang_stun = class({})

function modifier_item_flashbang_stun:IsDebuff() return true end
function modifier_item_flashbang_stun:IsStunDebuff() return true end

function modifier_item_flashbang_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_item_flashbang_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end

function modifier_item_flashbang_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_item_flashbang_stun:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end



function modifier_item_flashbang_stun:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
	--return ACT_DOTA_IDLE
end





function modifier_item_flashbang_stun:GetTexture()
	return "items/flashbang"
end