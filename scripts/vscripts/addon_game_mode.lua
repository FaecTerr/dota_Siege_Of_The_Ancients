-- Generated from template
require('utils/commands/custom_commands')
require('utils/timers')
require('player_info' )

if GameMode == nil then
	_G.GameMode = class({}) 
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	
	PrecacheItemByNameAsync( "item_tombstone", function( item ) end )
	PrecacheItemByNameAsync( "item_bones", function( item ) end )
	
	local list = 
  	{  		
  		model = 
  		{
  			"models/props_gameplay/lantern/lantern_of_sight.vmdl",	
  		},
  		soundfile = 
  		{ 	
  			"soundevents/game_sounds_heroes/game_sounds_sven.vsndevts",
  			"soundevents/game_sounds_heroes/game_sounds_void_spirit.vsndevts",
  			"soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts",
  			"soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts",
  			"soundevents/game_sounds_heroes/game_sounds_kez.vsndevts",
  			"soundevents/custom_sounds.vsndevts"
  		},
  		particle = 
        {
        	"particles/generic_gameplay/generic_break.vpcf",
        	"particles/econ/items/clockwerk/clockwerk_2022_cc/clockwerk_2022_cc_rocket_flare.vpcf",
        	"particles/econ/items/treant_protector/treant_ti10_immortal_head/treant_ti10_immortal_overgrowth_root_small.vpcf",
        	"particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf",
        	"particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf",
        	"particles/units/heroes/hero_skeletonking/skeletonking_reincarnation.vpcf",
        	"particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf",
        	"particles/units/heroes/hero_sniper/sniper_shard_concussive_grenade_model.vpcf",
        	"particles/units/heroes/hero_dragon_knight/dragon_knight_shard_fireball.vpcf",
        	"particles/econ/events/compendium_2023/compendium_2023_teleport_core.vpcf",
        	"particles/units/heroes/hero_oracle/oracle_scepter_rain_of_destiny.vpcf",
        	"particles/ui_mouseactions/tower_range_indicator_default.vpcf",
        	"particles/ui_mouseactions/range_finder_aoe.vpcf"
        	
        },
    	particle_folder = 
    	{
    	
    	}
  	}
  	
  	for k,v in pairs(list) do
    	for z,x in pairs(v) do 
    		PrecacheResource(k, x, context)
    	end
  	end
end

--Used later for sides change
starting_gold = 1500
roundtime = 300
preptime = 30

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = GameMode()
		
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE , false ) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_HASTE, false ) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ILLUSION, false ) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_INVISIBILITY, false ) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_REGENERATION, false ) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_ARCANE, false ) --Arcane
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_SHIELD, false ) --Shield
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_XP, false ) --XP
	
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_BOUNTY, false ) --Bounty
	GameRules:GetGameModeEntity():SetRuneEnabled( DOTA_RUNE_WATER, true ) --Water
	
	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( -1 )
	GameRules:GetGameModeEntity():SetBuybackEnabled(false) 
	GameRules:GetGameModeEntity():SetDaynightCycleAdvanceRate(2)
	GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled(false)
	
	GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 0 )
	GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 0 )
	GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )
	
	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled( true )
	GameRules:GetGameModeEntity():SetUseTurboCouriers( false )
	GameRules:GetGameModeEntity():SetCanSellAnywhere( false )	
	GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride( 0.0 )
	
	
	GameRules:GetGameModeEntity():SetCustomGlyphCooldown(60*60*60)
	GameRules:GetGameModeEntity():SetCustomScanCooldown(60*60*60)
	GameRules:GetGameModeEntity():SetCustomScanMaxCharges(0)
	
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1300)
	
	GameRules:GetGameModeEntity():SetBountyRuneSpawnInterval(60*60*60)
	GameRules:GetGameModeEntity():SetWaterRuneLastSpawnTime(60*60*60)
	GameRules:SetNextRuneSpawnTime(180)
	
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetCustomGameBansPerTeam( 0 )
	GameRules:SetHeroSelectionTime( 30.0 )	
	GameRules:SetPreGameTime( 0.0 )	
	GameRules:SetTimeOfDay( 0.15 )	
	GameRules:SetHeroRespawnEnabled(false)
	
	
	GameRules:SetStartingGold(starting_gold)

	GameRules:SetGoldPerTick(0)
	GameRules:SetFirstBloodActive(false)
	
	GameRules:SetNeutralInitialSpawnOffset(preptime * -1 + 1.1 + 5)
	
	GameRules.AddonTemplate:InitGameMode()
	
end

function IsSoloGame()
	local DefensePlayers = PlayerResource:GetPlayerCountForTeam(GameMode:GetDefenderTeam())
    local AttackPlayers = PlayerResource:GetPlayerCountForTeam(GameMode:GetAttackerTeam())
    
    if DefensePlayers + AttackPlayers > 1 then
    	return false
    end
    
	return true
end

score = { }
team_sizes = { }
active_players = {}
switch_sides = false
heroes = { }
round = 0

entitiesToSpawn = { }
table_units_to_refresh = { }

assassins_list = { }
brawlers_list = { }
sustainers_list = { }
casters_list = { }
scouts_list = { }

function GameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )
	self:CreateUnits()	
	
	ListenToGameEvent( "dota_on_hero_finish_spawn", Dynamic_Wrap(GameMode , "OnHeroFinishSpawn" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( self, 'OnEntityKilled' ), self )
	--ListenToGameEvent( "entity_killed", Dynamic_Wrap( modifier_item_soul_collector, 'OnKill' ), self )
	ListenToGameEvent( "player_chat", Dynamic_Wrap(ChatListener, 'OnPlayerChat'), self)
	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameRulesStateChange' ), self )
	
	CustomGameEventManager:RegisterListener("add_item", Dynamic_Wrap(self, 'OnProvideItem'))
	CustomGameEventManager:RegisterListener("UpdatePreviewHero", Dynamic_Wrap(self, 'RequestClass'))
	
	CustomGameEventManager:RegisterListener("SwapHeroAtTable", Dynamic_Wrap(self, 'SwapHero'))
	
	
	
    --GameRules:GetGameModeEntity():SetExecuteOrderFilter(GameMode.FilterExecuteOrder, self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap( self, 'GameEventsFilter' ), self)

	GameMode.Gold_Bounty = 
	{
		[1] = 1400,
		[2] = 1600,
		[3] = 1800,
		[4] = 1800, --No reason )))
		[5] = 1400,
		[6] = 1600,
		[7] = 1800,
		[8] = 1800, -- Probably No reason )))
		[9] = 1800 	-- No reason )))
	}		
	GameMode.Gold_Bounty_Win = 
	{
		[1] = 200,
		[2] = 400,
		[3] = 600,
		[4] = 600, --No reason )))
		[5] = 200,
		[6] = 400,
		[7] = 600,
		[8] = 600, -- Probably No reason )))
		[9] = 600 	-- No reason )))
	}	
	GameMode.Exp_Bounty = 
	{
		[1] = 1200,
		[2] = 2000,
		[3] = 2800,
		[4] = 2800, --No reason )))
		[5] = 1200,
		[6] = 2000,
		[7] = 2800,
		[8] = 2800, --Probably no reason
		[9] = 2800  --No reason))
	}
	
	GameMode.ROUND_TIER = { 
        [1] = "item_tier1_token", 
        [2] = "item_tier1_token", 
        [3] = "item_tier2_token", 
        [4] = "item_tier2_token",        
        [5] = "item_tier3_token", 
        [6] = "item_tier3_token", 
        [7] = "item_tier4_token", 
        [8] = "item_tier4_token",
        [9] = "item_tier5_token",
    }
    
    self.shrines_destroyed = 0
    self.RoundTimer = 330
    
    --Pool: A: 8	B: 8	C: 8	E: 8	S: 8
    
	assassins_list = { "npc_dota_hero_nyx_assassin", "npc_dota_hero_slark", "npc_dota_hero_templar_assassin", "npc_dota_hero_riki",  "npc_dota_hero_bloodseeker", "npc_dota_hero_nevermore", "npc_dota_hero_kez", "npc_dota_hero_broodmother" }
	brawlers_list = { "npc_dota_hero_marci", "npc_dota_hero_pangolier", "npc_dota_hero_huskar", "npc_dota_hero_muerta", "npc_dota_hero_lina", "npc_dota_hero_legion_commander" }
	sustainers_list = { "npc_dota_hero_shredder", "npc_dota_hero_mars", "npc_dota_hero_tidehunter", "npc_dota_hero_pudge", "npc_dota_hero_bristleback", "npc_dota_hero_death_prophet", "npc_dota_hero_necrolyte", "npc_dota_hero_primal_beast" }
	casters_list = { "npc_dota_hero_invoker", "npc_dota_hero_leshrac", "npc_dota_hero_rubick", "npc_dota_hero_dark_seer", "npc_dota_hero_pugna", "npc_dota_hero_crystal_maiden", "npc_dota_hero_abaddon" }
	scouts_list = { "npc_dota_hero_rattletrap", "npc_dota_hero_venomancer", "npc_dota_hero_hoodwink", "npc_dota_hero_bounty_hunter", "npc_dota_hero_terrorblade", "npc_dota_hero_furion", "npc_dota_hero_phoenix", "npc_dota_hero_night_stalker", "npc_dota_hero_razor" }
end

function GameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		PlayerInfo:Init()
	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		PlayerInfo:RandomHero()
	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then	
	end
end

function GameMode:GetDefenderTeam()
  if switch_sides == true then
    return DOTA_TEAM_BADGUYS
  end
  return DOTA_TEAM_GOODGUYS
end

function GameMode:GetAttackerTeam()
  if switch_sides == true then
    return DOTA_TEAM_GOODGUYS
  end
  return DOTA_TEAM_BADGUYS
end

init_teams = false
init_game = false
-- Evaluate the state of the game
function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print("hello")
		--GameRules:BotPopulate()
		
		--Countdown that will end round once ran out
		if self.RoundTimer > 0 then
			--self.RoundTimer = self.RoundTimer - 1
		else
			--self:FinishRound()
		end
				
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		--
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_STRATEGY_TIME then
		if IsInToolsMode() then
			GameRules:BotPopulate()
		end
		
		if init_teams == false then
			--Setting team sizes for the game
			
			self.RoundTimer = 330
			
			team_sizes[DOTA_TEAM_GOODGUYS] = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
			team_sizes[DOTA_TEAM_BADGUYS] = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
			round = 1
					
			score[DOTA_TEAM_GOODGUYS] = 0
			score[DOTA_TEAM_BADGUYS] = 0
			
			init_teams = true
		end
	end
	
	if  GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and not init_game then
		self.prepare_for_new_round = true
		init_game = true
		Timers:CreateTimer(2, function ()			
			self:StartNewRound()
		end)
		
		
		if IsServer() then
			local couriers = Entities:FindAllByClassname("npc_dota_courier")
	
			for _,courier in pairs(couriers) do
				courier:AddNewModifier(courier, courier, "modifier_courier_invul", { duration = -1 })
			end	
		end
	end
	return 1
end

function GameMode:CreateUnits()
	--Buildings
LinkLuaModifier( "modifier_regenerative_universal_damage_barrier_lua", "modifiers/modifier_regenerative_universal_damage_barrier_lua", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_bonus_armor_aura", "modifiers/modifier_bonus_armor_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_attack_speed_aura", "modifiers/modifier_bonus_attack_speed_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_armor_aura", "modifiers/modifier_bonus_armor_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_barrier_regen_aura", "modifiers/modifier_barrier_regen_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_damage_resist", "modifiers/modifier_damage_resist", LUA_MODIFIER_MOTION_NONE )
	
	--Everything ongoin is Server only and probably causes clients to crash?? IDK but need to test to elaborate	
	if not IsServer() then return end
	
	local DefensePlayers = PlayerResource:GetPlayerCountForTeam(self:GetDefenderTeam())
    local AttackPlayers = PlayerResource:GetPlayerCountForTeam(self:GetAttackerTeam())
	
	--How much each team opressed by another in terms of player count
	local DefenseOverwhelm = DefensePlayers - AttackPlayers
	local AttackOverwhelm = AttackPlayers - DefensePlayers
		
	--Shrine 1 position / DEFENSIVE SHRINE	
	local shrine1_spots = Entities:FindAllByName( "spawn_shrine_1" )
	local shrine1_position = Vector(100, -400, 0)  
	for key, spot in pairs(shrine1_spots) do
		shrine1_position = spot:GetAbsOrigin()
	end 
	local shrine1 = CreateUnitByName("npc_dota_structure_defensive_tower", shrine1_position, true, nil, nil, GameMode:GetDefenderTeam())
	shrine1:RemoveModifierByName("modifier_invulnerable")
	shrine1:SetAbsOrigin(shrine1_position)  
	local barrier1 = shrine1:AddNewModifier(shrine1, nil, "modifier_regenerative_universal_damage_barrier_lua", { duration = -1.0 }) 
	shrine1:AddNewModifier(shrine1, nil, "modifier_barrier_regen_aura", { duration = -1.0 }) 
	shrine1:AddNewModifier(shrine1, nil, "modifier_damage_resist", { duration = -1.0 }) 
	shrine1:SetEntityName("shrine")
    
  	
  	--Shrine 2 position / OFFENSIVE SHRINE
  	local shrine2_spots = Entities:FindAllByName( "spawn_shrine_2" )
	local shrine2_position = Vector(600, -400, 0)  
	for key, spot in pairs(shrine2_spots) do
		shrine2_position = spot:GetAbsOrigin()
	end 
	local shrine2 = CreateUnitByName("npc_dota_structure_offensive_tower", shrine2_position, true, nil, nil, GameMode:GetDefenderTeam())
	shrine2:RemoveModifierByName("modifier_invulnerable")
	shrine2:SetAbsOrigin(shrine2_position)  
	local barrier2 = shrine2:AddNewModifier(shrine2, nil, "modifier_regenerative_universal_damage_barrier_lua", { duration = -1.0 })
	local attackspeed_buff = shrine2:AddNewModifier(shrine2, nil, "modifier_bonus_attack_speed_aura", { duration = -1.0 })
	shrine2:SetEntityName("shrine")
	shrine2:AddNewModifier(shrine2, nil, "modifier_damage_resist", { duration = -1.0 }) 
	
	--Shrine 3 position / SPECIAL SHRINE
  	local shrine3_spots = Entities:FindAllByName( "spawn_shrine_3" )
	local shrine3_position = Vector(1100, -400, 0)  
	for key, spot in pairs(shrine3_spots) do
		shrine3_position = spot:GetAbsOrigin()
	end 
	local shrine3 = CreateUnitByName("npc_dota_structure_special_tower", shrine3_position, true, nil, nil, GameMode:GetDefenderTeam())
	shrine3:RemoveModifierByName("modifier_invulnerable")
	shrine3:SetAbsOrigin(shrine3_position)  
	local barrier3 = shrine3:AddNewModifier(shrine3, nil, "modifier_regenerative_universal_damage_barrier_lua", { duration = -1.0 })
	local armor_buff = shrine3:AddNewModifier(shrine3, nil, "modifier_bonus_armor_aura", { duration = -1.0 })
  	shrine3:SetEntityName("shrine")
  	shrine3:AddNewModifier(shrine3, nil, "modifier_damage_resist", { duration = -1.0 }) 
  	
  	
  	shrine1:SetMaxHealth(shrine1:GetMaxHealth() + 25 * (AttackPlayers - 1))
  	shrine1:SetHealth(shrine1:GetMaxHealth())
  	
  	shrine2:SetMaxHealth(shrine2:GetMaxHealth() + 25 * (AttackPlayers - 1))
  	shrine2:SetHealth(shrine2:GetMaxHealth())
  	
  	shrine3:SetMaxHealth(shrine3:GetMaxHealth() + 25 * (AttackPlayers - 1))
  	shrine3:SetHealth(shrine3:GetMaxHealth())
  	
  	--Preparing buildings for later removal
	table_units_to_refresh[#table_units_to_refresh + 1] = shrine1
	table_units_to_refresh[#table_units_to_refresh + 1] = shrine2
	table_units_to_refresh[#table_units_to_refresh + 1] = shrine3
		
  	
	--Tower position / 3 Towers
	local tower_spots = Entities:FindAllByName( "spawn_tower_SOTA" )
	local tower_position = Vector(1100, -400, 0)  
	for key, spot in pairs(tower_spots) do
		tower_position = spot:GetAbsOrigin()
		
		local tower = CreateUnitByName("npc_dota_structure_prebase_tower", tower_position, true, nil, nil, GameMode:GetDefenderTeam())
		tower:RemoveModifierByName("modifier_invulnerable")
		tower:SetAbsOrigin(tower_position)  
		local barrier = tower:AddNewModifier(tower, nil, "modifier_regenerative_universal_damage_barrier_lua", { duration = -1.0 })
		
		table_units_to_refresh[#table_units_to_refresh + 1] = tower
		tower:SetEntityName("subtower")
		
		tower:SetMaxHealth(tower:GetMaxHealth() + 50 * (AttackPlayers - 1))
		tower:SetHealth(tower:GetMaxHealth())
		
  		tower:AddNewModifier(tower, nil, "modifier_damage_resist", { duration = -1.0 }) 
	end 
  	
  	--Throne
  	local throne_spots = Entities:FindAllByName( "spawn_throne" )
	local throne_position = Vector(1100, -400, 0)  
	for key, spot in pairs(throne_spots) do
		throne_position = spot:GetAbsOrigin()
	end 
	local throne = CreateUnitByName("npc_dota_structure_siege_throne", throne_position, true, nil, nil, GameMode:GetDefenderTeam())
	throne:RemoveModifierByName("modifier_invulnerable")
	throne:SetAbsOrigin(throne_position)  
	local barrier3 = throne:AddNewModifier(throne, nil, "modifier_regenerative_universal_damage_barrier_lua", { duration = -1.0 })
	throne:SetEntityName("throne")
	
  	throne:AddNewModifier(tower, nil, "modifier_damage_resist", { duration = -1.0 }) 
	
	throne:SetMaxHealth(throne:GetMaxHealth() + 100 * (AttackPlayers - 1))
	throne:SetHealth(throne:GetMaxHealth())
	
	--Outposts
	local outpost_spots = Entities:FindAllByName( "spawn_outpost" )
	local outpost_position = Vector(1100, -400, 0)  
	for key, spot in pairs(outpost_spots) do
		outpost_position = spot:GetAbsOrigin()
		
		local outpost = CreateUnitByName("npc_custom_outpost", outpost_position, true, nil, nil, GameMode:GetAttackerTeam())
		outpost:SetAbsOrigin(outpost_position)  
				
		table_units_to_refresh[#table_units_to_refresh + 1] = outpost
		outpost:SetEntityName("outpost")
	end 
	
	GameMode.throne = throne
	
	table_units_to_refresh[#table_units_to_refresh + 1] = throne
  	
  	--CreateUnitByName("npc_dota_hero_axe", Vector(-2600, 400, 0), true, nil, nil, DOTA_TEAM_BADGUYS)
end

function GameMode:GameEventsFilter(data)
    local target = EntIndexToHScript(data.entindex_target)
    local pid = data["issuer_player_id_const"]
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
        
    if data.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
        if target then
            local item = target:GetContainedItem()
            local item_name = item:GetAbilityName()
            local position = item:GetAbsOrigin()    
            
            
            --TODO:
            --ACTUALLY NEED TO TEST IT
            if item_name == "item_tombstone" and hero:FindAbilityByName("ability_capture_lua") ~= nil then
					ExecuteOrderFromTable({
                    UnitIndex = hero:entindex(),
                    OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
                    Position = position,
                    AbilityIndex = hero:FindAbilityByName("ability_capture_lua"):entindex(),
                })
               	return false
            end
        end 
    end
    
    if data.order_type == DOTA_UNIT_ORDER_GLYPH then
        return false
    end
    
    return true
end

function GameMode:OnHeroFinishSpawn( event )
	
--Gameplay
LinkLuaModifier("modifier_attacker_respawn", "modifiers/modifier_attacker_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_respawn_on_next_death", "modifiers/modifier_respawn_on_next_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_courier_invul", "modifiers/modifier_courier_invul", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_attacker_respawn", "modifiers/modifier_attacker_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_astral", "modifiers/modifier_astral", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_survivor_of_the_temple", "modifiers/modifier_survivor_of_the_temple", LUA_MODIFIER_MOTION_NONE )
		
--Heroes extra innates
LinkLuaModifier("modifier_hero_slark_extrainnate", "modifiers/modifier_hero_slark_extrainnate", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier("modifier_hero_hoodwink_extrainnate", "modifiers/modifier_hero_hoodwink_extrainnate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_hero_tidehunter_extrainnate", "modifiers/modifier_hero_tidehunter_extrainnate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_teleport_controlled_units", "modifiers/modifier_teleport_controlled_units", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_treants_trees", "modifiers/modifier_treants_trees", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_shell_agility", "modifiers/modifier_shell_agility", LUA_MODIFIER_MOTION_NONE )

	
	--Giving hero level 5 at start	
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero ~= nil and hPlayerHero:IsRealHero() and IsServer() then
		hPlayerHero:HeroLevelUp(false)
		hPlayerHero:HeroLevelUp(false)
		hPlayerHero:HeroLevelUp(false)
		hPlayerHero:HeroLevelUp(false)
		
		
		hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_survivor_of_the_temple", { duration = -1.0 })
	
		
		if hPlayerHero:GetTeam() == self:GetAttackerTeam() then
			local buff = hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_attacker_respawn", { duration = 30.0 })
		end
    	heroes[#heroes+1] = hPlayerHero
    	
    	
    	local unique = false
		if self:has_value(scouts_list, hPlayerHero:GetClassname()) then
			unique = true
            local shop_ability = hPlayerHero:AddAbility("ability_pocket_shop")
            --local courier_ability = hPlayerHero:AddAbility("ability_power_courier")
            
            shop_ability:SetLevel(1)
            --courier_ability:SetLevel(1)
        end
        if self:has_value(sustainers_list, hPlayerHero:GetClassname()) then
            unique = true
            local tower_ability = hPlayerHero:AddAbility("ability_tower_protection")
            
            tower_ability:SetLevel(1)
        end
       	if self:has_value(casters_list, hPlayerHero:GetClassname()) then
            unique = true
            local magic_hat = hPlayerHero:AddAbility("ability_magic_hat")
            
            magic_hat:SetLevel(1)
        end
		
		if self:has_value(assassins_list, hPlayerHero:GetClassname()) then
            unique = true
            local killer_sense = hPlayerHero:AddAbility("ability_killer_sense")
            
            killer_sense:SetLevel(1)
        end
		
		if not unique then
			local killer_sense = hPlayerHero:AddAbility("ability_underwhelm")
            
            killer_sense:SetLevel(1)
		end
    	
    	
    	--Slark
    	if hPlayerHero:GetClassname() == "npc_dota_hero_slark" then
    		local innate = hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_hero_slark_extrainnate", {duration = -1.0})
    	end
    	
    	--Broodmother
    	if hPlayerHero:GetClassname() == "npc_dota_hero_broodmother" then
    		local innate = hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_teleport_controlled_units", {duration = -1.0})
    	end
    	
    	--Furion
    	if hPlayerHero:GetClassname() == "npc_dota_hero_furion" then
    		local innate = hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_treants_trees", {duration = -1.0})
    	end
    	
    	--Dark Seer
    	if hPlayerHero:GetClassname() == "npc_dota_hero_dark_seer" then
    		local innate = hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_shell_agility", {duration = -1.0})
    	end
    	
    	
    	--Hoodwink
    	if hPlayerHero:GetClassname() == "npc_dota_hero_hoodwink" then
    		--local innate = hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_hero_hoodwink_extrainnate", {duration = -1.0})
    		
    		local innate = hPlayerHero:AddAbility("ability_mistwoods_wayfarer")            
            innate:SetLevel(1)
    	end
    	
    	--Clockwerk
    	if hPlayerHero:GetClassname() == "npc_dota_hero_rattletrap" then    		
    		local innate = hPlayerHero:AddAbility("ability_key_tuning")            
            innate:SetLevel(1)
    	end
    	    	
    	--Bounty Hunter
    	if hPlayerHero:GetClassname() == "npc_dota_hero_bounty_hunter" then    		
    		local innate = hPlayerHero:AddAbility("ability_looting_bounty")            
            innate:SetLevel(1)
    	end
    	
    	--Crystal Maiden
    	if hPlayerHero:GetClassname() == "npc_dota_hero_crystal_maiden" then    		
    		local cheese = hPlayerHero:AddItemByName("item_cheese")
    	end
    	
    	--Tidehunter
    	if hPlayerHero:GetClassname() == "npc_dota_hero_tidehunter" then
    		local innate = hPlayerHero:AddNewModifier(hPlayerHero, nil, "modifier_hero_tidehunter_extrainnate", {duration = -1.0})
    	end
    	
    	--Invoker
    	if hPlayerHero:GetClassname() == "npc_dota_hero_invoker" then
    		hPlayerHero:HeroLevelUp(false)
    	end
    	
    	--Marci
    	if hPlayerHero:GetClassname() == "npc_dota_hero_marci" then
    		hPlayerHero:AddItemByName("item_illusionsts_cape")
    	end
    	
    	--Mars
    	if hPlayerHero:GetClassname() == "npc_dota_hero_mars" then
    		hPlayerHero:AddItemByName("item_horizon")
    	end
    	
    	--Templar Assassin
    	if hPlayerHero:GetClassname() == "npc_dota_hero_templar_assassin" then    		
    		local innate = hPlayerHero:AddAbility("ability_counter_attack_vision")            
            innate:SetLevel(1)
    	end
    	
    	for playerId, data in pairs(PlayerInfo.data) do
			if PlayerResource:GetSelectedHeroEntity(playerId) == hPlayerHero then
				data.Hero = hPlayerHero
			end
		end
		
		
		
		
		local ability = hPlayerHero:AddAbility("ability_capture_lua")
		ability:SetLevel(1) 		
	end
end

function GameMode:AllDefendersDead()
	local defense_dead = true
		
	if not IsServer() then defense_dead = false return false end
	
	if IsSoloGame() or IsInToolsMode() then
		return false
	end

	for playerId, data in pairs(PlayerInfo.data) do
        if data.Hero and not data.Hero:IsNull() and (data.Hero:IsAlive() or data.Hero:IsReincarnating()) then
        	if data.Hero:GetTeam() == self:GetDefenderTeam() then 
        		--print(data.Hero:GetName() .. " is still alive!")
        		defense_dead = false 
        	end
        end
    end
	
	--print("Defenders result: " .. tostring(defense_dead))
	return defense_dead
end

function GameMode:AllAttackersDead()
	local offense_dead = true
	if not IsServer() then offense_dead = false return false end
	
	if IsSoloGame() or IsInToolsMode() then
		return false
	end
	
	for playerId, data in pairs(PlayerInfo.data) do
        if data.Hero and not data.Hero:IsNull() and (data.Hero:IsAlive() or data.Hero:IsReincarnating()) then        
        	if data.Hero:GetTeam() == self:GetAttackerTeam() then 
        		--print(data.Hero:GetName() .. " is still alive!")
        		offense_dead = false 
        	end
        end
    end
    
	--print("Attackers result: " .. tostring(offense_dead))
	return offense_dead
end

function GameMode:RoundWinCondition_KillTeam()
	--print("Check win condition: " .. tostring(self:AllDefendersDead() and self:AllAttackersDead()))
	if IsInToolsMode() or IsSoloGame() then
		--return false
		--print("Tools win")
		return self:AllDefendersDead() and self:AllAttackersDead()
	else
		--print("True win")
		return self:AllDefendersDead() or self:AllAttackersDead()
	end
end

function GameMode:OnEntityKilled( event )
  	local killedUnit = EntIndexToHScript( event.entindex_killed )
	local killedTeam = killedUnit:GetTeam()
    local hero = nil
    
	if not IsServer() then return end
    
    print("unit " .. killedUnit:GetName() .. " has died")
    
    --Get killer in case we need one
	if event.entindex_attacker then
		hero = EntIndexToHScript( event.entindex_attacker )
	end
	
	--Don't do anything if unit is reincarnating	
	if killedUnit:IsReincarnating() then
		return
	end
	
	--If hero has died
	if killedUnit:IsRealHero() then
		--print(killedTeam)
		
		--If entire team is dead
		if self:RoundWinCondition_KillTeam() == true then
			print("Finishing round, all dead")
			--self:FinishRound()
		end
	end
	
	if killedUnit:GetName() == "shrine" then
		
		--If shrine dies - we lower hp pool of throne
		if self.throne ~= nil then
			self.throne:SetBaseMaxHealth( self.throne:GetBaseMaxHealth() - 125 )
			self.throne:SetBaseHealthRegen( self.throne:GetBaseHealthRegen() - 1.25 )
		end
		
		entitiesToSpawn[self.shrines_destroyed] = killedUnit:GetAbsOrigin()
		self.shrines_destroyed = self.shrines_destroyed + 1
		
		--Bounty for players for killing shrine
		for playerId, data in pairs(PlayerInfo.data) do
        	if data.Hero then
        		if data.Hero:GetTeam() == self:GetAttackerTeam() then 
        			data.Hero:ModifyGold(250, true, DOTA_ModifyGold_CreepKill)
        		end
        	end
    	end
		
		table_units_to_refresh[killedUnit] = nil
	end	
	
	--If tower dies - we score a point for offense team
	if killedUnit:GetName() == "subtower" then
		score[self:GetAttackerTeam()] = score[self:GetAttackerTeam()] + 1
		if self.throne ~= nil then
			self.throne:SetBaseMaxHealth( self.throne:GetBaseMaxHealth() - 275 )
			self.throne:SetBaseHealthRegen( self.throne:GetBaseHealthRegen() - 2.25 )
		end 
		
		--Bounty for players for killing tower
		for playerId, data in pairs(PlayerInfo.data) do
        	if data.Hero then
        		if data.Hero:GetTeam() == self:GetAttackerTeam() then 
        			data.Hero:ModifyGold(350, true, DOTA_ModifyGold_CreepKill)
        		end
        	end
    	end
		
		table_units_to_refresh[killedUnit] = nil
	end	
	--If throne dies - we end half early and provide bonus points to offense team
	if killedUnit:GetName() == "throne" then
		--GameRules:ResetDefeated()
		score[self:GetAttackerTeam()] = score[self:GetAttackerTeam()] + 4
		
		--Skip phase if throne defeated
		if round < 4 then
			round = 4
		elseif round < 8 then
			round = 8
		end
		
		self.cancelCounter = true
		
		self:FinishRound()
	end
end

function GameMode:StartNewRound( event )
self:UI_RoundInfo(round, self:GetAttackerTeam(), false, false)
		--Gameplay
LinkLuaModifier("modifier_attacker_respawn", "modifiers/modifier_attacker_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_respawn_on_next_death", "modifiers/modifier_respawn_on_next_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_courier_invul", "modifiers/modifier_courier_invul", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_attacker_respawn", "modifiers/modifier_attacker_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_astral", "modifiers/modifier_astral", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_survivor_of_the_temple", "modifiers/modifier_survivor_of_the_temple", LUA_MODIFIER_MOTION_NONE )
		

	--5 minutes + 30sec prepare time
	self.RoundTimer = roundtime + preptime
	
	print(self.RoundTimer)
	
	--UpdateTime
	--if self.prepare_for_new_round then
	if true then
		Timers:CreateTimer(1.1, function()
			--print("CLOWN")
			--print(self.RoundTimer)
        	self:UI_RoundTimer(self.RoundTimer)
       		--TODO
       		
       		if not IsSoloGame() then
       			if self.RoundTimer <= 0 or self:RoundWinCondition_KillTeam() == true then
       				local reas = "Not specified"
       				
       				if self.RoundTimer <= 0 then
       					reas = "Time out"
       				end
       				if self:RoundWinCondition_KillTeam() == true then
       					reas =	"Team wipe"
       				end
       				
       	    		self:FinishRound({ reason = reas })
            		return
        		end      
        	end
        	
        	if self.cancelCounter then
        		self.cancelCounter = false
        		return
        	end
        	
        	--if not self.prepare_for_new_round then
        	if true then
        		self.RoundTimer = self.RoundTimer - 1
        	end
        	
			--print(self.RoundTimer)
			
        	return 1
    	end)    
		--self.prepare_for_new_round = false
	end
	
	ref = GameMode
		
	Timers:CreateTimer(preptime + 1.1, function()
		self:UI_RoundInfo(round, self:GetAttackerTeam(), false, true)
	end)
	
	GameRules:SetTimeOfDay(0.25 - preptime / 300)
	
	--Resetting team life counter
	--alive_heroes[DOTA_TEAM_GOODGUYS] = team_sizes[DOTA_TEAM_GOODGUYS]
	--alive_heroes[DOTA_TEAM_BADGUYS] = team_sizes[DOTA_TEAM_BADGUYS]
	
	--print("Radiant heroes: " .. alive_heroes[DOTA_TEAM_GOODGUYS])
	--print("Dire heroes: " .. alive_heroes[DOTA_TEAM_BADGUYS])


	--Preset hero spawn positions for new round that takes into account current offense/defense team		
	local radiant_spawn_entities = Entities:FindAllByName( "info_player_start_goodguys" )
	local dire_spawn_entities = Entities:FindAllByName( "info_player_start_badguys" )
	
	local radiant_spawns = { }
	local dire_spawns = { }
	
	local r = 1
	local d = 1
	
	--Find all spots
	for key, spot in pairs(radiant_spawn_entities) do
		local r_position = spot:GetAbsOrigin()
		radiant_spawns[r] = r_position
		r = r + 1
	end
	for key, spot in pairs(dire_spawn_entities) do
		local d_position = spot:GetAbsOrigin()
		dire_spawns[d] = d_position		
		d = d + 1
	end
	
	if not IsServer() then return end

	--Spawn positions for this round
	for i= 1, #heroes do
		if heroes[i] ~= nil and heroes[i]:IsNull() == false then
					
			local spot = heroes[i]:GetAbsOrigin()
			if heroes[i]:GetTeam() == GameMode:GetDefenderTeam() and #radiant_spawns > 0 then
				--print(#radiant_spawns)
				local spotID = RandomInt(1, #radiant_spawns)
				spot = radiant_spawns[spotID]
				radiant_spawns[spotID] = nil
				table.remove(radiant_spawns, spotID)
				--print(#radiant_spawns)
			end
			if heroes[i]:GetTeam() == GameMode:GetAttackerTeam() and #dire_spawns > 0 then					
				local spotID = RandomInt(1, #dire_spawns)
				spot = dire_spawns[spotID]
				dire_spawns[spotID] = nil
				table.remove(dire_spawns, spotID)
				
				
				--buff:AddParticle()
			end
						
			--Purge on death modifiers
			--Restore Mana
			--Restore Health
			if heroes[i]:IsAlive() == false then
				Timers:CreateTimer(1, function ()	
					heroes[i]:RespawnUnit()
				end)
			else
				heroes[i]:SetHealth(heroes[i]:GetMaxHealth())
				heroes[i]:SetMana(heroes[i]:GetMaxMana())
				heroes[i]:Purge(true, true, false, true, true)
			end
			
			--TODO
			--Reset charges
			
			--Reset SPELL cooldowns
			for j = 0, heroes[i]:GetAbilityCount()-1 do
				local abil = heroes[i]:GetAbilityByIndex(j)
				if abil ~= nil then
					abil:EndCooldown()
				end
			end	
			
			found_spot = FindClearSpaceForUnit(heroes[i], spot, true)
			if found_spot == nil or found_spot == false then
				heroes[i]:SetAbsOrigin(spot)
			end
			
			for m= 0, 9 do
				local cheese = heroes[i]:FindItemInInventory("item_cheese")
				if cheese ~=nil then
					heroes[i]:RemoveItem(cheese)
				end
			end
			
		if heroes[i]:GetClassname() == "npc_dota_hero_crystal_maiden" then    		
    		local cheese = heroes[i]:AddItemByName("item_cheese")
    	end
			
			Timers:CreateTimer(0.5, function ()	
			--Attacker invul + free movement
				if heroes[i]:GetTeam() == self:GetAttackerTeam() then
					local buff = heroes[i]:AddNewModifier(heroes[i], nil, "modifier_attacker_respawn", { duration = preptime })
				end
				Timers:CreateTimer(2, function ()	
					--Creates tombstone after 5 seconds from dying that allows a once-per round ressurection by teammate			
						heroes[i]:AddNewModifier(heroes[i], nil, "modifier_respawn_on_next_death", { duration = -1 })
				end)
			end)
			--TODO:
			--Reset Item cooldowns
		end
	end
	
end

function GameMode:has_value (tab, val)
	if tab == nil then return false end
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


function GameMode:BountyForTeam()
	--Exp and gold bounty for teams
	--Extra gold for winner
	if not IsServer() then return end
	
	for playerId, data in pairs(PlayerInfo.data) do
        
        data.Hero:AddExperience(GameMode.Exp_Bounty[round], DOTA_ModifyXP_Unspecified, false, true)
        
        data.Hero:ModifyGold(GameMode.Gold_Bounty[round], true, DOTA_ModifyXP_Unspecified)
        SendOverheadEventMessage(data.Hero, OVERHEAD_ALERT_GOLD, data.Hero, GameMode.Gold_Bounty[round], nil)
        if data.TeamId == self.LastRoundWinner then
            data.Hero:ModifyGold(GameMode.Gold_Bounty_Win[round], true, DOTA_ModifyXP_Unspecified)
            SendOverheadEventMessage(data.Hero, OVERHEAD_ALERT_GOLD, data.Hero, GameMode.Gold_Bounty_Win[round], nil)
        end
        
        if round == 2 or round == 6 then
        	if self:has_value(assassins_list, data.Hero:GetClassname()) then
            	data.Hero:AddItemByName("item_assassin_token")
            elseif self:has_value(scouts_list, data.Hero:GetClassname()) then
            	data.Hero:AddItemByName("item_scout_token")
            elseif self:has_value(sustainers_list, data.Hero:GetClassname()) then
            	data.Hero:AddItemByName("item_endurance_token")
            else
            	data.Hero:AddItemByName("item_basic_token")
            end
        end
    end
end

function GameMode:ProcessRound( event )
	
end

function GameMode:FinishRound( event )
	print("Yo, round finished. Reason: " .. event.reason)
	
	--TODO:
	--Change tiebreaker to something either playable/infinite mode or be lazy
	
	local team = self:GetAttackerTeam()
	
	if self:AllDefendersDead() then
		score[self:GetAttackerTeam()] = score[self:GetAttackerTeam()] + 1	
		team = self:GetAttackerTeam()
	--If time ran out / all attackers dead while there's at least 1 defender
	else
		score[self:GetDefenderTeam()] = score[self:GetDefenderTeam()] + 1
		team = self:GetDefenderTeam()
	end
	
	self.LastRoundWinner = team	
	self:UI_RoundWin(team)
	
	self.cancelCounter = true
	round = round + 1
	
	local new_round_timer = 5.0
	
	if round == 5 then
		self:SwitchSides()
		
		new_round_timer = 15.0
		
		local tormentors = Entities:FindAllByClassname("npc_dota_miniboss")
		local roshans = Entities:FindAllByClassname("npc_dota_roshan")
		
		for _,entity in pairs(tormentors) do
			entity:RemoveSelf()
		end	
		for _,entity in pairs(roshans) do
			entity:RemoveSelf()
		end	
		
		self.shrines_destroyed = 0
		
		entitiesToSpawn[0] = nil 
		entitiesToSpawn[1] = nil 
		entitiesToSpawn[2] = nil 
	else
		self:BountyForTeam()
		
		if entitiesToSpawn[0] ~= nil then
			local m1 = CreateUnitByName("npc_dota_miniboss", entitiesToSpawn[0], true, nil, nil, DOTA_TEAM_NEUTRALS)
			m1:AddItemByName("item_aghanims_shard")
			entitiesToSpawn[0] = nil
		end
		if entitiesToSpawn[1] ~= nil then
			local m2 = CreateUnitByName("npc_dota_miniboss", entitiesToSpawn[1], true, nil, nil, DOTA_TEAM_NEUTRALS)
			m2:AddItemByName("item_aghanims_shard")
			entitiesToSpawn[1] = nil
		end	
		if entitiesToSpawn[2] ~= nil then
			local rosh = CreateUnitByName("npc_dota_roshan", entitiesToSpawn[2], true, nil, nil, DOTA_TEAM_NEUTRALS)
			rosh:AddItemByName("item_aegis")
			entitiesToSpawn[2] = nil
		end
		
		
		local items_on_the_ground = Entities:FindAllByClassname("dota_item_drop")
	    for _,item_ground in pairs(items_on_the_ground) do
	    	if item_ground and item_ground:GetContainedItem() ~= nil and item_ground:GetContainedItem():GetAbilityName() == "item_cheese" then
	    		UTIL_Remove(item_ground)
	    	end
	    end
		
		--Clear couriers inventories
		if IsServer() then
			local couriers = Entities:FindAllByClassname("npc_dota_courier")
		
			for _,courier in pairs(couriers) do
				for m= 0, 9 do
					local item = courier:FindItemInInventory("item_cheese")
					if item ~= nil then
						courier:RemoveItem(item)
					end
				end
			end	
		end
	end
	
	--Increase damage Resist
	for i = 1, #table_units_to_refresh do
		if table_units_to_refresh[i] ~= nil and table_units_to_refresh[i]:IsNull() == false then
			local resist = table_units_to_refresh[i]:FindModifierByName("modifier_damage_resist")
			if resist ~= nil then
				if round <= 4 then
					resist:SetStackCount(round - 1)
				else
					resist:SetStackCount(round - 5)
				end
			end
		end
	end
	
	if round >= 9 and score[self:GetDefenderTeam()] ~= score[self:GetAttackerTeam()] then
		self:EndGame()
	end
	
	print("Finish round called, starting timer before new round")
		
	self.RoundTimer = roundtime + preptime + new_round_timer
	
	Timers:CreateTimer(new_round_timer, 
	function() 
		self.cancelCounter = false
		self.RoundTimer = roundtime + preptime
		self.prepare_for_new_round = true
		print("New round starting")
		GameMode:StartNewRound() 
	end)
	
	--print('Round:' .. round .. '(Radiant: ' .. score[DOTA_TEAM_GOODGUYS] .. ' Dire: ' .. score[DOTA_TEAM_BADGUYS] .. ' )')
	if IsServer() or IsInToolsMode() then
		Say(nil, 'End of Round ¹' .. (round - 1) .. ' (Radiant: ' .. score[DOTA_TEAM_GOODGUYS] .. ', Dire: ' .. score[DOTA_TEAM_BADGUYS] .. ')', false)
	end
end

function GameMode:SwitchSides( event )
			--Gameplay
LinkLuaModifier("modifier_attacker_respawn", "modifiers/modifier_attacker_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_respawn_on_next_death", "modifiers/modifier_respawn_on_next_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_courier_invul", "modifiers/modifier_courier_invul", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_attacker_respawn", "modifiers/modifier_attacker_respawn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_astral", "modifiers/modifier_astral", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_survivor_of_the_temple", "modifiers/modifier_survivor_of_the_temple", LUA_MODIFIER_MOTION_NONE )
	
	--Clear currently existing buildings
	for i = 1, #table_units_to_refresh do
		if table_units_to_refresh[i] ~= nil and table_units_to_refresh[i]:IsNull() == false then
			table_units_to_refresh[i]:RemoveSelf()
		end
		table_units_to_refresh[i] = nil
	end
	
	--GameMode.throne = nil
	
	for i = 1, #heroes do
		if #heroes > 0 and heroes[i] ~= nil and heroes[i]:IsNull() == false then
			heroes[i]:Purge(true, true, false, true, true)
			
			if heroes[i]:FindModifierByName("modifier_survivor_of_the_temple") then
				heroes[i]:RemoveModifierByName("modifier_survivor_of_the_temple")
			end
			if heroes[i]:FindModifierByName("modifier_survivor_of_the_temple_buff") then
				heroes[i]:RemoveModifierByName("modifier_survivor_of_the_temple_buff")
			end
			
			if heroes[i]:FindModifierByName("modifier_hero_slark_extrainnate") then
				heroes[i]:RemoveModifierByName("modifier_hero_slark_extrainnate")
			end
			if heroes[i]:FindModifierByName("modifier_hero_slark_extrainnate_buff") then
				heroes[i]:RemoveModifierByName("modifier_hero_slark_extrainnate_buff")
			end
			
			if heroes[i]:FindModifierByName("modifier_hero_tidehunter_extrainnate") then
				heroes[i]:RemoveModifierByName("modifier_hero_tidehunter_extrainnate")
			end
			if heroes[i]:FindModifierByName("modifier_hero_tidehunter_extrainnate_buff") then
				heroes[i]:RemoveModifierByName("modifier_hero_tidehunter_extrainnate_buff")
			end
			
			if heroes[i]:FindModifierByName("modifier_item_katamasa_debuff") then
				heroes[i]:RemoveModifierByName("modifier_item_katamasa_debuff")
			end
			
			heroes[i]:AddNewModifier(heroes[i], nil, "modifier_astral", { duration = 15 })
		end
		
		--Reset SPELL cooldowns
		for j = 0, heroes[i]:GetAbilityCount()-1 do
			local abil = heroes[i]:GetAbilityByIndex(j)
			if abil ~= nil then
				abil:EndCooldown()
			end
		end	
	end
	
	
	--TODO: 
	--Clear all wards and other entities (neutrals, thinkers, dominated units, temporary units, traps etc)
	--Slowing Veins
	local ents = Entities:FindAllByClassname("item_veins")
    for _,entity in pairs(ents) do
    	if entity then
    		UTIL_Remove(entity)
    	end
    end
	--Bear traps
	local ents1 = Entities:FindAllByClassname("npc_dota_item_snare")
    for _,entity in pairs(ents1) do
    	if entity then
    		UTIL_Remove(entity)
    	end
    end
    
    --Observer Wards
    local ents2 = Entities:FindAllByClassname("npc_dota_observer_wards")
    for _,entity in pairs(ents2) do
    	if entity then
    		UTIL_Remove(entity)
    	end
    end
    
    --Sentry Wards
    local ents3 = Entities:FindAllByClassname("npc_dota_sentry_wards")
    for _,entity in pairs(ents3) do
    	if entity then
    		UTIL_Remove(entity)
    	end
    end
	
	Timers:CreateTimer(15.0, 
	function() 
	
	--Reset heroes inventories/levels/skills
	for i = 1, #heroes do
		if #heroes > 0 and heroes[i] ~= nil and heroes[i]:IsNull() == false then
			if IsServer() then		
				local hero = heroes[i]	
				
				--Copy old hero basic data
				local pid = hero:GetPlayerID()
				local hero_class = hero:GetClassname()
				
				if hero_class ~= nil and pid ~= nil then
					--print(tostring(hero_class))
					--Reset abilities
					for j = 0, hero:GetAbilityCount()-1 do
						local abil = hero:GetAbilityByIndex(j)
						if abil ~= nil then
							abil:SetLevel(0)
						end
					end			
					heroes[i]:SetAbilityPoints(5)
					
					
					--Copy Handler for previous hero Entity
					--prev_heroes = { }
					--for playerId, data in pairs(PlayerInfo.data) do
						--if PlayerResource:GetSelectedHeroEntity(playerId) == hero then
							--prev_heroes[playerId] = hero
						--end
					--end
					
					--Change PlayerResource Handler (Reset Hero (Necessary for Level Reset, other stuff could be perfectly done without ReplaceHero))
					local new_hero = PlayerResource:ReplaceHeroWith(pid, hero_class, starting_gold, 0)
					
					--Update table value for previous hero
					for playerId, data in pairs(PlayerInfo.data) do
						if PlayerResource:GetSelectedHeroEntity(playerId) == new_hero then
							data.Hero = new_hero
						end
					end
					
					CustomGameEventManager:Send_ServerToAllClients("SwapHeroAtTable", { oldHero = hero, newHero = newHero })
					
					--Remove previous instance of hero
					--hero:RemoveSelf()
					UTIL_Remove(hero)
					
					--Update tables
					table.remove(heroes, i)
					table.insert(heroes, i, new_hero)
					
					--heroes[i] = new_hero
				end
			--For Client
			else 				
				local hero = heroes[i]		
				UTIL_Remove(hero)
					
				--Update tables
				table.remove(heroes, i)
				table.insert(heroes, i, new_hero)
				

			end
		end
	end
	
	if IsServer() then
		--Restock tango
		GameRules:SetItemStockCount(8, DOTA_TEAM_GOODGUYS, "item_tango", -1)
		GameRules:SetItemStockCount(8, DOTA_TEAM_BADGUYS , "item_tango", -1)
		
		--Restock flask
		GameRules:SetItemStockCount(4, DOTA_TEAM_GOODGUYS, "item_flask", -1)
		GameRules:SetItemStockCount(4, DOTA_TEAM_BADGUYS , "item_flask", -1)
		
		--Restock clarity
		GameRules:SetItemStockCount(4, DOTA_TEAM_GOODGUYS, "item_clarity", -1)
		GameRules:SetItemStockCount(4, DOTA_TEAM_BADGUYS , "item_clarity", -1)
	
		--Restock smoke
		GameRules:SetItemStockCount(2, DOTA_TEAM_GOODGUYS, "item_smoke_of_deceit", -1)
		GameRules:SetItemStockCount(2, DOTA_TEAM_BADGUYS , "item_smoke_of_deceit", -1)
		
		--Restock grenade
		GameRules:SetItemStockCount(2, DOTA_TEAM_GOODGUYS, "item_blood_grenade", -1)
		GameRules:SetItemStockCount(2, DOTA_TEAM_BADGUYS , "item_blood_grenade", -1)
	
		--Restock observer
		GameRules:SetItemStockCount(2, DOTA_TEAM_GOODGUYS, "item_ward_observer", -1)
		GameRules:SetItemStockCount(2, DOTA_TEAM_BADGUYS , "item_ward_observer", -1)
		
		--Restock sentry
		GameRules:SetItemStockCount(4, DOTA_TEAM_GOODGUYS, "item_ward_sentry", -1)
		GameRules:SetItemStockCount(4, DOTA_TEAM_BADGUYS , "item_ward_sentry", -1)
	end
	
	--TODO:
	--Move courier respawn point	
	
	--Change side for position tags on the map so towers would be radiant/dire depending on defensing team
	--As well as respawns
	switch_sides = switch_sides == false
	GameMode:CreateUnits()
	
	end)
	
	--TODO:
	--Clear items on ground and neutral item choices
	local items_on_the_ground = Entities:FindAllByClassname("dota_item_drop")
    for _,item_ground in pairs(items_on_the_ground) do
    	if item_ground then
    		UTIL_Remove(item_ground)
    	end
    end
	
	--Clear couriers inventories
	if IsServer() then
		local couriers = Entities:FindAllByClassname("npc_dota_courier")
	
		for _,courier in pairs(couriers) do
			for m= 0, 9 do
				local item = courier:GetItemInSlot(m)
				courier:RemoveItem(item)
			end
		end	
	end
end

function GameMode:EndGame( event )
	if not IsServer() then return end
	--Unlucky for radiant, dire will win any game that is a tie
	if score[DOTA_TEAM_GOODGUYS] > score[DOTA_TEAM_BADGUYS] then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	else
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
end

function GameMode:UI_RoundInfo(round, offense_team, is_open, active)
	CustomGameEventManager:Send_ServerToAllClients("ui_round_info", { MaxRound = "9", Round = round, OffenseTeam = offense_team, ActivePhase = active })
	Timers:CreateTimer(5.0, function()
		self:UI_RoundInfoClose()
	end)
end

function GameMode:UI_RoundInfoClose()
	CustomGameEventManager:Send_ServerToAllClients("ui_round_info_close", {})
end

function GameMode:UI_RoundTimer(time)
    CustomGameEventManager:Send_ServerToAllClients("ui_round_time", { Time = time })
end

function GameMode:UI_RoundWin(team)
	if team == nil then
		team = DOTA_TEAM_GOODGUYS
	end
	CustomGameEventManager:Send_ServerToAllClients("ui_round_win", { RadiantWins = score[DOTA_TEAM_GOODGUYS], DireWins = score[DOTA_TEAM_BADGUYS], team })
	Timers:CreateTimer(3.0, function()
		self:UI_RoundWinClose()
	end)
end

function GameMode:UI_RoundWinClose()
	CustomGameEventManager:Send_ServerToAllClients("ui_round_win_close", { })
end

function GameMode:OnProvideItem(event)
	
	if not IsServer() then return end

	local player = PlayerResource:GetPlayer(event.player)
	local hero = player:GetAssignedHero()
	
	local token = hero:FindItemInInventory("item_scout_token")
	
	if token == nil then
		token = hero:FindItemInInventory("item_assassin_token")
	end	
	if token == nil then
		token = hero:FindItemInInventory("item_endurance_token")
	end
	if token == nil then
		token = hero:FindItemInInventory("item_basic_token")
	end
	
	if token ~= nil then
		hero:RemoveItem(token)
		hero:AddItemByName(event.item_name)
	end
end

all_heroes = {}


all_heroes[4] = "npc_dota_hero_bloodseeker"
all_heroes[5] = "npc_dota_hero_crystal_maiden"
all_heroes[11] = "npc_dota_hero_nevermore"
all_heroes[14] = "npc_dota_hero_pudge"
all_heroes[15] = "npc_dota_hero_razor"
all_heroes[25] = "npc_dota_hero_lina"
all_heroes[29] = "npc_dota_hero_tidehunter"
all_heroes[32] = "npc_dota_hero_riki"
all_heroes[36] = "npc_dota_hero_necrolyte"
all_heroes[40] = "npc_dota_hero_venomancer"
all_heroes[42] = "npc_dota_hero_skeleton_king"
all_heroes[43] = "npc_dota_hero_death_prophet"
all_heroes[45] = "npc_dota_hero_pugna"
all_heroes[46] = "npc_dota_hero_templar_assassin"
all_heroes[51] = "npc_dota_hero_rattletrap"
all_heroes[52] = "npc_dota_hero_leshrac"
all_heroes[53] = "npc_dota_hero_furion"
all_heroes[55] = "npc_dota_hero_dark_seer"
all_heroes[58] = "npc_dota_hero_enchantress"
all_heroes[59] = "npc_dota_hero_huskar"
all_heroes[60] = "npc_dota_hero_night_stalker"
all_heroes[61] = "npc_dota_hero_broodmother"
all_heroes[62] = "npc_dota_hero_bounty_hunter"
all_heroes[74] = "npc_dota_hero_invoker"
all_heroes[86] = "npc_dota_hero_rubick"
all_heroes[88] = "npc_dota_hero_nyx_assassin"
all_heroes[93] = "npc_dota_hero_slark"
all_heroes[98] = "npc_dota_hero_shredder"
all_heroes[99] = "npc_dota_hero_bristleback"
all_heroes[100] = "npc_dota_hero_tusk"
all_heroes[102] = "npc_dota_hero_abaddon"
all_heroes[104] = "npc_dota_hero_legion_commander"
all_heroes[109] = "npc_dota_hero_terrorblade"
all_heroes[119] = "npc_dota_hero_dark_willow"
all_heroes[120] = "npc_dota_hero_pangolier"
all_heroes[123] = "npc_dota_hero_hoodwink"
all_heroes[129] = "npc_dota_hero_mars"
all_heroes[136] = "npc_dota_hero_marci"
all_heroes[137] = "npc_dota_hero_primal_beast"
all_heroes[138] = "npc_dota_hero_muerta"
all_heroes[145] = "npc_dota_hero_kez"


function GetHeroClassByID(id)

	
	return all_heroes[id]	
end

function GameMode:RequestClass(event)
		
	--[[local rep = string.gsub(event.heroname, "%s", "_")
	
	local hero_classname = "npc_dota_hero_" .. string.lower(rep)
	
	if hero_classname == "npc_dota_hero_shadow_fiend" then
		hero_classname = "npc_dota_hero_nevermore"
	end
	if hero_classname == "npc_dota_hero_clockwerk" then
		hero_classname = "npc_dota_hero_rattletrap"
	end
	if hero_classname == "npc_dota_hero_wraith_king" then
		hero_classname = "npc_dota_hero_skeleton_king"
	end
	if hero_classname == "npc_dota_hero_necrophos" then
		hero_classname = "npc_dota_hero_necrolyte"
	end
	
	
	print("result: " .. hero_classname)
	--]]
	
	local hero_classname = tostring(GetHeroClassByID(event.hero_id))
	local played_id = event.local_id
	
	
	local major = "Brawler"
	
	if GameMode:has_value(assassins_list, hero_classname) then
		major = "Assassin"
	elseif GameMode:has_value(scouts_list, hero_classname) then
		major = "Scout"
	elseif GameMode:has_value(sustainers_list, hero_classname) then
		major = "Endurance"
	elseif GameMode:has_value(casters_list, hero_classname) then
		major = "Caster"
	else
		major = "Brawler"
	end

	--print("result: " .. hero_classname .. " (" .. major .. ")")
	--print(Entities:GetLocalPlayer())
	
	if IsServer() then
		CustomGameEventManager:Send_ServerToAllClients("hero_class_response", { name = major, localID = played_id })
	end
	
end



function GameMode:SwapHero(event)

	if IsServer() then return end
	
	print("Client recieve swap (" .. event.oldHero:GetClassname() .. " >> " .. event.newHero:GetClassname() .. ")")
	local oldHero = event.oldHero
	local newHero = event.newHero


	--Update table value for previous hero
	for playerId, data in pairs(PlayerInfo.data) do
		if PlayerResource:GetSelectedHeroEntity(playerId) == new_hero then
			data.Hero = new_hero
		end
	end
end




