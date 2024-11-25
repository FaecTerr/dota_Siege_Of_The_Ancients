item_scout_token = class({})

--------------------------------------------------------------------------------


function item_scout_token:OnSpellStart()
	local parent = self:GetParent()
	
	if parent ~= nil and IsServer() then 		
		local items = { "item_flare_gun", "item_ninja_gear", "item_trickster_cloak" }
		
		if self.open == nil then
			self.open = false
		end
		
		if self.open == true then
			self.open = false
			CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "hide_item_panel", {})
		else
			self.open = true
			CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "show_item_panel", { items = items, name = "Scout" })
		end
	
		--CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "ui_press_assassin_token", {})
	end
end