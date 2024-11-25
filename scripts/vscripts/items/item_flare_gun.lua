item_flare_gun = class({})

LinkLuaModifier( "modifier_item_flare_gun", "items/item_flare_gun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_flare_gun_aura", "items/item_flare_gun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_flare_gun_aura_slow", "items/item_flare_gun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_flare_gun_thinker", "items/item_flare_gun", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_flare_gun:GetIntrinsicModifierName()
    return "modifier_item_flare_gun"
end

--particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small_cable.vpcf
p = nil
function item_flare_gun:OnSpellStart()
	local caster = self:GetCaster()
	
	local cursorPoint = self:GetCursorPosition()
	local casterPoint = caster:GetAbsOrigin()
	
	local direction = cursorPoint - casterPoint
	local distance = direction:Length()
	direction = direction:Normalized()
	
	local speed = self:GetSpecialValueFor("Speed")
	
	self.p = ParticleManager:CreateParticle("particles/econ/items/clockwerk/clockwerk_2022_cc/clockwerk_2022_cc_rocket_flare.vpcf", PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(self.p, 0, casterPoint) 
	ParticleManager:SetParticleControl(self.p, 1, cursorPoint) 	
	ParticleManager:SetParticleControl(self.p, 2, Vector(speed, 0)) 
	
	EmitSoundOn( "Hero_Rattletrap.Rocket_Flare.Fire ", caster )
	EmitSoundOn( "Hero_Rattletrap.Rocket_Flare.Travel ", caster )
	
	local info =
	{
		Ability = self,
		EffectName = "particles/econ/items/clockwerk/clockwerk_2022_cc/clockwerk_2022_cc_rocket_flare.vpcf",
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
		bProvidesVision = true,
		iVisionRadius = self:GetSpecialValueFor("flightAOERadius"),
		iVisionTeamNumber = caster:GetTeamNumber()		
	}
	
	ProjectileManager:CreateLinearProjectile(info)
end

function item_flare_gun:GetAOERadius()
	return self:GetSpecialValueFor("AOERadius")
end

function item_flare_gun:OnProjectileThink(vLocation)
	--EmitSoundOnLocationWithCaster(vLocation, "Hero_Rattletrap.Rocket_Flare.Travel", caster)
end

function item_flare_gun:OnProjectileHit(hTarget, vLocation)
	local kv = { }
	--Hero_Rattletrap.Rocket_Flare.Fire.FP 
	EmitSoundOn( "Hero_Rattletrap.Rocket_Flare.Explode ", caster )
	CreateModifierThinker(self:GetCaster(), self, "modifier_item_flare_gun_thinker", kv, vLocation, self:GetCaster():GetTeamNumber(), false)
	
	if self.p ~= nil then
		ParticleManager:DestroyParticle(self.p, false)
	end
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_flare_gun = class({})

function modifier_item_flare_gun:IsDebuff() return false end
function modifier_item_flare_gun:IsHidden() return true end
function modifier_item_flare_gun:IsPurgable() return false end
function modifier_item_flare_gun:IsPurgeException() return false end
function modifier_item_flare_gun:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_flare_gun:OnCreated( kv )
  	if IsServer() then
    	self:StartIntervalThink(0.25)
  	end
  	
end

function modifier_item_flare_gun:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_flare_gun:OnDestroy()
    if not IsServer() then return end
	local aura = self:GetParent():FindModifierByName("modifier_item_flare_gun_aura")
    if aura then
        aura:Destroy()
    end
    local slow = self:GetParent():FindModifierByName("modifier_item_flare_gun_aura_slow")
    if slow then
        slow:Destroy()
    end
    local thinker = self:GetParent():FindModifierByName("modifier_item_flare_gun_thinker")
    if thinker then
        thinker:Destroy()
    end
end

function modifier_item_flare_gun:DeclareFunctions()
    return 
    {
    	MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_item_flare_gun:GetBonusNightVision()
    return self:GetAbility():GetSpecialValueFor("BonusVision")
end

function modifier_item_flare_gun:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("BonusStrength")
end
--------------------------------------------------------------------------------
--Thinker
--------------------------------------------------------------------------------
modifier_item_flare_gun_thinker = ({})

function modifier_item_flare_gun_thinker:IsAura() return true end

function modifier_item_flare_gun_thinker:OnCreated( kv )
	local parent = self:GetParent()
	--AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_item_flare_gun_aura", {duration = self:GetAbility():GetSpecialValueFor("SlowDuration") })
	if IsServer() then
		AddFOWViewer(self:GetAbility():GetCaster():GetTeamNumber(), parent:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("AOERadius"), self:GetAbility():GetSpecialValueFor("VisionLingerDuration"), false)
		self.lifeTime = self:GetAbility():GetSpecialValueFor("VisionLingerDuration")
    	self:StartIntervalThink(0.25)
		parent:EmitSound( "Hero_Rattletrap.Rocket_Flare.Explode")
  	end
end


function modifier_item_flare_gun_thinker:OnIntervalThink()
  local parent = self:GetParent()
  self.lifeTime = self.lifeTime - 0.25
  if self.lifeTime <= 0 then
  	self:Destroy()  
  end
end

function modifier_item_flare_gun_thinker:OnDestroy( kv )
	if IsServer() then
		self:GetParent():Destroy()
	end
end

function modifier_item_flare_gun_thinker:DeclareFunctions()
	local funcs = {
		
	}

	return funcs
end

function modifier_item_flare_gun_thinker:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("AOERadius")
end

function modifier_item_flare_gun_thinker:GetModifierAura()
    return "modifier_item_flare_gun_aura_slow"
end
   
function modifier_item_flare_gun_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_flare_gun_thinker:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_flare_gun_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_item_flare_gun_thinker:GetAuraDuration()
    return 0.1
end


--------------------------------------------------------------------------------
--Aura
--------------------------------------------------------------------------------
modifier_item_flare_gun_aura = class({})

function modifier_item_flare_gun_aura:IsAura() return true end
function modifier_item_flare_gun_aura:IsHidden() return false end
function modifier_item_flare_gun_aura:IsPurgable() return false end

function modifier_item_flare_gun_aura:OnCreated()
	
end

function modifier_item_flare_gun_aura:OnDestroy()
	
end

function modifier_item_flare_gun_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("AOERadius")
end

function modifier_item_flare_gun_aura:GetModifierAura()
    return "modifier_item_flare_gun_aura_slow"
end
   
function modifier_item_flare_gun_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_flare_gun_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_flare_gun_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_item_flare_gun_aura:GetAuraDuration()
    return 0.1
end

--------------------------------------------------------------------------------
--Slow modifier
--------------------------------------------------------------------------------
modifier_item_flare_gun_aura_slow = class({})

function modifier_item_flare_gun_aura_slow:IsAura() return false end
function modifier_item_flare_gun_aura_slow:IsHidden() return false end
function modifier_item_flare_gun_aura_slow:IsPurgable() return false end

function modifier_item_flare_gun_aura_slow:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_item_flare_gun_aura_slow:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_item_flare_gun_aura_slow:OnIntervalThink()
	local parent = self:GetParent()
	if parent ~= nil and IsServer() then
		parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_truesight", { duration = 0.2 })
	end
end

--slowdown effect
function modifier_item_flare_gun_aura_slow:GetModifierMoveSpeedBonus_Percentage()
	return -1 * self:GetAbility():GetSpecialValueFor("MovementSlow")
end

function modifier_item_flare_gun_aura_slow:GetTexture()
	return "Dust_of_Appearance_icon"
end
