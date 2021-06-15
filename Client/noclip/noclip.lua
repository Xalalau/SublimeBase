-- Set Nonlip
Client:Subscribe("KeyPress", function(key_name)
    local possession = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if not possession then return end

    if key_name == "C" then
        if possession:GetValue("LL_flyingMode") then
            Events:CallRemote("LL_SetNoclip", { false })
        else
            Events:CallRemote("LL_SetNoclip", { true })
        end
    end
end)
