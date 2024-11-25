item_martianin = class({})

LinkLuaModifier( "modifier_item_martianin", "items/item_martianin", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_martianin_buff", "items/item_martianin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_martianin:GetIntrinsicModifierName()
  return "modifier_item_martianin"
end

function item_martianin:OnSpellStart()
    local caster = self:GetCaster()
    local mod = self:GetCaster():FindModifierByName("modifier_item_martianin_buff")    
    if self:GetCurrentCharges() > 0 and mod == nil then
    	local dur = self:GetSpecialValueFor('Duration')
    	local newmod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_martianin_buff", { duration = dur })
    end
end

--------------------------------------------------------------------------------

modifier_item_martianin = class({})

function modifier_item_martianin:IsHidden() return true end
function modifier_item_martianin:IsPurgable() return false end
function modifier_item_martianin:IsPurgeException() return false end
function modifier_item_martianin:GetAttributes()  return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_martianin:DeclareFunctions()
  local funcs = 
  {
  	
  }
  return funcs
end






