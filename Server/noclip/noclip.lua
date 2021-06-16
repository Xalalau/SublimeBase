-- Don't process falling damage when the player first hits the ground after exiting noclip
local function SetLanding(possession)
    if possession:GetValue("LL_Noclip_Land") then return end

    possession:SetValue("LL_Noclip_Land", true)
    possession:SetFallDamageTaken(0)

    possession:Subscribe("FallingModeChanged", function(possession, _, new_state)
        if new_state == 0 then
            local my_particle = Particle(
                possession:GetLocation() - Vector(0, 0, 100),
                Rotator(0, 0, 0),
                "NanosWorld::P_Explosion",
                true,
                true
            )

            possession:SetValue("LL_Noclip_Land", false)
            possession:SetFallDamageTaken(10)
            possession:Unsubscribe("FallingModeChanged")
        end
    end)
end

-- Set acceleration
Events:Subscribe("LL_SetNoclipAcceleration", function(player, acceleration)
    local possession = player:GetControlledCharacter()

    possession:SetAccelerationSettings(768, 512, 768, 128, 256, 256, acceleration)
end)

-- Set Noclip
Events:Subscribe("LL_SetNoclip", function(player)
    local possession = player:GetControlledCharacter()

    if not possession then return end

    -- Change state
    local state = not possession:GetValue("LL_flyingMode")

    possession:SetFlyingMode(state)
    possession:SetValue("LL_flyingMode", state, true)

    -- Set landing
    SetLanding(possession)
end)
