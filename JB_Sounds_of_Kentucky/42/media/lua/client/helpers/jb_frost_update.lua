JB_AmbientNature = JB_AmbientNature or {}

local hoursUntilFrost = 6
local hoursUntilMelt  = 672

local function getMD(player)
    player = player or getPlayer()
    return player and player:getModData().JB_AmbientNature or nil
end

local function initPlayerMD(player)
    local modData = player:getModData()
    modData.JB_AmbientNature = modData.JB_AmbientNature or {}
    modData = modData.JB_AmbientNature
    modData.Frost = modData.Frost or nil
    modData.frostCounter = modData.frostCounter or 0
    modData.meltingHours = modData.meltingHours or 0
end

Events.OnCreatePlayer.Add(function(id)
    local player = getSpecificPlayer(id)
    if player then initPlayerMD(player) end
end)

local function updateFrost()
    local player = getPlayer()
    if not player then return end
    local modData = getMD(player)
    if not modData then return end

    local cm = getClimateManager()
    local temp = cm:getTemperature()
    local wind = cm:getWindspeedKph()
    local season = cm:getSeasonId()

    local frostTemp = (wind >= 19 and 2) or (wind > 6 and -2) or 0

    if temp < frostTemp then
        modData.frostCounter = modData.frostCounter + 1
        if modData.frostCounter >= hoursUntilFrost and not modData.Frost then
            modData.Frost = true
            modData.meltingHours = 0
        end
        if modData.Frost and modData.meltingHours > 0 then
            modData.meltingHours = math.max(0, modData.meltingHours - 2)
        end
    else
        modData.frostCounter = 0
        if modData.Frost then
            modData.meltingHours = modData.meltingHours + 1
        end
    end

    if modData.Frost and modData.meltingHours >= hoursUntilMelt and (season >= 1 and season <= 4) then
        modData.Frost = nil
        modData.frostCounter, modData.meltingHours = 0, 0
    end

    JB_AmbientNature.Frost = modData.Frost

--[[     print(string.format(
        "FrostState > frostCounter: %s, meltingHours: %s, Frost: %s",
        tostring(modData.frostCounter),
        tostring(modData.meltingHours),
        tostring(modData.Frost)
    )) ]]

    
end

if not isClient() then
    Events.EveryHours.Add(updateFrost)
end

return JB_AmbientNature
