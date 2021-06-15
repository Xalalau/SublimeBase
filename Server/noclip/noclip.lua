-- Set Noclip
Events:Subscribe("LL_SetNoclip", function(player, state)
    local possession = player:GetControlledCharacter()

    if not possession then return end

    possession:SetFlyingMode(state)
    possession:SetValue("LL_flyingMode", state, true)

    if not state and not possession:GetValue("LL_falling") then
        possession:SetValue("LL_falling", true)
        possession:SetFallDamageTaken(0)
    end
end)

Character:Subscribe("FallingModeChanged", function(possession, _, new_state)
    if new_state == 0 and possession:GetValue("LL_falling") then
        local my_particle = Particle(
            possession:GetLocation() - Vector(0, 0, 100),
            Rotator(0, 0, 0),
            "NanosWorld::P_Explosion",
            true,
            true
        )
        possession:SetValue("LL_falling", false)
        possession:SetFallDamageTaken(10)
    end
end)