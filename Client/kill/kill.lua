-- Kill the player using the binded key or unkill him using almost any key/mouse input

local function UnkillCheck(curPossession)
    if curPossession and curPossession:GetHealth() <= 0 then
        Events:CallRemote("LL_Unkill", {})
    end
end

Client:Subscribe("KeyPress", function(key_name)
    local curPossession = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if not curPossession then return end

    if key_name ~= "P" then
        UnkillCheck(curPossession)
    end

    if key_name == "P" and curPossession:GetHealth() >= 0 then
        Events:CallRemote("LL_Kill", {})
    end
end)

Client:Subscribe("MouseDown", function()
    UnkillCheck(NanosWorld:GetLocalPlayer():GetControlledCharacter())
end)
