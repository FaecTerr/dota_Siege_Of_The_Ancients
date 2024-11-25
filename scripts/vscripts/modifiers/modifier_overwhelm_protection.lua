modifier_regenerative_universal_damage_barrier_lua = class({})

function modifier_regenerative_universal_damage_barrier_lua:IsDebuff() return false end
function modifier_regenerative_universal_damage_barrier_lua:IsPurgable() return false end
function modifier_regenerative_universal_damage_barrier_lua:RemoveOnDeath()	return false end
function modifier_regenerative_universal_damage_barrier_lua:IsPermanent() return true end
function modifier_regenerative_universal_damage_barrier_lua:IsHidden() return false end

function modifier_regenerative_universal_damage_barrier_lua:OnCreated( kv )
  if IsServer() then
    self:StartIntervalThink(0.4)
    self.shield_health = 350.0
    self.shield_maxHealth = 350.0
    self.regenCountdown = 0

    if self.shield_health > 0 then
      self:SetStackCount(self.shield_health)
    else
      self:SetStackCount(0)
    end
  end
end



function modifier_regenerative_universal_damage_barrier_lua:OnIntervalThink()
  	local parent = self:GetParent()
  	if not IsServer() then return end
  	
  	local regen_per_tick = 4
  	
  	local mod = self:GetParent():FindModifierByName("modifier_barrier_regen_aura_buff")
    if mod then
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

function modifier_regenerative_universal_damage_barrier_lua:GetModifierIncomingDamageConstant ()
  if (not IsServer()) then
    return self:GetStackCount()
  end
end