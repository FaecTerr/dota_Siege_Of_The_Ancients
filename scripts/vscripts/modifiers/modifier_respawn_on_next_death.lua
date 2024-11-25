modifier_respawn_on_next_death = class({})

LinkLuaModifier( "modifier_respawn_on_next_death", "modifiers/modifier_respawn_on_next_death", LUA_MODIFIER_MOTION_NONE )

function modifier_respawn_on_next_death:IsDebuff() return false end
function modifier_respawn_on_next_death:IsPurgable() return false end
function modifier_respawn_on_next_death:RemoveOnDeath() return false end
function modifier_respawn_on_next_death:IsPermanent() return true end
function modifier_respawn_on_next_death:IsHidden() return false end


function modifier_respawn_on_next_death:OnCreated( kv )
    	
end

function modifier_respawn_on_next_death:DeclareFunctions()
	local funcs = {
  		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_respawn_on_next_death:OnDeath(params)
	local caster = self:GetCaster()	
    local parent = self:GetParent()
    
    local attacker = params.attacker
    local target = params.unit
    
   	--print("QQshka died: " .. target:GetName() .. " (parent: " .. parent:GetName() .. ")")
    if parent ~= nil and target == parent and not target:IsReincarnating() then
    	--print("RESPAWN")
    	--StartSoundEvent("Outpost.Channel", self:GetCaster())
    	    	
    	Timers:CreateTimer(2.5, function () 
			EmitSoundOn( "Hero_SkeletonKing.Reincarnate.Stinger.Arcana", target)
    	end)
    	
		Timers:CreateTimer(5, function () 
			--Spawn tombstone
			if parent ~= nil then
				local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_reincarnation.vpcf", PATTACH_POINT, parent)
				local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_POINT, parent)
				local newItem = CreateItem("item_tombstone", parent, parent)
        		newItem:SetPurchaseTime(0)
        		newItem:SetPurchaser(parent)
        		local tombstone = SpawnEntityFromTableSynchronous("dota_item_drop", {} )
        		tombstone:SetContainedItem( newItem )
        		tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
        		FindClearSpaceForUnit( tombstone, parent:GetAbsOrigin(), true )  
        		self:Destroy()
        	end
		end)
  	end
end

function modifier_respawn_on_next_death:OnIntervalThink()
  	local parent = self:GetParent()
end

function modifier_respawn_on_next_death:GetTexture()
	return "Reincarnation_icon"
end

















