JB_AmbientNature = JB_AmbientNature or {}

local randy = newrandom()

local GRASS_PREFIXES = {
    { "e_newgrass_",           #"e_newgrass_" },
    { "blends_grassoverlays_", #"blends_grassoverlays_" },
    { "d_plants_",             #"d_plants_" },
    { "d_generic_1_",          #"d_generic_1_" },
    { "d_floorleaves_",        #"d_floorleaves_" },
}

local function JB_hasGrassLike(sq)
    if not sq then return false end
    local objects = sq:getObjects()
    for i = 0, objects:size() - 1 do
        local sprite = objects:get(i):getSprite()
        if sprite then
            local name = sprite:getName()
            if name then
                for j = 1, #GRASS_PREFIXES do
                    local prefix, len = GRASS_PREFIXES[j][1], GRASS_PREFIXES[j][2]
                    if name:sub(1, len) == prefix then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- get dat randy square
function JB_AmbientNature.getRandomSquare()
    local cell = getCell()
    if not cell then return nil end

    local minX, maxX = cell:getMinX(), cell:getMaxX()
    local minY, maxY = cell:getMinY(), cell:getMaxY()

    for tries = 1, 10 do
        local x = randy:random(minX, maxX)
        local y = randy:random(minY, maxY)
        local z = 0
        local sq = cell:getGridSquare(x, y, z)
        if sq then return sq end
    end
    return nil
end

-- classify dat square
function JB_AmbientNature.classifySquare(sq)
    if not sq then
        return nil
    end

    local flags = {
        onScreen  = sq:IsOnScreen(),
        tree      = sq:HasTree() or false,
        bush      = sq:hasBush() or false,
        grass     = JB_hasGrassLike(sq),
        water     = false,
        shoreline = false,
        outside   = sq:isOutside() or false,
        zonename  = false,
    }

    local water = sq:hasWater()
    if water then
        flags.water = true
        local waterObj = sq:getWater()
        if waterObj:isActualShore() then
            flags.shoreline = true
        end
    end

    flags.zonename = sq:getZoneType() or "Unknown"

    return flags
end

return JB_AmbientNature