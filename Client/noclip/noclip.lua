-- Set Nonlip
Client:Subscribe("KeyPress", function(key_name)
    local possession = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if not possession then return end

    if key_name == "C" then
        Events:CallRemote("LL_SetNoclip", {})
    end
end)
