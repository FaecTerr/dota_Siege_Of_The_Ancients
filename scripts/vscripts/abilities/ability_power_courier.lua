ability_power_courier = class({})

LinkLuaModifier( "modifier_power_courier", "abilities/ability_power_courier", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_power_courier_buff", "abilities/ability_power_courier", LUA_MODIFIER_MOTION_NONE )

function ability_power_courier:GetIntrinsicModifierName()
    return "modifier_power_courier"
end


function ability_power_courier:Spawn()
	local parent = self:GetCaster()
	self.courier = nil
	--self:SetThink("OnIntervalThink", {}, params, 0.5)
	
	if IsServer() then
		local couriers = Entities:FindAllByClassname("npc_dota_courier")
	
		for _,courier in pairs(couriers) do
			if courier:GetPlayerOwnerID() == parent:GetPlayerOwnerID() then
				self.courier = courier
			end
		end
		
		local mod = parent:FindModifierByName("modifier_power_courier")
		if mod ~= nil then
			mod:AssignCourier(self.courier)
			local cmod = self.courier:AddNewModifier(parent, self, "modifier_power_courier_buff", { duration = -1 })
			cmod:SetHeroOwner(parent)
		end
		
		Timers:CreateTimer(1.0, function() 
			if self.courier == nil then
				local caster = self:GetCaster()
				self.courier = nil
				self:StartIntervalThink(0.05)
			
				if IsServer() then
					local couriers = Entities:FindAllByClassname("npc_dota_courier")
			
					for _,courier in pairs(couriers) do
						if courier:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
							self.courier = courier
						end
					end
				
					local mod = parent:FindModifierByName("modifier_power_courier")
					if mod ~= nil then
						mod:AssignCourier(self.courier)
						local cmod = self.courier:AddNewModifier(caster, self, "modifier_power_courier_buff", { duration = -1 })
						cmod:SetHeroOwner(parent)
					end
				end
			end
			return 1
		end)
	end
	
	
end


--------------------------------------------------------------------------------
--Passive effect
--------------------------------------------------------------------------------

modifier_power_courier = class({})

function modifier_power_courier:IsDebuff() return false end
function modifier_power_courier:IsHidden() return true end
function modifier_power_courier:IsPurgable() return false end
function modifier_power_courier:IsPurgeException() return false end
function modifier_power_courier:RemoveOnDeath() return false end
function modifier_power_courier:IsPermanent() return true end
function modifier_power_courier:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_power_courier:OnCreated( kv )
  	if IsServer() then
  		self.courier = nil  	
    	self:StartIntervalThink(0.05)
  	end
end

function modifier_power_courier:OnIntervalThink()
  	local parent = self:GetParent()
  	if IsServer() then
  		if self.courier ~= nil then
  			if parent:HasModifier("modifier_attacker_respawn") == true and self.courier:HasModifier("modifier_attacker_respawn") == false then
  				local mod = parent:FindModifierByName("modifier_attacker_respawn")
  				local duration = mod:GetRemainingTime()
  				local cmod = courier:AddNewModifier(parent, self:GetAbility(), "modifier_attacker_respawn", {duration = duration})
  			end
  		end
  		
  	end
end

function modifier_power_courier:AssignCourier( courier )
	if courier ~= nil then
		self.courier = courier
	end
end


--------------------------------------------------------------------------------
--Passive courier effect
--------------------------------------------------------------------------------

modifier_power_courier_buff = class({})

function modifier_power_courier_buff:IsDebuff() return false end
function modifier_power_courier_buff:IsHidden() return true end
function modifier_power_courier_buff:IsPurgable() return false end
function modifier_power_courier_buff:IsPurgeException() return false end
function modifier_power_courier_buff:RemoveOnDeath() return false end
function modifier_power_courier_buff:IsPermanent() return true end
function modifier_power_courier_buff:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_power_courier_buff:DeclareFunctions()
	local funcs = {	
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_power_courier_buff:SetHeroOwner(hero)
	self.hero = hero
end

function modifier_power_courier_buff:GetModifierMoveSpeedBonus_Constant()
	if self.hero ~= nil then
		local bonus = self.hero:GetIdealSpeed() - self:GetParent():GetIdealSpeed()
		if bonus > 0 then
			return bonus
		end		
	end	
	return 0
end


