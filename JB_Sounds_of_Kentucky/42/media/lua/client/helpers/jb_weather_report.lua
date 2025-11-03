JB_AmbientNature = JB_AmbientNature or {}

function JB_AmbientNature.getWeather()
    local cm = getClimateManager()
    local weather = {
        raining = false,
        rainIntensity = 0,
        thunderstorm = false,
        snowing = false,
        snowIntensity = 0,
        humidity = 0,
        windy = 0,
        foggy = false,
    }

    if cm:isRaining() then
        weather.raining = true
        weather.rainIntensity = cm:getRainIntensity()
    end

    if cm:getPrecipitationIsSnow() then
        weather.snowing = true
        weather.snowIntensity = cm:getSnowIntensity()
    end

    weather.thunderstorm = cm:getIsThunderStorming()
    weather.humidity = cm:getHumidity()
    weather.windy = cm:getWindspeedKph() < 25
    weather.foggy = cm:getFogIntensity() < 0.5

    return weather

end

return JB_AmbientNature