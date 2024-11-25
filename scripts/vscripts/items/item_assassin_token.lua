item_assassin_token = class({})

--------------------------------------------------------------------------------


function item_assassin_token:OnSpellStart()
	local parent = self:GetParent()
	
	if parent ~= nil and IsServer() then 
		local items = { "item_shinobi_mask", "item_flashbang", "item_mind_breaker" }
				
		if self.open == nil then
			self.open = false
		end
		
		if self.open == true then
			self.open = false
			CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "hide_item_panel", {})
		else
			self.open = true
			CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "show_item_panel", { items = items, name = "Assassin" })
		end
	
		--CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "ui_press_assassin_token", {})
	end
end