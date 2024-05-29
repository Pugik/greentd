-- pugiko: https://steamcommunity.com/id/pepegi7/
-- #============================================#

function _RegisterModifier(Context, Modifiers, Path)
    if not Context.ModifiersList then Context.ModifiersList = {} end

    for modifierName, modifierData in pairs(Modifiers or {}) do
        if Context.ModifiersList[modifierName] then return end

        local modifierMotion, customPath = unpack(modifierData)
        if customPath then 
            LinkLuaModifier(modifierName, customPath, modifierMotion) 
        else
            LinkLuaModifier(modifierName, "addon/modifiers/" .. modifierName .. ".lua", modifierMotion)
        end

        Context.ModifiersList[modifierName] = true
    end
end

if IsClient() then return end

function _RegisterListeners(Context, Listeners)
    if not Context.GameEventListeners then
		Context.GameEventListeners = {}
	end

    for ListenerName, FunctionName in pairs(Listeners or {}) do
        if Context.GameEventListeners[ListenerName] then
            StopListeningToGameEvent(Context.GameEventListeners[ListenerName])
        end
    
        Context.GameEventListeners[ListenerName] = ListenToGameEvent(ListenerName, Dynamic_Wrap(Context, FunctionName), Context)
    end
end

function _DebugDeepPrint(base, table)
    print(base)
	DeepPrint(table)
end

function _DebugParse(Content)
    print("[[-==================-]]")
    for Key, Value in pairs(Content) do
        print("Key: ", Key)
        print("Value: ", Value)
    end
    print("[[-==================-]]")
end

function _split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function _RandomKeyFromTable(t)
    local fTable = {}
    for key, _ in pairs(t) do
        table.insert(fTable, key)
    end
	local key = fTable[RandomInt(1,#fTable)]
    return key
end