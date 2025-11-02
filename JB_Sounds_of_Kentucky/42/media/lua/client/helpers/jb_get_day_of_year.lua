JB_AmbientNature = JB_AmbientNature or {}

local monthLength   = {
    [0]  = 31, -- Jan
    [1]  = 28, -- Feb
    [2]  = 31, -- Mar
    [3]  = 30, -- Apr
    [4]  = 31, -- May
    [5]  = 30, -- Jun
    [6]  = 31, -- Jul
    [7]  = 31, -- Aug
    [8]  = 30, -- Sep
    [9]  = 31, -- Oct
    [10] = 30, -- Nov
    [11] = 31, -- Dec
}

function JB_AmbientNature.getDayOfYear()
    local gt = getGameTime()
    local month = gt:getMonth()
    local isLeapYear = gt:getCalender():isLeapYear(gt:getYear())
    local day = gt:getDay() + 1

    for i = 0, month - 1 do
        day = day + monthLength[i]
        if isLeapYear and i == 1 then
            day = day + 1 -- so stupid
        end
    end
    return day
end