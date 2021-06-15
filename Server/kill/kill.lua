-- Don't let the player kill himself too fast
-- { [Player] = bool }
local cooldown = {}

-- I'm using this table to quickly check new playermodels and thus avoid duplicates
-- { [Player] = Character }
local possessions = {} 

-- Block kills/Unkills for 1 second
local function SetCooldown(player)
    cooldown[player] = true

    Timer:SetTimeout(1000, function(player)
        cooldown[player] = false

        return false
    end, { player })
end

-- Unkill player
local function Unkill(player)    
    if not cooldown[player] and player:GetControlledCharacter():GetHealth() <= 0 then
        local newPossession = Character(Vector(-100.000, 3030.000, 409.000))

        possessions[player] = newPossession
        player:Possess(newPossession)
    end
end

-- Kill player
local function Kill(player)
    -- Get the current possession 
    local curPossession = player:GetControlledCharacter()

    -- Check if the current possession is dead or if we are cooling down
    if curPossession:GetHealth() <= 0 or cooldown[player] then return end

    -- Reset kill cooldown and our current possession table entry
    SetCooldown(player)

    -- Kill the current possession
    curPossession:SetHealth(0)

    -- Check if the player is still dead after 9 seconds, respawn him and delete the killed possession
    Timer:SetTimeout(9000, function(player, lastPossession)
        if not possessions[player] and lastPossession or -- Note: this covers the first spawn
           possessions[player] == lastPossession then 
            Unkill(player)
        end

        -- o tamanho limitado dos erros tb tá me atrapalhando
        if lastPossession:IsValid() then
            lastPossession:Destroy() 
        end

        return false
    end, { player, curPossession })

    Server:BroadcastChatMessage("<red>" .. player:GetName() .. "</> committed suicide")
end

-- Hook some custom events to kill/Unkill
Events:Subscribe("LL_Unkill", function(player)
    Unkill(player)
end)

Events:Subscribe("LL_Kill", function(player)
    Kill(player)
end)

-- Deal with normal deaths
Character:Subscribe("Death", function(curPossession)
    local player = curPossession:GetPlayer()

    if not player then return end

    SetCooldown(player)
end)

-- Register the first possession
Character:Subscribe("Spawn", function(curPossession)
    if not curPossession:GetPlayer() then return end

    possessions[player] = curPossession
end)
