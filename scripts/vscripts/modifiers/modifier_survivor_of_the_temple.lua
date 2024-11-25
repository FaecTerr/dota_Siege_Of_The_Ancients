modifier_survivor_of_the_temple = class({})

LinkLuaModifier( "modifier_survivor_of_the_temple", "modifiers/modifier_survivor_of_the_temple", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_survivor_of_the_temple_buff", "modifiers/modifier_survivor_of_the_temple", LUA_MODIFIER_MOTION_NONE )

function modifier_survivor_of_the_temple:IsDebuff() return false end
function modifier_survivor_of_the_temple:IsPurgable() return false end
function modifier_survivor_of_the_temple:RemoveOnDeath() return false end
function modifier_survivor_of_the_temple:IsPermanent() return true end
function modifier_survivor_of_the_temple:IsHidden() return false end

function modifier_survivor_of_the_temple:OnCreated( kv )
    	self.regenCountdown = 0
		self.disabled = false        	
		self:StartIntervalThink(0.2)
end

function modifier_survivor_of_the_temple:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		
		MODIFIER_EVENT_ON_TAKEDAMAGE,
  		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_survivor_of_the_temple:GetModifierConstantHealthRegen()
	if self.disabled == true or self:GetStackCount() > 0 then
		return 0.0
	else
		return 2.5	
	end
end

function modifier_survivor_of_the_temple:GetModifierConstantManaRegen()
	if self.disabled == true or self:GetStackCount() > 0 then
		return 0.0
	else	
		return 1.5
	end
end

function modifier_survivor_of_the_temple:GetModifierMoveSpeedBonus_Constant()
	if self.disabled == true or self:GetStackCount() > 0 then
		return 40
	else	
		return 60
	end
end

function modifier_survivor_of_the_temple:GetModifierPercentageExpRateBoost()
	return 100
end

function modifier_survivor_of_the_temple:OnTakeDamage(param)
	local parent = self:GetParent()
	if param.attacker ~= nil and param.damage > 0 and param.unit == parent and param.attacker ~= parent then
		self.disabled = true
		self.regenCountdown = 10		
  			self:SetStackCount(10)
		if param.attacker:IsHero() then			
			self.regenCountdown = 40			
  			self:SetStackCount(40)
		end
	end
end

function modifier_survivor_of_the_temple:OnDeath(params)
	--print("a")
	local caster = self:GetCaster()	
    
    local attacker = params.attacker
    local target = params.unit
    
    if not IsServer() then return end
    
    local size = PlayerResource:GetPlayerCountForTeam(caster:GetTeam())
    
    if mod == nil and attacker ~= nil and attacker == caster and target:GetTeam() ~= attacker:GetTeam() and not target:IsHero() then
		local buff = attacker:FindModifierByName("modifier_survivor_of_the_temple_buff")
		if IsServer() then
			local bounty = ((5 - size) * 0.25 + 0.5) * target:GetGoldBounty()
			
			if buff ~= nil then
				buff:SetStackCount(buff:GetStackCount() + bounty)
			else
				buff = attacker:AddNewModifier(attacker, self, "modifier_survivor_of_the_temple_buff", {duration = -1})
				buff:SetStackCount(buff:GetStackCount() + bounty)
			end
		end
  	end
end

function modifier_survivor_of_the_temple:OnIntervalThink()
  	local parent = self:GetParent()
  	
  	local count = self.regenCountdown
  	
  	if self.disabled == true then
  		if self.regenCountdown > 0 then
  			self.regenCountdown = self.regenCountdown - 0.2
  			self:SetStackCount(count)
  		else
  			self.disabled = false
  			self:SetStackCount(count)
  		end
  	end
end

function modifier_survivor_of_the_temple:GetTexture()
	return "modifier_survivor_of_the_temple"
end


--------------------------------------------------------------------------------

modifier_survivor_of_the_temple_buff = class({})

function modifier_survivor_of_the_temple_buff:RemoveOnDeath() return true end
function modifier_survivor_of_the_temple_buff:IsHidden() return false end
function modifier_survivor_of_the_temple_buff:IsPurgable() return false end
function modifier_survivor_of_the_temple_buff:IsPurgeException() return false end

function modifier_survivor_of_the_temple_buff:OnCreated( kv )   	
	self:StartIntervalThink(0.4)
end

function modifier_survivor_of_the_temple_buff:GetTexture()
	return "materials/vgui/hud/shop/icon_gold.vmat"
end

function modifier_survivor_of_the_temple_buff:OnIntervalThink( kv )   	
	local parent = self:GetParent()
	if self:GetStackCount() > 0 and IsServer() then
		local targets = FindUnitsInRadius(
        parent:GetTeamNumber(), 
        parent:GetAbsOrigin(),
        nil,    
        9999999,  
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
       	DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER, 
        true)
	
		local power = math.floor(self:GetStackCount() / 100) + 1
	
		for _,target in pairs(targets) do
			target:ModifyGold(power, true, DOTA_ModifyGold_CreepKill)
		end	
		self:SetStackCount(self:GetStackCount() - power)
	else
		--self:Destroy()
	end
	
end


function modifier_survivor_of_the_temple_buff:GetTexture()
	return "modifier_survivor_of_the_temple_buff"
end














