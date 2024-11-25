Commands = Commands or class({})

local admin_ids =
{
	[392028774] = 1,
}

local kick_ids = 
{
	[392028774] = 1,
}



function IsAdmin(player)
	local steam_account_id = PlayerResource:GetSteamAccountID( player:GetPlayerID()  )
	return (admin_ids[steam_account_id] == 1)
end 

function IsMod(player)
	local steam_account_id = PlayerResource:GetSteamAccountID( player:GetPlayerID()  )
	return (kick_ids[steam_account_id] == 1)
end 

function Commands:win(player, arg)
	if not IsAdmin(player) then return end
	local hero = player:GetAssignedHero()	
	GameMode:EndGame( hero:GetTeam() )
end

function Commands:switchsides(player, arg)
	if not IsAdmin(player) then return end
	GameMode:SwitchSides(GameMode)
end

function Commands:roundfourending(player, arg)
	if not IsAdmin(player) then return end
	GameMode.round = 4
	GameMode:FinishRound({ reason = "Cheat Command" })
end

function Commands:finishround(player, arg)
	if not IsAdmin(player) then return end
	GameMode:FinishRound({ reason = "Cheat Command" })
end
