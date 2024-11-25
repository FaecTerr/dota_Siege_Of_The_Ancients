ability_capture_lua = class({})

function ability_capture_lua:GetChannelTime()
    return 5
end

function ability_capture_lua:OnHeroLevelUp()
end

function ability_capture_lua:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

function ability_capture_lua:GetChannelAnimation()
    return ACT_DOTA_TELEPORT
end

function ability_capture_lua:CastFilterResultLocation(pos)
    self.pos = pos
end

function ability_capture_lua:OnSpellStart(keys)
    StartSoundEvent("Outpost.Channel", self:GetCaster())
end


--TODO
--CANCEL CHANNELING UPON RECIEVING NON-DoT DAMAGE

function ability_capture_lua:OnChannelFinish( bInterrupted )
    if not bInterrupted then
        local items_on_the_ground = Entities:FindAllByClassnameWithin("dota_item_drop", self.pos, 200)
        for _,item_ground in pairs(items_on_the_ground) do
            if item_ground then
                local item = item_ground:GetContainedItem()
                local item_name = item:GetAbilityName()
                if item_name == "item_tombstone" then
                	
                	--Channel finished by Ally
                	if  item:GetPurchaser():GetTeam() == self:GetCaster():GetTeam() then
                    	local hero = item:GetPurchaser()
                    	local point = self.pos
                    
                    	local hRelay = Entities:FindByName( nil, "logic_teleport" )
                    	if hRelay ~= nil then   hRelay:Trigger(nil,nil)	end
                    
                    	hero:RespawnHero(false, false)
                    	hero:SetAbsOrigin( point )
                    	FindClearSpaceForUnit(hero, point, false) 
                    	hero:Stop()
                    	hero:RemoveModifierByName("modifier_fountain_invulnerability")
                    	UTIL_Remove(item_ground)
                		
                	--Channel finished by enemy
                	else
                		                    	
                    	UTIL_Remove(item_ground)
                	end
                end
            end
        end
    end
    StopSoundEvent("Outpost.Channel", self:GetCaster())
end