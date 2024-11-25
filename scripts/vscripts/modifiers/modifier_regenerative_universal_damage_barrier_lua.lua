modifier_regenerative_universal_damage_barrier_lua = class({})

function modifier_regenerative_universal_damage_barrier_lua:IsDebuff() return false end
function modifier_regenerative_universal_damage_barrier_lua:IsPurgable() return false end
function modifier_regenerative_universal_damage_barrier_lua:RemoveOnDeath()	return false end
function modifier_regenerative_universal_damage_barrier_lua:IsPermanent() return true end
function modifier_regenerative_universal_damage_barrier_lua:IsHidden() return false end
function modifier_regenerative_universal_damage_barrier_lua:IsAura() return true end

function modifier_regenerative_universal_damage_barrier_lua:OnCreated( kv )
  	self.alertable = true
  
  	self.p = ParticleManager:CreateParticle("particles/ui_mouseactions/tower_range_indicator_default.vpcf", PATTACH_ABSORIGIN, self:GetParent())	
	--self.effect_indicator = ParticleManager:CreateParticle("particles/ui_mouseactions/range_finder_aoe.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	
	--Origin
	ParticleManager:SetParticleControl(self.p, 0, self:GetParent():GetAbsOrigin()) 
	ParticleManager:SetParticleControl(self.p, 2, self:GetParent():GetAbsOrigin()) 
	
	self.AttackRange = self:GetParent():Script_GetAttackRange()
	if IsServer() then
		--self.AttackRange = self:GetParent():Script_GetAttackRange() + self:GetParent():GetHullRadius() * 2
	end
	
	--Range
	ParticleManager:SetParticleControl(self.p, 3, Vector(self.AttackRange + self:GetParent():GetHullRadius(), 0, 0)) 
	--ParticleManager:SetParticleControl( self.effect_indicator, 3, Vector( self.AttackRange + self:GetParent():GetHullRadius() + 12, self.AttackRange + self:GetParent():GetHullRadius() + 12, self.AttackRange + self:GetParent():GetHullRadius() + 12) )
	
	--Color
	ParticleManager:SetParticleControl(self.p, 4, Vector(0, 1, 0)) 
	--Hero position
	ParticleManager:SetParticleControl(self.p, 5, self:GetParent():GetAbsOrigin()) 
	ParticleManager:SetParticleControl(self.p, 7, self:GetParent():GetAbsOrigin()) 
  	--Danger Intensity
	ParticleManager:SetParticleControl(self.p, 9, Vector(1, 0, 0)) 
  	--m_flControlledUnitInRangeAmount
	ParticleManager:SetParticleControl(self.p, 13, Vector(1, 1, 0)) 
	
	--Alpha
	ParticleManager:SetParticleControl(self.p, 6, Vector(1, 1, 1)) 
	
	
	ParticleManager:SetParticleAlwaysSimulate(self.p)
	ParticleManager:SetParticleShouldCheckFoW(self.p, false)
	
	--ParticleManager:SetParticleAlwaysSimulate(self.effect_indicator)
	--ParticleManager:SetParticleShouldCheckFoW(self.effect_indicator, false)
	
	  	
  	if IsServer() then
  		local parent = self:GetParent()  	
    	self:StartIntervalThink(0.4)
    
    	self.RadiantPlayers = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    	self.DirePlayers = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
    
    	self.playerCount = 1
    	if parent:GetTeam() == DOTA_TEAM_GOODGUYS then
    		self.playerCount = self.RadiantPlayers
    	else
    		self.playerCount = self.DirePlayers
    	end
    
    	self.shield_health = 150.0 + 50 * self.playerCount
    	self.shield_maxHealth = 150.0 + 50 * self.playerCount
    	self.regenCountdown = 0

    	if self.shield_health > 0 then
      		self:SetStackCount(self.shield_health)
    	else
      		self:SetStackCount(0)
    	end
    
    	local overwhelm = 0
		local team = parent:GetTeamNumber()
	
	
	
		if parent ~= nil and IsServer() then
			local targets = FindUnitsInRadius(team, parent:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_CAN_BE_SEEN, FIND_CLOSEST, true)	
			overwhelm = #targets
		
			if #targets > 0 and self.p ~= nil and targets ~= nil then
				--Hero position
				ParticleManager:SetParticleControl(self.p, 7, targets[0]:GetAbsOrigin()) 
			end
		end
    	
    	self.overwhelmArmor = overwhelm * (overwhelm - 1.2)
    
  	end
    self:SetHasCustomTransmitterData(true)
end

function modifier_regenerative_universal_damage_barrier_lua:OnDestroy()


	ParticleManager:DestroyParticle( self.p, false )
	ParticleManager:ReleaseParticleIndex( self.p )
	
	--ParticleManager:DestroyParticle( self.effect_indicator, false )
	--ParticleManager:ReleaseParticleIndex( self.effect_indicator )
end

function modifier_regenerative_universal_damage_barrier_lua:OnIntervalThink()
  	local parent = self:GetParent()
  	
	ParticleManager:SetParticleAlwaysSimulate(self.p)
	ParticleManager:SetParticleShouldCheckFoW(self.p, false)
	
  	if IsServer() then
		self.AttackRange = self:GetParent():GetBaseAttackRange() + self:GetParent():GetHullRadius() * 2
	end
  	
	--Range?
	ParticleManager:SetParticleControl(self.p, 1, Vector(self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange + self:GetParent():GetHullRadius())) 
	ParticleManager:SetParticleControl(self.p, 3, Vector(self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange + self:GetParent():GetHullRadius()))   
	ParticleManager:SetParticleControl(self.p, 6, Vector(self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange + self:GetParent():GetHullRadius()))   	
	--ParticleManager:SetParticleControl( self.effect_indicator, 3, Vector( self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange + self:GetParent():GetHullRadius(), self.AttackRange  + self:GetParent():GetHullRadius()))
  	
  	if not IsServer() then return end
  	
  	local regen_per_tick = 4
  	
  	local overwhelm = 0
	local team = parent:GetTeamNumber()
	
	local range_bonus = 0
	
	if parent ~= nil then
		if parent:GetAttackTarget() ~= nil then
			--Hero position
			ParticleManager:SetParticleControl(self.p, 5, parent:GetAttackTarget():GetAbsOrigin())
			ParticleManager:SetParticleControl(self.p, 7, parent:GetAttackTarget():GetAbsOrigin())
			ParticleManager:SetParticleControl(self.p, 13, Vector(1, 1, 0)) 
		else
			ParticleManager:SetParticleControl(self.p, 7, parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.p, 13, Vector(1, 0, 0)) 
		end
	end	
	
	--Count units surrounding
	if parent ~= nil and IsServer() then
		local targets = FindUnitsInRadius(team, parent:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_CAN_BE_SEEN, FIND_CLOSEST, true)	
		overwhelm = overwhelm + #targets * 0.9

		local target_creeps = FindUnitsInRadius(team, parent:GetAbsOrigin(), nil, 1400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_CAN_BE_SEEN, FIND_CLOSEST, true)	
		
		for _,enemy in pairs(target_creeps) do
			if enemy:GetClassname() == "npc_dota_broodmother_spiderling" or enemy:GetClassname() == "npc_dota_broodmother_spiderite" then
				overwhelm = overwhelm + 0.15
			elseif enemy:GetClassname() == "npc_dota_furion_treant" then
				overwhelm = overwhelm + 0.60
			elseif enemy:GetClassname() == "npc_dota_furion_treant_large" then
				overwhelm = overwhelm + 0.85
			else
				overwhelm = overwhelm + 0.75
			end
		end
		
		overwhelm = overwhelm + #target_creeps * 0.35
	end
    
    if overwhelm > 0 then			 		
  		--m_flControlledUnitInRangeAmount
		ParticleManager:SetParticleControl(self.p, 13, Vector(1, 1, 0)) 
	else 
  		--m_flControlledUnitInRangeAmount
		ParticleManager:SetParticleControl(self.p, 13, Vector(0, 0, 0)) 
	end
    
    --Ping if enemy is close
    if overwhelm > 0 and self.alertable then
    	GameRules:ExecuteTeamPing(parent:GetTeamNumber(), parent:GetAbsOrigin().x, parent:GetAbsOrigin().y, nil, 0)
    	self.alertable = false
    	
    	Timers:CreateTimer(30, function() 
    		self.alertable = true
    	end)
    end
    
    self.overwhelmArmor = overwhelm * (overwhelm - 1.2)
    
    if self.overwhelmArmor < 0 then
    	self.overwhelmArmor = 0
    end
    
  	self:SendBuffRefreshToClients()
  	
  	local mod = self:GetParent():FindModifierByName("modifier_barrier_regen_aura_buff")
    if mod then
		 regen_per_tick = regen_per_tick + 2
    end    
    if parent:GetName() == "throne" then
		regen_per_tick = regen_per_tick + 2
    end
  	--self:GetModifierIncomingDamageConstant()
  
  	if self.regenCountdown > 0 then
    	self.regenCountdown = self.regenCountdown - 0.1
  	end
  
  	if self.regenCountdown <= 0 then
  		--Regenerate shield if it's capacity lower than max

    	if self.shield_health < self.shield_maxHealth then
      		self.shield_health = self.shield_health + regen_per_tick
    	end    
  		--Cap shield health at max
    	if self.shield_health > self.shield_maxHealth then
      		self.shield_health = self.shield_maxHealth
    	end
  	end
  
  self:SetStackCount(self.shield_health)
  
  --parent:Heal(10.0, self:GetCaster())
end

function modifier_regenerative_universal_damage_barrier_lua:DeclareFunctions()
  local funcs = 
  {
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,  
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  }

  return funcs
end

function modifier_regenerative_universal_damage_barrier_lua:GetModifierTotal_ConstantBlock(kv)
    if IsServer() then
        local target                    = self:GetParent()
        local original_shield_amount    = self.shield_health
        self.regenCountdown = 0
        if kv.damage > 0 and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
            if kv.damage < self.shield_health then
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, kv.damage, nil)
                self.shield_health = self.shield_health - kv.damage
                self:SetStackCount(self.shield_health)
                return kv.damage
            else
                local overheadDamage = self.shield_health
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, overheadDamage, nil)
                if not self:IsNull() then
                  --self:Destroy()
                end
                self.shield_health = 0
                self:SetStackCount(self.shield_health)                
                return overheadDamage
            end
        end
    end
end

function modifier_regenerative_universal_damage_barrier_lua:GetModifierIncomingDamageConstant()
  if (not IsServer()) then
    return self:GetStackCount()
  end
end

function modifier_regenerative_universal_damage_barrier_lua:AddCustomTransmitterData()
    return {
        overwhelmArmor = self.overwhelmArmor,
        AttackRange = self.AttackRange
    }
end
function modifier_regenerative_universal_damage_barrier_lua:HandleCustomTransmitterData( data )
    self.overwhelmArmor = data.overwhelmArmor
   	self.AttackRange = data.AttackRange 
end

function modifier_regenerative_universal_damage_barrier_lua:GetModifierPhysicalArmorBonus()		
	--0 (0%) / 2 (12%) / 6 (36%) / 12 (72%) / 20 (120%) ehp
	return self.overwhelmArmor
end

function modifier_regenerative_universal_damage_barrier_lua:GetAuraRadius()
    return 1250
end

function modifier_regenerative_universal_damage_barrier_lua:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_regenerative_universal_damage_barrier_lua:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_regenerative_universal_damage_barrier_lua:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_regenerative_universal_damage_barrier_lua:GetAuraSearchType()
    return DOTA_UNIT_TARGET_ALL
end

function modifier_regenerative_universal_damage_barrier_lua:GetAuraDuration()
    return 0.5
end








