LinkLuaModifier( "modifier_killer_sense", 	"abilities/ability_killer_sense", LUA_MODIFIER_MOTION_NONE )

ability_killer_sense = class({})

function ability_killer_sense:GetIntrinsicModifierName()
    return "modifier_killer_sense"
end

--DOTA_ABILITY_BEHAVIOR_AUTOCAST 
function ability_killer_sense:OnSpellStart()
	local caster = self:GetCaster()
	
	caster:EmitSound( "Hero_Kez.Sai.Crit.Parry")
	self:StartCooldown(60)
	caster:AddNewModifier(caster, self, "modifier_invisible", { duration = self:GetSpecialValueFor("duration") })
end


--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_killer_sense = class({})

function modifier_killer_sense:IsDebuff() return false end
function modifier_killer_sense:IsHidden() return true end
function modifier_killer_sense:IsPurgable() return false end
function modifier_killer_sense:IsPurgeException() return false end
function modifier_killer_sense:RemoveOnDeath() return false end
function modifier_killer_sense:IsPermanent() return true end
function modifier_killer_sense:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_killer_sense:OnCreated()
	self:StartIntervalThink(0.05)
end

function modifier_killer_sense:OnIntervalThink()
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local team = parent:GetTeamNumber()
    
    if not IsServer() then return end
    
    local enemies = FindUnitsInRadius(team, parent:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("AbilityAoE"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, true)
    
    if ability:GetAutoCastState() == true and #enemies > 0 and ability:IsCooldownReady() then
    	ability:OnSpellStart()
    end
end





