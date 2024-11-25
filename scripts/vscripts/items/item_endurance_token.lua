item_endurance_token = class({})

--------------------------------------------------------------------------------


function item_endurance_token:OnSpellStart()
	local parent = self:GetParent()
	
	if parent ~= nil and IsServer() then 		
		local items = { "item_rattlecage", "item_stormcrafter", "item_craggy_coat" }
		
		if self.open == nil then
			self.open = false
		end
		
		if self.open == true then
			self.open = false
			CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "hide_item_panel", {})
		else
			self.open = true
			CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "show_item_panel", { items = items, name = "Endurance" })
		end
	
		--CustomGameEventManager:Send_ServerToPlayer(parent:GetPlayerOwner(), "ui_press_assassin_token", {})
	end
end