item_pocket_tptower = class({})

LinkLuaModifier( "modifier_item_pocket_tptower", "items/item_pocket_tptower", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_pocket_tptower:GetIntrinsicModifierName()
  return "modifier_item_pocket_tptower"
end

function item_pocket_tptower:OnSpellStart()
    if not IsServer() then return end
    
    local tower = CreateUnitByName("npc_dota_tp_tower", self:GetCaster():GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
    tower:AddNewModifier(tower, self, "modifier_kill", { duration = 360 })
end

--------------------------------------------------------------------------------

modifier_item_pocket_tptower = class({})

function modifier_item_pocket_tptower:IsHidden() return true end
function modifier_item_pocket_tptower:IsPurgable() return false end
function modifier_item_pocket_tptower:IsPurgeException() return false end
function modifier_item_pocket_tptower:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_pocket_tptower:DeclareFunctions()
  local funcs = 
  {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE 
  }
  return funcs
end


function modifier_item_pocket_tptower:GetModifierMoveSpeedBonus_Percentage()
  return 15
end





