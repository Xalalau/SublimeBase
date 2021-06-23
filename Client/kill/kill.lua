-- Start kill
local function Kill()
    local curChar = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if curChar and curChar:GetHealth() >= 0 then
        Events:CallRemote("LL_Kill", {})
    end
end

-- Start unkill
local function Unkill()
    local curChar = NanosWorld:GetLocalPlayer():GetControlledCharacter()

    if curChar and curChar:GetHealth() <= 0 then
        Events:CallRemote("LL_Unkill", {})
    end
end

-- Setup unkill events
Client:Subscribe("KeyPress", Unkill)
Client:Subscribe("MouseDown", Unkill)

-- Reconnect unkilled player to Sandbox
Events:Subscribe("LL_SetSandboxChar", function()
    local curChar = NanosWorld:GetLocalPlayer():GetControlledCharacter()
    Package:Call("Sandbox", "UpdateLocalCharacter", { curChar })
end)

-- Add console command
ConCommand:Add("kill", function() Kill() end)