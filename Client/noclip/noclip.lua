
-- Set Nonlip

Client.Subscribe("KeyPress", function(key_name)
    local char = Client.GetLocalPlayer():GetControlledCharacter()

    if not char then return end

    -- Set noclip
    if key_name == "N" then
        Events.CallRemote("LL_SetNoclip")
    end

    if not char:GetValue("LL_Noclip") then return end

    -- Increase acceleration
    if key_name == "LeftShift" then
        Events.CallRemote("LL_SetNoclipSpeed",  1.7)
    end

    -- Decrease acceleration
    if key_name == "LeftAlt" then
        Events.CallRemote("LL_SetNoclipSpeed",  0.4)
    end
end)

Client.Subscribe("KeyUp", function(key_name)
    local char = Client.GetLocalPlayer():GetControlledCharacter()

    if not char or not char:GetValue("LL_Noclip") then return end

    -- Restore acceleration
    if key_name == "LeftShift" or key_name == "LeftAlt" then
        Events.CallRemote("LL_SetNoclipSpeed",  0.9)
    end
end)

-- Add console command
ConCommand.Add("noclip", function() Events.CallRemote("LL_SetNoclip") end)