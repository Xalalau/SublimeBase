-- Don't let the player kill himself too fast
-- { [Player] = bool }
local cooldown = {}

-- I'm using this table to quickly check new playermodels and thus avoid duplicates
-- { [Player] = Character }
local chars = {} 

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
        local newChar = Character(Vector(-100.000, 3030.000, 409.000))

        chars[player] = newChar
        player:Possess(newChar)
    end
end

-- Kill player
local function Kill(player)
    -- Get the current char 
    local curChar = player:GetControlledCharacter()

    -- Check if the current char is dead or if we are cooling down
    if curChar:GetHealth() <= 0 or cooldown[player] then return end

    -- Reset kill cooldown and our current char table entry
    SetCooldown(player)

    -- Kill the current char
    curChar:SetHealth(0)

    -- Check if the player is still dead after 6 seconds, respawn him and delete the killed char
    Timer:SetTimeout(6000, function(player, lastChar)
        if not chars[player] and lastChar or -- Note: this covers the first spawn
           chars[player] == lastChar then 
            Unkill(player)
        end

        -- o tamanho limitado dos erros tb tá me atrapalhando
        if lastChar:IsValid() then
            lastChar:Destroy() 
        end

        return false
    end, { player, curChar })

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
Character:Subscribe("Death", function(curChar)
    local player = curChar:GetPlayer()

    if not player then return end

    SetCooldown(player)
end)

-- Register the first char
Character:Subscribe("Spawn", function(curChar)
    Timer:Simple(0.5, function()
        local player = curChar:GetPlayer()

        if not player then return end

        chars[player] = curCharW
    end)
end)
