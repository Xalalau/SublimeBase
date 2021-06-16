-- Set Noclip
Events:Subscribe("LL_SetNoclip", function(player)
    local char = player:GetControlledCharacter()

    if not char then return end

    -- Start noclip
    local state = not char:GetValue("LL_Noclip")

    char:SetFlyingMode(state)
    char:SetValue("LL_Noclip", state, true)

    -- Change flying behaviour
    if not char:GetValue("LL_Noclip_Init") then
        char:SetValue("LL_Noclip_Init", true)

        -- Set custom flying speed and acceleration
        char:SetAccelerationSettings(768, 512, 768, 128, 256, 256, 3000)
        char:SetSpeedMultiplier(0.9)

        -- Cancel fall damage
        char:SetFallDamageTaken(0)
    
        -- When the player first hits the ground after exiting noclip...
        char:Subscribe("FallingModeChanged", function(char, _, new_state)
            if new_state == 0 then
                -- Emit some particles
                local my_particle = Particle(
                    char:GetLocation() - Vector(0, 0, 100),
                    Rotator(0, 0, 0),
                    "NanosWorld::P_Explosion",
                    true,
                    true
                )
    
                -- Restore default fall damage since the player is already safe
                char:SetFallDamageTaken(10)

                -- Restore speed and acceleration
                char:SetAccelerationSettings(768, 512, 768, 128, 256, 256, 1024)
                char:SetSpeedMultiplier(1)

                -- Remove noclip init
                char:SetValue("LL_Noclip_Init", false)

                -- Remove FallingModeChanged event
                char:Unsubscribe("FallingModeChanged")
            end
        end)
    end
end)

-- Change noclip speed
Events:Subscribe("LL_SetNoclipSpeed", function(player, speed)
    local char = player:GetControlledCharacter()

    if not char then return end

    char:SetSpeedMultiplier(speed)
end)