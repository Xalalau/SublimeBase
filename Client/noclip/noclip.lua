
-- Set Nonlip

Client:Subscribe("KeyPress", function(key_name)
    local possession = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if not possession then return end

    -- Enable/Disable noclip
    if key_name == "C" then
        Events:CallRemote("LL_SetNoclip", {})
    end

    if not possession:GetValue("LL_flyingMode") then return end

    -- Increase acceleration
    if key_name == "LeftShift" then
        Events:CallRemote("LL_SetNoclipAcceleration", { 4000 })
    end

    -- Decrease acceleration
    if key_name == "LeftAlt" then
        Events:CallRemote("LL_SetNoclipAcceleration", { 300 })
    end
end)

Client:Subscribe("KeyUp", function(key_name)
    local possession = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if not possession then return end
    if not possession:GetValue("LL_flyingMode") then return end

    -- Restore acceleration
    if key_name == "LeftShift" or key_name == "LeftAlt" then
        Events:CallRemote("LL_SetNoclipAcceleration", { 1024 })
    end
end)