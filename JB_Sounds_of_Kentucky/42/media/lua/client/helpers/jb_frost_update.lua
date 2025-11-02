JB_AmbientNature      = JB_AmbientNature or {}
local hoursUntilFrost = 6
local hoursUntilMelt  = 336 

local function getMD()
    return ModData.getOrCreate("JB_AmbientNature")
end

function JB_AmbientNature.getFrost()
    return getMD().Frost
end

function JB_AmbientNature.getFrostCounter()
    return getMD().frostCounter
end

function JB_AmbientNature.getMeltingHours()
    return getMD().meltingHours
end

function JB_AmbientNature.setFrost(b)
    local md = getMD()
    md.Frost = b
    ModData.add("JB_AmbientNature", md)
    if isServer() then ModData.transmit("JB_AmbientNature") end
end

function JB_AmbientNature.setFrostCounter(b)
    local md = getMD()
    md.frostCounter = b
    ModData.add("JB_AmbientNature", md)
    if isServer() then ModData.transmit("JB_AmbientNature") end
end

function JB_AmbientNature.setMeltingHours(b)
    local md = getMD()
    md.meltingHours = b
    ModData.add("JB_AmbientNature", md)
    if isServer() then ModData.transmit("JB_AmbientNature") end
end

Events.OnInitGlobalModData.Add(function()
    local gmd        = getMD()
    gmd.Frost        = gmd.Frost or nil
    gmd.frostCounter = gmd.frostCounter or 0
    gmd.meltingHours = gmd.meltingHours or 0
    ModData.add("JB_AmbientNature", gmd)
end)

local function updateFrost()
    local cm            = getClimateManager()
    local temp          = cm:getTemperature()
    local wind          = cm:getWindspeedKph()
    local season        = cm:getSeasonId()
    local gmd           = getMD()

    local frostTemp = (wind >= 19 and 2) or (wind > 6 and -2) or 0

    if temp < frostTemp then
        gmd.frostCounter = gmd.frostCounter + 1
        if gmd.frostCounter >= hoursUntilFrost and not gmd.Frost then
            gmd.Frost = true
            gmd.meltingHours = 0
        end
        if gmd.Frost and gmd.meltingHours > 0 then
            gmd.meltingHours = math.max(0, gmd.meltingHours - 2)
        end
    else
        gmd.frostCounter = 0
        if gmd.Frost then
            gmd.meltingHours = gmd.meltingHours + 1
        end
    end

    if gmd.Frost and gmd.meltingHours >= hoursUntilMelt and (season >= 1 and season <= 4) then
        gmd.Frost = nil
        gmd.frostCounter, gmd.meltingHours = 0, 0
    end

    ModData.add("JB_AmbientNature", gmd)
    if isServer() then
        ModData.transmit("JB_AmbientNature")
    end
end

if not isClient() then
    Events.EveryHours.Add(updateFrost)
end

if isClient() then
    Events.OnInitGlobalModData.Add(function()
        ModData.request("JB_AmbientNature")
    end)

    Events.OnReceiveGlobalModData.Add(function(key, data)
        if key == "JB_AmbientNature" then
            JB_AmbientNature = data
        end
    end)
end

return JB_AmbientNature
