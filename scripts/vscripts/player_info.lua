if PlayerInfo == nil then
    PlayerInfo = class({})
end

--------------------------------------------------------------------------------
-- init
--------------------------------------------------------------------------------
function PlayerInfo:Init()
    PlayerInfo.data = {}
    local index_good, index_bad = 0, 0
    for i = 0, DOTA_MAX_TEAM_PLAYERS do
        local player = PlayerResource:GetPlayer(i)
        if player and PlayerResource:IsValidTeamPlayer(i) and IsServer() then
            PlayerInfo.data[i] = { 
                Index = 0,  -- Index inside of team
                PlayerId = i, 
                SteamId = PlayerResource:GetSteamID(i),
                TeamId = PlayerResource:GetTeam(i),
                Hero = nil,
                TotalDamage = 0, -- 
            }
            if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
                index_good = index_good + 1
                PlayerInfo.data[i].Index = index_good
            end
            if PlayerResource:GetTeam(i) == DOTA_TEAM_BADGUYS then
                index_bad = index_bad + 1
                PlayerInfo.data[i].Index = index_bad
            end
        end
    end
end


--------------------------------------------------------------------------------
-- Randomise Hero
--------------------------------------------------------------------------------
function PlayerInfo:RandomHero()
    for playerId,data in pairs(PlayerInfo.data) do
        if not PlayerResource:HasSelectedHero(playerId) then
            PlayerResource:GetPlayer(playerId):MakeRandomHeroSelection()
        end
    end
end