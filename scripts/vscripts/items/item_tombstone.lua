item_tombstone = class({})

LinkLuaModifier( "modifier_item_tombstone", "items/item_tombstone", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_tombstone:GetIntrinsicModifierName()
  return "modifier_item_tombstone"
end

function item_tombstone:OnSpellStart()
    local caster = self:GetCaster()
    
end

