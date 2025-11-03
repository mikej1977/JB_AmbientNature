JB_AmbientNature = JB_AmbientNature or {}

JB_AmbientNature.BirdDef = {
    NorthernCardinal  = {
        ActiveMonths  = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }, -- when you can hear them
        PeakMonths    = { 2, 3, 4 },                              -- When they are most active
        OffPeakMonths = { 0, 9, 10, 11 },                         -- not so active
        MatingMonths  = { 2, 4, 5, 6, 7 },                        -- noisy asf

        IdealTemp       = nil,                                    -- more active at this temp
        ActiveTempRange = { Low = nil, High = nil },              -- temps where the batteries work

        SpawnZone = {                                             -- 0 - 10 prevelence in zone
            Forest         = 10,                                  -- prevelence gets buffed by preferred zone, ideal temp, etc
            DeepForest     = 10,
            Farm           = 6,
            FarmLand       = 6,
            TownZone       = 3,
            TrailerPark    = 2,
            Vegitation     = 5,
            PHForest       = 10,
            PRForest       = 10,
            PHMixForest    = 8,
            FarmForest     = 7,
            FarmMixForest  = 6,
            BirchForest    = 6,
            BirchMixForest = 5,
            OrganicForest  = 9,
        },

        PreferredZone = {
            "Forest", "DeepForest", "Farm", "FarmLand",
            "PHForest", "PHMixForest", "FarmForest", "FarmForestMix",
            "BirchForest", "OrganicForest"
        },

        AvoidedZone = {
            nil
        },

        Sounds = {
            Song = {
                "northerncardinal_song_1",
                "northerncardinal_song_2",
                "northerncardinal_song_3",
                "northerncardinal_song_4"
            },
            Mating = { 
                "northerncardinal_mating_1",
                "northerncardinal_mating_2",
                "northerncardinal_mating_3",
             },
            Alarm = { 
                "northerncardinal_alarm_1",
            }
        },
    },
}

return JB_AmbientNature
