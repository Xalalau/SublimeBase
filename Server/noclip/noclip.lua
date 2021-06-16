-- Don't process falling damage when the player first hits the ground after exiting noclip
local function SetLanding(char)
    if char:GetValue("LL_Noclip_Land") then return end

    char:SetValue("LL_Noclip_Land", true)
    char:SetFallDamageTaken(0)

    char:Subscribe("FallingModeChanged", function(char, _, new_state)
        if new_state == 0 then
            local my_particle = Particle(
                char:GetLocation() - Vector(0, 0, 100),
                Rotator(0, 0, 0),
                "NanosWorld::P_Explosion",
                true,
                true
            )

            char:SetValue("LL_Noclip_Land", false)
            char:SetFallDamageTaken(10)
            char:Unsubscribe("FallingModeChanged")
        end
    end)
end

-- Set acceleration
Events:Subscribe("LL_SetNoclipAcceleration", function(player, acceleration)
    local char = player:GetControlledCharacter()

    char:SetAccelerationSettings(768, 512, 768, 128, 256, 256, acceleration)
end)

-- Set Noclip
Events:Subscribe("LL_SetNoclip", function(player)
    local char = player:GetControlledCharacter()

    if not char then return end

    -- Change state
    local state = not char:GetValue("LL_Noclip")

    char:SetFlyingMode(state)
    char:SetValue("LL_Noclip", state, true)

    -- Set landing
    SetLanding(char)
end)
