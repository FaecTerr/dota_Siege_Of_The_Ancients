ability_pocket_shop = class({})

LinkLuaModifier( "modifier_pocket_shop", "abilities/ability_pocket_shop", LUA_MODIFIER_MOTION_NONE )

function ability_pocket_shop:GetIntrinsicModifierName()
    return "modifier_pocket_shop"
end

function ability_pocket_shop:OnSpellStart(keys)
	local parent = self:GetCaster()
	
	local location = parent:GetAbsOrigin()
	local radius = 350

    local shop_trigger = SpawnDOTAShopTriggerRadiusApproximate(location, radius)
    shop_trigger:SetShopType(DOTA_SHOP_HOME)
    
    self.p =  ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_scepter_rain_of_destiny.vpcf", PATTACH_POINT, parent)
    
    ParticleManager:SetParticleControl(self.p, 0, location) 
    ParticleManager:SetParticleControl(self.p, 1, Vector(radius, 0, 0)) 
    
    
	AddFOWViewer(parent:GetTeam(), parent:GetAbsOrigin(), radius, 15.0, false)
    
    Timers:CreateTimer(15.0, function() 
    	shop_trigger:Destroy()
    	if self.p ~= nil then
    		ParticleManager:DestroyParticle(self.p, false)
    		self.p = nil
    	end
    end)
    --StartSoundEvent("Outpost.Channel", self:GetCaster())
end


modifier_pocket_shop = class({})

function modifier_pocket_shop:IsDebuff() return false end
function modifier_pocket_shop:IsPurgable() return false end
function modifier_pocket_shop:RemoveOnDeath() return false end
function modifier_pocket_shop:IsPermanent() return true end
function modifier_pocket_shop:IsHidden() return true end

function modifier_pocket_shop:DeclareFunctions()
	local funcs = {
  		MODIFIER_PROPERTY_BONUS_NIGHT_VISION ,
	}
	return funcs
end

function modifier_pocket_shop:GetBonusNightVision()
	return 450
end