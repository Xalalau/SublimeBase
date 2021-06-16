-- Kill the player using the binded key or unkill him using almost any key/mouse input

local function UnkillCheck(curChar)
    if curChar and curChar:GetHealth() <= 0 then
        Events:CallRemote("LL_Unkill", {})
    end
end

Client:Subscribe("KeyPress", function(key_name)
    local curChar = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if not curChar then return end

    if key_name ~= "P" then
        UnkillCheck(curChar)
    end

    if key_name == "P" and curChar:GetHealth() >= 0 then
        Events:CallRemote("LL_Kill", {})
    end
end)

Client:Subscribe("MouseDown", function()
    UnkillCheck(NanosWorld:GetLocalPlayer():GetControlledCharacter())
end)

-- Add console command
Timer:SetTimeout(100, function()
    ConCommand:Add("kill", function() Events:CallRemote("LL_Kill", {}) end)
    return false
end)