ability_tower_protection = class({})

LinkLuaModifier( "modifier_tower_protection", 		"abilities/ability_tower_protection", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_protection_buff", 	"abilities/ability_tower_protection", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_protection_aura", 	"abilities/ability_tower_protection", LUA_MODIFIER_MOTION_NONE )

function ability_tower_protection:GetIntrinsicModifierName()
    return "modifier_tower_protection"
end


function ability_tower_protection:OnSpellStart()
	local caster = self:GetCaster()   	
    local target = self:GetCursorTarget()
    
    if target ~= nil then
    	target:AddNewModifier(caster, self, "modifier_tower_protection_buff", { duration = self:GetSpecialValueFor("duration") })
    end  
end


--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_tower_protection = class({})

function modifier_tower_protection:IsDebuff() return false end
function modifier_tower_protection:IsHidden() return true end
function modifier_tower_protection:IsPurgable() return false end
function modifier_tower_protection:IsPurgeException() return false end
function modifier_tower_protection:RemoveOnDeath() return false end
function modifier_tower_protection:IsPermanent() return true end
function modifier_tower_protection:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end


--------------------------------------------------------------------------------
--Active effect
--------------------------------------------------------------------------------

modifier_tower_protection_buff = class({})

function modifier_tower_protection_buff:IsDebuff() return false end
function modifier_tower_protection_buff:IsHidden() return true end
function modifier_tower_protection_buff:IsPurgable() return false end
function modifier_tower_protection_buff:IsPurgeException() return false end
function modifier_tower_protection_buff:RemoveOnDeath() return false end
function modifier_tower_protection_buff:IsPermanent() return true end
function modifier_tower_protection_buff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_tower_protection_buff:IsAura() return true end

function modifier_tower_protection_buff:GetAuraRadius()
    return 1200
end

function modifier_tower_protection_buff:GetModifierAura()
    return "modifier_tower_protection_aura"
end
   
function modifier_tower_protection_buff:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_tower_protection_buff:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_tower_protection_buff:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_tower_protection_buff:GetAuraDuration()
    return 0.1
end


--------------------------------------------------------------------------------
--Aura effect
--------------------------------------------------------------------------------

modifier_tower_protection_aura = class({})

function modifier_tower_protection_aura:IsDebuff() return false end
function modifier_tower_protection_aura:IsHidden() return false end
function modifier_tower_protection_aura:IsPurgable() return false end
function modifier_tower_protection_aura:IsPurgeException() return false end
function modifier_tower_protection_aura:RemoveOnDeath() return false end
function modifier_tower_protection_aura:IsPermanent() return true end
function modifier_tower_protection_aura:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_tower_protection_aura:DeclareFunctions()
	local funcs = {	
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT 
	}
	return funcs
end

function modifier_tower_protection_aura:GetModifierPhysicalArmorBonus()
	local parent = self:GetAuraOwner()
	--print(parent:GetName())
	if parent:GetName() == "outpost" then
		return 10
	end

	return 5
end

function modifier_tower_protection_aura:GetModifierConstantHealthRegen()
	local parent = self:GetAuraOwner()
	
	if parent:GetName() == "outpost" then
		return 10
	end
	
	return 3
end

