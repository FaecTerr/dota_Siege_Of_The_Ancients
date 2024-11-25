LinkLuaModifier( "modifier_key_tuning", "abilities/ability_key_tuning", LUA_MODIFIER_MOTION_NONE )

ability_key_tuning = class({})

function ability_key_tuning:GetIntrinsicModifierName()
    return "modifier_key_tuning"
end

modifier_key_tuning = class({})

function modifier_key_tuning:IsDebuff() return false end
function modifier_key_tuning:IsPurgable() return false end
function modifier_key_tuning:RemoveOnDeath() return false end
function modifier_key_tuning:IsPermanent() return true end
function modifier_key_tuning:IsHidden() return false end

function modifier_key_tuning:OnCreated( kv )
	self:StartIntervalThink(0.05)
	self.distance = 0
    self:SetHasCustomTransmitterData(true)
end

function modifier_key_tuning:OnIntervalThink()
  	local parent = self:GetParent()
	if IsServer() then
		--Initial value is capped at max range
		local distance = self:GetAbility():GetSpecialValueFor("MaxRange")
		
		local maxDistance = self:GetAbility():GetSpecialValueFor("MaxRange")
		local minDistance = self:GetAbility():GetSpecialValueFor("MinRange")
		
		--For Each target in range
		local targets = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("MaxRange"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HEROES_AND_CREEPS, DOTA_UNIT_TARGET_FLAG_CAN_BE_SEEN, FIND_CLOSEST, true)	
		
		for _,enemy in pairs(targets) do
			local range = (enemy:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D()
			
			--Smallest distance to target
			if range < distance then
				distance = range
			end			
		end
		
		--Fix value being lower than min Value
		if distance < minDistance then
			distance = minDistance
		end
		
		--The closer the lower
		self.distance = (distance - minDistance) / (maxDistance - minDistance)
		
		--Update client
		self:SendBuffRefreshToClients()
	end
end


function modifier_key_tuning:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_key_tuning:GetModifierPhysicalArmorBonus()

	return (1 - self.distance) * self:GetParent():GetLevel() * self:GetAbility():GetSpecialValueFor("ArmorMod")
end

function modifier_key_tuning:GetModifierMagicalResistanceBonus()

	return (self.distance) * self:GetParent():GetLevel() * self:GetAbility():GetSpecialValueFor("ResistMod")
end

function modifier_key_tuning:AddCustomTransmitterData()
    return {
        distance = self.distance
    }
end

function modifier_key_tuning:HandleCustomTransmitterData( data )
    self.distance = data.distance
end



function modifier_key_tuning:GetTexture()
	return "modifier_key_tuning"
end















