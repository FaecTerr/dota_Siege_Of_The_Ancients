item_shinobi_mask = class({})

LinkLuaModifier( "modifier_item_shinobi_mask", "items/item_shinobi_mask", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_shinobi_mask_buff", "items/item_shinobi_mask", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_shinobi_mask_gem", "items/item_shinobi_mask", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_shinobi_mask:GetIntrinsicModifierName()
    return "modifier_item_shinobi_mask"
end

function item_shinobi_mask:GetChannelAnimation()
    return ACT_DOTA_TELEPORT
end

function item_shinobi_mask:OnSpellStart(keys)
	self:SetChanneling(true)    
    local caster = self:GetCaster()
    
    EmitAnnouncerSoundForTeamOnLocation("Outpost.Channel", caster:GetTeamNumber(), caster:GetAbsOrigin())
    
    self.p = ParticleManager:CreateParticleForTeam("particles/econ/events/compendium_2023/compendium_2023_teleport_core.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber())
	ParticleManager:SetParticleControl(self.p, 0, self:GetCursorPosition()) 
end

--Creates illusion at the place of hero
function item_shinobi_mask:OnChannelFinish( bInterrupted )
    local caster = self:GetCaster()
 	local duration = 20
 	
    self:SetChanneling(false)
    if self.p ~= nil then
		ParticleManager:DestroyParticle(self.p, false)
	end
	
    if not bInterrupted then
 		local player = caster:GetPlayerID()
 		local ability = self
 		local unit_name = caster:GetUnitName()
 		local origin = caster:GetAbsOrigin()
 		local outgoingDamage = 25
 		local incomingDamage = 300
 		
 		local target = self:GetCursorPosition()
 		
 		if not IsServer() then return end
 		space = FindClearSpaceForUnit( caster, target, true )
		if not space then
			caster:SetAbsOrigin(target)
		end
 		--Teleport player to designated location
 		caster:SetAbsOrigin(target)
 		caster:AddNewModifier(caster, ability, "modifier_invisible", { duration = duration })
 		
 		local illusion_table = {
      		outgoing_damage = 25,
      		incoming_damage = 300,
      		bounty_base = 10,
      		bounty_growth = 2,
      		outgoing_damage_structure = 25,
      		outgoing_damage_roshan = 25,
    	}
 		local illusions = CreateIllusions(caster, caster, illusion_table, 1, caster:GetHullRadius(), true, true)
 		--illusion:FaceTowards(target)
 		for _,illusion in pairs(illusions) do
 			FindClearSpaceForUnit(illusion, origin, true )
 			illusion:FaceTowards(target)
 			--illusion:AddNewModifier(caster, self, "modifier_item_shinobi_mask_buff", { duration = duration })
 			
 			illusion:SetEntityName("shinobi_illusion")
 			
 			local mod = illusion:FindModifierByName("modifier_illusion")
 			if mod ~= nil then
 				mod:SetDuration(duration, true)
 			end
 			
    		local cmod = caster:AddNewModifier(caster, self, "modifier_item_shinobi_mask_buff", { duration = duration })
    		cmod:IllusionToDestroy(illusion)
 			--print(illusion:GetPlayerOwner():GetPlayerID())	
 		end
    end
    StopSoundEvent("Outpost.Channel", self:GetCaster())
end

--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_item_shinobi_mask = class({})

function modifier_item_shinobi_mask:IsDebuff() return false end
function modifier_item_shinobi_mask:IsHidden() return true end
function modifier_item_shinobi_mask:IsPurgable() return false end
function modifier_item_shinobi_mask:IsPurgeException() return false end
function modifier_item_shinobi_mask:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_shinobi_mask:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.25)
  end
end

function modifier_item_shinobi_mask:OnIntervalThink()
  local parent = self:GetParent()
  
end

function modifier_item_shinobi_mask:OnDestroy()
    if not IsServer() then return end
    local mod = self:GetParent():FindModifierByName("modifier_item_shinobi_mask_buff")
    if mod then
        mod:Destroy()
    end
end

function modifier_item_shinobi_mask:DeclareFunctions()
    return 
    {
        --MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_item_shinobi_mask:GetModifierCastRangeBonus()
    return self:GetAbility():GetSpecialValueFor("cast_range_passive")
end

function modifier_item_shinobi_mask:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_item_shinobi_mask:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor("mana_bonus")
end

function modifier_item_shinobi_mask:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor("attributes_bonus")
end

function modifier_item_shinobi_mask:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor("attributes_bonus")
end

function modifier_item_shinobi_mask:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("attributes_bonus")
end
--------------------------------------------------------------------------------
--Active effect
--------------------------------------------------------------------------------

modifier_item_shinobi_mask_buff = class({})

function modifier_item_shinobi_mask:IsDebuff() return false end
function modifier_item_shinobi_mask_buff:IsHidden() return true end
function modifier_item_shinobi_mask_buff:IsPurgable() return false end
function modifier_item_shinobi_mask_buff:IsPurgeException() return false end
function modifier_item_shinobi_mask_buff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_shinobi_mask_buff:OnCreated( kv )
  	if IsServer() then
    	self:StartIntervalThink(0.01)
  	end
end

function modifier_item_shinobi_mask_buff:OnIntervalThink()
  	local parent = self:GetParent()
  	if parent:FindModifierByName("modifier_invisible") == nil then
  		self:OnBreakInvisibility()
  	end
end

function modifier_item_shinobi_mask_buff:CheckState()
	local state = {}
	
	state[MODIFIER_STATE_INVISIBLE]			 = true
	
	return state
end

function modifier_item_shinobi_mask_buff:IllusionToDestroy(param)
    self.illusion = param
end

function modifier_item_shinobi_mask_buff:DeclareFunctions()
    return 
    {
    	MODIFIER_EVENT_ON_BREAK_INVISIBILITY,
    	MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    	--MODIFIER_PROPERTY_BONUS_DAY_VISION,
    	--MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end

function modifier_item_shinobi_mask_buff:GetModifierInvisibilityLevel()
	return 0
end

function modifier_item_shinobi_mask_buff:OnBreakInvisibility( )
	local parent = self:GetParent()
	
	if parent ~= nil and parent:IsHero() then
		--local illusions = Entities:FindAllByName("shinobi_illusion")
		--print (self.illusion:GetName())
		if self.illusion ~= nil then
			self.illusion:Destroy()
			self.illusion = nil
		end
	end
	
	self:Destroy()	
	return 
end

function modifier_item_shinobi_mask_buff:GetTexture()
	return "items/shinobi_mask"
end

