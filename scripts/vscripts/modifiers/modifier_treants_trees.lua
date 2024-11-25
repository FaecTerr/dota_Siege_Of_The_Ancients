modifier_treants_trees = class({})

LinkLuaModifier( "modifier_treants_trees", "modifiers/modifier_treants_trees", LUA_MODIFIER_MOTION_NONE )

function modifier_treants_trees:IsDebuff() return false end
function modifier_treants_trees:IsPurgable() return false end
function modifier_treants_trees:RemoveOnDeath() return false end
function modifier_treants_trees:IsPermanent() return true end
function modifier_treants_trees:IsHidden() return true end

function modifier_treants_trees:OnCreated( kv )
	self:StartIntervalThink(0.2)
	
	if IsServer() then
		ListenToGameEvent("entity_killed", Dynamic_Wrap( modifier_treants_trees, 'UnitDeath' ), self)
	end
	--ListenToGameEvent("npc_spawned", Dynamic_Wrap( modifier_treants_trees, 'UnitSpawn' ), self)
end

function modifier_treants_trees:OnIntervalThink()
  	local parent = self:GetParent()

end

function modifier_treants_trees:GetTexture()
	return "modifier_treants_trees"
end

function modifier_treants_trees:UnitDeath(event)
	if not IsServer() then return end
	
    local parent = self:GetParent()    
	local killedUnit = EntIndexToHScript( event.entindex_killed )	
   	local origin = killedUnit:GetAbsOrigin()
   	
	if killedUnit:GetOwner() == parent and IsServer() then
		CreateTempTree(origin, 20.0)
		AddFOWViewer(parent:GetTeamNumber(), parent:GetAbsOrigin(), 125, 20.0, false)
	end
end










