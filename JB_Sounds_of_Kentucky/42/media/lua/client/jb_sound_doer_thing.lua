require("jb_square_helpers")
require("jb_weather_report")
require("jb_check_heli")
JB_AmbientNature = JB_AmbientNature or {}
local randy = newrandom()

---
-- Checks all game conditions to see if a specific bird can make a sound.
-- @param birdName (string) The name of the bird (e.g., "NorthernCardinal")
-- @return (string, string) (soundName, soundType) or (nil, reason)
---
function JB_AmbientNature.getAmbientBirdSound(birdName)
    local birdDef = JB_AmbientNature.BirdDef and JB_AmbientNature.BirdDef[birdName]
    if not birdDef then
        return nil, nil, "Bird definition not found: " .. (birdName or "nil")
    end

    -- 1. Check global "silence" conditions
    if JB_AmbientNature.isHeliEvent() then
        return nil, nil, "Helicopter event is active"
    end

    local weather = JB_AmbientNature.getWeather()
    if weather.thunderstorm then
        return nil, nil, "Too stormy for birds"
    end
    if weather.raining and weather.rainIntensity > 0.5 then
        return nil, nil, "Raining too hard"
    end

    -- 2. Check location (square)
    local sq = JB_AmbientNature.getRandomSquare()
    if not sq then
        return nil, nil, "No valid square found"
    end

    local sqFlags = JB_AmbientNature.classifySquare(sq)
    if not sqFlags or not sqFlags.outside then
        return nil, nil, "Not outside"
    end

    -- 3. Check bird's preferred zone
    local zone = sqFlags.zonename
    local prevalence = birdDef.SpawnZone and birdDef.SpawnZone[zone]
    if not prevalence or prevalence <= 0 then
        return nil, nil, "Bird does not spawn in zone: " .. zone
    end

    -- 4. Check time (month)
    local gt = getGameTime()
    local currentMonth = gt:getMonth() -- 0 = Jan, 11 = Dec

    local isActiveMonth = false
    for _, month in ipairs(birdDef.ActiveMonths) do
        if month == currentMonth then
            isActiveMonth = true
            break
        end
    end

    if not isActiveMonth then
        return nil, nil, "Bird not active in month: " .. currentMonth
    end

    -- 5. Determine sound type (Mating vs. Song)
    local soundType = "Song" -- Default to 'Song'
    local isMatingMonth = false
    for _, month in ipairs(birdDef.MatingMonths) do
        if month == currentMonth then
            isMatingMonth = true
            break
        end
    end

    -- If it's a mating month, let's give it a chance to be a mating call
    if isMatingMonth and randy:random(100) < 40 then -- 40% chance for a mating call
        soundType = "Mating"
    end

    -- 6. Select a random sound from the chosen category
    local soundOptions = birdDef.Sounds[soundType]
    if not soundOptions or #soundOptions == 0 then
        return nil, nil, "No sounds found for type " .. soundType
    end

    local soundToPlay = soundOptions[randy:random(1, #soundOptions)]

    return sq, soundToPlay, soundType
end


local function debugBirdSound(key)
    if key == Keyboard.KEY_9 then
        print("--- Checking for bird sound ---")
        -- We only have the northern cardinal right now
        local sq, soundName, reasonOrType = JB_AmbientNature.getAmbientBirdSound("NorthernCardinal")

        if soundName then
            print(string.format("OK: Playing sound '%s' (Type: %s)", soundName, reasonOrType))
        else
            print(string.format("NO: %s", reasonOrType))
        end
        print("-------------------------------")
        if sq and soundName then
            sq:playSound(soundName)
        end
    end
end

Events.OnKeyPressed.Add(debugBirdSound)

Events.OnTick.Add(function(tick)
    if tick % 60 == 0 then
        if JB_AmbientNature.SuppressSound then return end
        local sq, soundName, reasonOrType = JB_AmbientNature.getAmbientBirdSound("NorthernCardinal")

        if sq and soundName then
            local player = getPlayer()
            local sx, sy = sq:getX(), sq:getY()
            local px, py = player:getX(), player:getY()

            local dx, dy = sx - px, sy - py
            local dist = math.sqrt(dx * dx + dy * dy)

            local maxDist = 10.0 -- furtehst "dist"
            local distFactor = 1 - math.min(dist / maxDist, 1)
            if distFactor > 0 then
                if soundName then
                    print(string.format("OK: Playing sound '%s' (Type: %s)", soundName, reasonOrType))
                else
                    print(string.format("NO: %s", reasonOrType))
                end

                local emitter = getWorld():getFreeEmitter(sx, sy, sq:getZ())
                local sound = emitter:playSound(soundName, sq)
                print("distFactor Volume ", distFactor)
                emitter:setVolume(sound, distFactor)
                emitter:setPitch(sound, ZombRandFloat(0.9, 1.1))
                print("-------------------------------")
            end
            
        end
    end

end)

return JB_AmbientNature