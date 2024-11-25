LinkLuaModifier( "modifier_looting_bounty", "abilities/ability_looting_bounty", LUA_MODIFIER_MOTION_NONE )

ability_looting_bounty = class({})

function ability_looting_bounty:GetIntrinsicModifierName()
    return "modifier_looting_bounty"
end

modifier_looting_bounty = class({})

function modifier_looting_bounty:IsDebuff() return false end
function modifier_looting_bounty:IsPurgable() return false end
function modifier_looting_bounty:RemoveOnDeath() return false end
function modifier_looting_bounty:IsPermanent() return true end
function modifier_looting_bounty:IsHidden() return true end

function modifier_looting_bounty:OnCreated( kv )
	self:StartIntervalThink(0.05)
	self.distance = 0
    self:SetHasCustomTransmitterData(true)
    
    if IsServer() then
		self.listener = ListenToGameEvent("entity_killed", Dynamic_Wrap( modifier_looting_bounty, 'UnitDeath' ), self)
	end
end

function modifier_looting_bounty:OnIntervalThink()
  	local parent = self:GetParent()
	if IsServer() then

	end
end

function modifier_looting_bounty:UnitDeath(event)
	if not IsServer() then return end
			
    local parent = self:GetParent()    
	local killedUnit = EntIndexToHScript( event.entindex_killed )	
	local killerUnit = EntIndexToHScript( event.entindex_attacker )	
	
	if killerUnit == nil then return end
	if parent == nil then return end
	
   	local origin = killedUnit:GetAbsOrigin()
   	
	if killerUnit == parent and not killedUnit:IsHero() and not killedUnit:IsWard() then
		local amount = 0
		local pos = killedUnit:GetAbsOrigin()
		local dropType = "item_bones"
		
		local name = killedUnit:GetUnitName()
		
		if name == "npc_dota_creep_neutral" then 
			amount = amount + 1
		
		--Kobolds			
		elseif name == "npc_dota_neutral_kobold" then 
			amount = amount + 1	
			dropType = "item_bones"	
		elseif name == "npc_dota_neutral_kobold_tunneler" then 
			amount = amount + 1
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_kobold_taskmaster" then 
			amount = amount + 1
			dropType = "item_bones"
		
		--Hill Trolls
		elseif name == "npc_dota_neutral_forest_troll_berserker" then 
			amount = amount + 2	
			dropType = "item_bones"	
		elseif name == "npc_dota_neutral_forest_troll_high_priest" then 
			amount = amount + 1
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_dark_troll" then 
			amount = amount + 2
			dropType = "item_bones"		
		elseif name == "npc_dota_neutral_dark_troll_warlord" then 
			amount = amount + 3
			dropType = "item_bones"		
		elseif name == "npc_dota_dark_troll_warlord_skeleton_warrior" then 
			amount = amount + 1
			dropType = "item_bones"
		
		
		--Gnolls
		elseif name == "npc_dota_neutral_gnoll_assassin" then 
			amount = amount + 2
			dropType = "item_bones"
			
		--Centaurs
		elseif name == "npc_dota_neutral_centaur_outrunner" then 
			amount = amount + 2
			dropType = "item_bones"		
		elseif name == "npc_dota_neutral_centaur_khan" then 
			amount = amount + 5
			dropType = "item_bones"
		
		--Satyres
		elseif name == "npc_dota_neutral_satyr_trickster" then 
			amount = amount + 1
			dropType = "item_bones"		
		elseif name == "npc_dota_neutral_satyr_soulstealer" then 
			amount = amount + 2
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_satyr_hellcaller" then 
			amount = amount + 6
			dropType = "item_bones"
		
		--Hellbears
		elseif name == "npc_dota_neutral_polar_furbolg_champion" then 
			amount = amount + 3
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_polar_furbolg_ursa_warrior" then 
			amount = amount + 6
			dropType = "item_bones"
		
		--Wolfs
		elseif name == "npc_dota_neutral_giant_wolf" then 
			amount = amount + 2
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_alpha_wolf" then 
			amount = amount + 3
			dropType = "item_bones"
			
		--Ogres
		elseif name == "npc_dota_neutral_ogre_mauler" then 
			amount = amount + 2
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_ogre_magi" then 
			amount = amount + 4
			dropType = "item_bones"
			
		--Ancient Thunder
		elseif name == "npc_dota_neutral_small_thunder_lizard" then 
			amount = amount + 3
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_big_thunder_lizard" then 
			amount = amount + 4
			dropType = "item_bones"		
		
		--Ancient Frostbitten
		elseif name == "npc_dota_neutral_frostbitten_golem" then 
			amount = amount + 2
			dropType = "item_bones"
		elseif name == "npc_dota_neutral_ice_shaman" then 
			amount = amount + 6
			dropType = "item_bones"
		
		--Mud Golems
		elseif name == "npc_dota_neutral_mud_golem" then 
			amount = amount + 2	
			dropType = "item_pebbles"	
		elseif name == "npc_dota_neutral_mud_golem_split" then 
			amount = amount + 1
			dropType = "item_pebbles"
			
		--Ancient Golems
		elseif name == "npc_dota_neutral_rock_golem" then 
			amount = amount + 4	
			dropType = "item_pebbles"	
		elseif name == "npc_dota_neutral_granite_golem" then 
			amount = amount + 7
			dropType = "item_pebbles"
		
		--Ghosts 
		elseif name == "npc_dota_neutral_fel_beast" then 
			amount = amount + 1
			dropType = "item_ectoplasm"
		elseif name == "npc_dota_neutral_ghost" then 
			amount = amount + 3
			dropType = "item_ectoplasm"
		
		--Harpies
		elseif name == "npc_dota_neutral_harpy_scout" then 
			amount = amount + 1
			dropType = "item_feathers"
		elseif name == "npc_dota_neutral_harpy_storm" then 
			amount = amount + 1
			dropType = "item_feathers"
		
		--Wildwings
		elseif name == "npc_dota_neutral_wildkin" then 
			amount = amount + 1
			dropType = "item_feathers"
		elseif name == "npc_dota_neutral_enraged_wildkin" then 
			amount = amount + 3
			dropType = "item_feathers"	
			
		--Ancient Dragons
		elseif name == "npc_dota_neutral_black_drake" then 
			amount = amount + 2
			dropType = "item_feathers"
		elseif name == "npc_dota_neutral_black_dragon" then 
			amount = amount + 4
			dropType = "item_feathers"			
		
		--Pines
		elseif name == "npc_dota_neutral_warpine_raider" then 
			amount = amount + 1
			dropType = "item_pines"
		
		else
			amount = amount + 1
			dropType = "item_bones"
		end
		
		if killedUnit:IsIllusion() then
			dropType = "item_ectoplasm"
			amount = amount + 1
		end
		
		for i = 1, amount do
			local newItem = CreateItem(dropType, parent, parent)
			--print("attempt to spawn")
		        newItem:SetPurchaseTime(0)
		        newItem:SetPurchaser(killerUnit) 
		        CreateItemOnPositionSync(pos, newItem)
  				newItem:LaunchLoot(false, 300, 0.75, pos + RandomVector(RandomFloat(25, 125)), nil)
	        
        end
	end
end

function modifier_looting_bounty:OnDestroy()
	if self.listener ~= nil then
		StopListeningToGameEvent(self.listener)
	end
end

function modifier_looting_bounty:GetTexture()
	return "modifier_looting_bounty"
end















