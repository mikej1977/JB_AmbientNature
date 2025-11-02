require("jb_square_helpers")
JB_AmbientNature = JB_AmbientNature or {}

function JB_AmbientNature.printFlags(sq, flags)
    if not sq then
        print("No square found(probably inside)")
        return
    end

    if not flags then
        print("Square has no flags wtf")
        return
    end

    local x, y, z = sq:getX(), sq:getY(), sq:getZ()
    print(string.format("Square classification at (%d, %d, %d):", x, y, z))

    for k, v in pairs(flags) do
        if type(v) == "boolean" then
            print(string.format("  %s = %s", k, v and "true" or "false"))
        else
            print(string.format("  %s = %s", k, tostring(v)))
        end
    end
end

local function debugSquareFlags(key)
    if key == Keyboard.KEY_0 then
        local sq = JB_AmbientNature.getRandomSquare()
        if not sq then
            print("No square under mouse.")
            return
        end

        local flags = JB_AmbientNature.classifySquare(sq)
        JB_AmbientNature.printFlags(sq, flags)
    end
end

Events.OnKeyPressed.Add(debugSquareFlags)

return JB_AmbientNature