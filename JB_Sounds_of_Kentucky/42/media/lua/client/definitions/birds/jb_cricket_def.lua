JB_AmbientNature = JB_AmbientNature or {}

JB_AmbientNature.InsectDef = {
    Cricket  = {
        ActiveMonths  = { 4, 5, 6, 7, 8 },
        PeakMonths    = { 5, 6, 7 },
        OffPeakMonths = { 4, 8 },

        IdealTemp       = 24,
        ActiveTempRange = { Low = 13, High = nil },

        SpawnZone = {
            Forest         = 10,
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
            
            "cricket_1",
            "cricket_2",
        },
    },
}

return JB_AmbientNature
