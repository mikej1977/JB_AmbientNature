JB_AmbientNature = JB_AmbientNature or {}
JB_AmbientNature.SuppressSound = false

local suppressUntil = 0

local suppressAmbientSoundMinutes = {
    MetaAssaultRifle1 = 60,
    MetaDogBark       = 30,
    MetaOwl           = 15,
    MetaPistol1       = 30,
    MetaPistol2       = 30,
    MetaPistol3       = 30,
    MetaScream        = 10,
    MetaShotgun1      = 40,
    MetaWolfHowl      = 30,
}

local function isSuppressed()
    local now = getGameTime():getMinutesStamp()
    return now < suppressUntil
end

Events.OnAmbientSound.Add(function(sound, x, y)
    JB_AmbientNature.SuppressSound = true
    print("Ambient Sound ", sound, " is playing at x:", x, ", y: ", y)
    
    suppressUntil = math.max(suppressUntil, 
                    getGameTime():getMinutesStamp() + 
                    (suppressAmbientSoundMinutes[sound] or 0))

    print("Suppressing nature sounds until ", suppressUntil, " minutes")
end)

Events.EveryOneMinute.Add(function()
    if JB_AmbientNature.SuppressSound and not isSuppressed() then
        JB_AmbientNature.SuppressSound = false
        print("Nature Ambient Suppressing Stopped")
    end
end)

return JB_AmbientNature