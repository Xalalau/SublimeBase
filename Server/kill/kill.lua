-- Block kills/Unkills for 1.3 second
local function SetCooldown(curChar)
    local player = curChar:GetPlayer()

    player:SetValue("LL_cooldown", true)

    Timer:Simple(1.3, function()
        player:SetValue("LL_cooldown", false)
    end)
end

-- Unkill player
local function Unkill(player)  
    if not player:GetValue("LL_cooldown") then
        Package:Call("Sandbox", "SpawnPlayer", { player, nil, nil, true })
        Events:CallRemote("LL_SetSandboxChar", player, {})
    end
end

-- Kill player
local function Kill(player)
    -- Get the current char 
    local killedChar = player:GetControlledCharacter()

    -- Check if the current char is dead or if we are cooling down
    if killedChar:GetHealth() <= 0 or player:GetValue("LL_cooldown") then return end

    -- Reset kill cooldown and our current char table entry
    SetCooldown(killedChar)

    -- Kill the current char
    killedChar:SetHealth(0)

    -- Check if the player is still dead after 4.7 seconds (Sandbox uses 5s), respawn him and delete the killed char
    Timer:Simple(4.8, function()
        local curChar = player:GetControlledCharacter()

        if curChar == killedChar then
            killedChar:Respawn()
        else
            if curChar:GetHealth() <= 0 then
                Unkill(player)
            end

            killedChar:Destroy()            
        end
    end)
end

-- Hook kill
Events:Subscribe("LL_Unkill", Unkill)

-- Hook Unkill
Events:Subscribe("LL_Kill", Kill)

-- Deal with normal deaths
Character:Subscribe("Death", SetCooldown)
