ability_magic_hat = class({})

LinkLuaModifier( "modifier_ability_magic_hat", 			"abilities/ability_magic_hat", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_magic_hat_buff1", 	"abilities/ability_magic_hat", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_magic_hat_buff2", 	"abilities/ability_magic_hat", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_magic_hat_buff3", 	"abilities/ability_magic_hat", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_magic_hat_buff4", 	"abilities/ability_magic_hat", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_magic_hat_multicast", 	"abilities/ability_magic_hat", LUA_MODIFIER_MOTION_NONE )

function ability_magic_hat:GetIntrinsicModifierName()
    return "modifier_ability_magic_hat"
end


function ability_magic_hat:OnSpellStart()
	local caster = self:GetCaster()   	
    
    local buffID = RandomInt(1, 4)  
    caster:AddNewModifier(caster, self, "modifier_ability_magic_hat_buff" .. tostring(buffID), { duration = self:GetSpecialValueFor("duration") })     
end


--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_ability_magic_hat = class({})

function modifier_ability_magic_hat:IsDebuff() return false end
function modifier_ability_magic_hat:IsHidden() return true end
function modifier_ability_magic_hat:IsPurgable() return false end
function modifier_ability_magic_hat:IsPurgeException() return false end
function modifier_ability_magic_hat:RemoveOnDeath() return false end
function modifier_ability_magic_hat:IsPermanent() return true end
function modifier_ability_magic_hat:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end


--------------------------------------------------------------------------------
--Active effect
--------------------------------------------------------------------------------

modifier_ability_magic_hat_buff1 = class({})

function modifier_ability_magic_hat_buff1:IsDebuff() return false end
function modifier_ability_magic_hat_buff1:IsHidden() return false end
function modifier_ability_magic_hat_buff1:IsPurgable() return false end
function modifier_ability_magic_hat_buff1:IsPurgeException() return false end
function modifier_ability_magic_hat_buff1:RemoveOnDeath() return false end

function modifier_ability_magic_hat_buff1:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

--MODIFIER_EVENT_SPELL_APPLIED_SUCCESSFULLY 


function modifier_ability_magic_hat_buff1:DeclareFunctions()
    return 
    {
    	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
    }
end

function modifier_ability_magic_hat_buff1:OnAbilityFullyCast(params )
    if params.unit~=self:GetCaster() then return end
	if params.ability==self:GetAbility() then return end

	-- only spells that have target
	if not params.target then return end

	-- if the spell can do both target and point, it should not trigger
	if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then return end
	if bit.band( params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET ) ~= 0 then return end

	-- roll multicasts
	local casts = 2

	-- check delay
	local delay = 0.6

	-- only for fireblast multicast to single target
	local single = false

	-- multicast
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_ability_magic_hat_multicast", -- modifier name
		{
			ability = params.ability:entindex(),
			target = params.target:entindex(),
			multicast = casts,
			delay = delay,
			single = single,
		} -- kv
	)
	self:Destroy()
end

--------------------------------------------------------------------------------------------

modifier_ability_magic_hat_multicast = class({})

function modifier_ability_magic_hat_multicast:IsDebuff() return false end
function modifier_ability_magic_hat_multicast:IsHidden() return true end
function modifier_ability_magic_hat_multicast:IsPurgable() return false end
function modifier_ability_magic_hat_multicast:IsPurgeException() return false end
function modifier_ability_magic_hat_multicast:RemoveOnDeath() return false end

function modifier_ability_magic_hat_multicast:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ability_magic_hat_multicast:OnCreated( kv )
	if not IsServer() then return end
	-- load data
	self.caster = self:GetParent()
	self.ability = EntIndexToHScript( kv.ability )
	self.target = EntIndexToHScript( kv.target )
	self.multicast = kv.multicast
	self.delay = kv.delay
	self.single = kv.single==1
	self.buffer_range = 300

	-- set stack count
	self:SetStackCount( self.multicast )

	-- init multicast
	self.casts = 0
	if self.multicast==1 then
		-- no multicast if just 1
		self:Destroy()
		return
	end

	-- keep a table of targeted units
	self.targets = {}
	self.targets[self.target] = true

	-- get cast range
	self.radius = self.ability:GetCastRange( self.target:GetOrigin(), self.target ) + self.buffer_range

	-- get unit filters
	-- only target the same team as original target, even if the ability can cast on both team
	self.target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	if self.target:GetTeamNumber()~=self.caster:GetTeamNumber() then
		self.target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	-- if custom, findunitsinradius won't work
	self.target_type = self.ability:GetAbilityTargetType()
	if self.target_type==DOTA_UNIT_TARGET_CUSTOM then
		self.target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end

	-- only check for magic immunity piercing abilities
	self.target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
	if bit.band( self.ability:GetAbilityTargetFlags(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ) ~= 0 then
		self.target_flags = self.target_flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	
	--self:PlayEffects( self.casts )
	
	self:StartIntervalThink( self.delay )
end

function modifier_ability_magic_hat_multicast:OnIntervalThink()
	local current_target = nil

	if self.single then
		current_target = self.target
	else
		-- find valid targets
		local units = FindUnitsInRadius(
			self.caster:GetTeamNumber(),	-- int, your team number
			self.caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			self.target_team,	-- int, team filter
			self.target_type,	-- int, type filter
			self.target_flags,	-- int, flag filter
			FIND_CLOSEST,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- select valid target
		for _,unit in pairs(units) do
			-- not already a multicast target
			if not self.targets[unit] then

				-- check filter
				local filter = false
				if self.ability.CastFilterResultTarget then -- for customs
					filter = self.ability:CastFilterResultTarget( unit ) == UF_SUCCESS
				else
					filter = true
				end

				if filter then
					-- register unit
					self.targets[unit] = true
					current_target = unit

					break
				end
			end
		end

		-- if no one there, break multicast
		if not current_target then
			self:StartIntervalThink( -1 )
			self:Destroy()
			return
		end
	end

	-- cast to target
	self.caster:SetCursorCastTarget( current_target )
	self.ability:OnSpellStart()

	-- increment count
	self.casts = self.casts + 1
	if self.casts>=(self.multicast-1) then
		self:StartIntervalThink( -1 )
		self:Destroy()
	end

	-- play effects
	--self:PlayEffects( self.casts )
end


function modifier_ability_magic_hat_multicast:OnRefresh( kv ) end
function modifier_ability_magic_hat_multicast:OnRemoved() end

function modifier_ability_magic_hat_multicast:OnDestroy() end

----------------------------------------------------------------------------------


modifier_ability_magic_hat_buff2 = class({})

function modifier_ability_magic_hat_buff2:IsDebuff() return false end
function modifier_ability_magic_hat_buff2:IsHidden() return false end
function modifier_ability_magic_hat_buff2:IsPurgable() return false end
function modifier_ability_magic_hat_buff2:IsPurgeException() return false end
function modifier_ability_magic_hat_buff2:RemoveOnDeath() return false end

function modifier_ability_magic_hat_buff2:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ability_magic_hat_buff2:DeclareFunctions()
    return 
    {
    	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    	MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
    	
    }
end

function modifier_ability_magic_hat_buff2:GetModifierPercentageManacostStacking()
	return 100
end

function modifier_ability_magic_hat_buff2:OnAbilityExecuted(event)
	local caster = self:GetParent()
    if event.ability ~= nil then
    	if IsServer() and self:GetDuration() > 3.0 then
    		self:SetDuration(3.0, true)
    	end
    end
end


modifier_ability_magic_hat_buff3 = class({})

function modifier_ability_magic_hat_buff3:IsDebuff() return false end
function modifier_ability_magic_hat_buff3:IsHidden() return false end
function modifier_ability_magic_hat_buff3:IsPurgable() return false end
function modifier_ability_magic_hat_buff3:IsPurgeException() return false end
function modifier_ability_magic_hat_buff3:RemoveOnDeath() return false end

function modifier_ability_magic_hat_buff3:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ability_magic_hat_buff3:DeclareFunctions()
    return 
    {
    	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    	MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER,
    	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }
end

function modifier_ability_magic_hat_buff3:GetModifierStatusResistanceCaster()
	return -35
end

function modifier_ability_magic_hat_buff3:GetModifierSpellAmplify_Percentage()
	return 35
end


function modifier_ability_magic_hat_buff3:OnAbilityExecuted(event)
	local caster = self:GetParent()
    if event.ability ~= nil and event.ability:GetAbilityType() == ABILITY_TYPE_BASIC then
    	if IsServer() and self:GetDuration() > 3.0 then
    		self:SetDuration(3.0, true)
    	end
    end
end

modifier_ability_magic_hat_buff4 = class({})

function modifier_ability_magic_hat_buff4:IsDebuff() return false end
function modifier_ability_magic_hat_buff4:IsHidden() return false end
function modifier_ability_magic_hat_buff4:IsPurgable() return false end
function modifier_ability_magic_hat_buff4:IsPurgeException() return false end
function modifier_ability_magic_hat_buff4:RemoveOnDeath() return false end

function modifier_ability_magic_hat_buff4:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ability_magic_hat_buff4:DeclareFunctions()
    return 
    {
    	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    	
    }
end

function modifier_ability_magic_hat_buff4:OnAbilityExecuted(event)
	local caster = self:GetParent()
    if event.ability ~= nil and event.ability:GetAbilityType() == ABILITY_TYPE_BASIC then
	    caster:SetMana(caster:GetMaxMana())
    	self:Destroy()
    end
end





