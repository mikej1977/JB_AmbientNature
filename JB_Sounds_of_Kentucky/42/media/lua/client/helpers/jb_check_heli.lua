JB_AmbientNature = JB_AmbientNature or {}

function JB_AmbientNature.isHeliEvent()
    local gt = getGameTime()
    local heliDay = gt:getHelicopterDay()
    local heliStartHour = gt:getHelicopterStartHour()
    local heliStopHour = gt:getHelicopterEndHour()

    local currentDay = gt:getNightsSurvived()
    local currentHour = gt:getTimeOfDay()

    if heliDay == currentDay then
        if currentHour >= heliStartHour and currentHour <= heliStopHour then
            return true
        end
    end
    return false
end

return JB_AmbientNature