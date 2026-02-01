-- Delta Universal Executor
-- Works on most Roblox games
-- Auto-detects execution environment

local Delta = {
    Version = "5.0",
    Creator = "Delta Team",
    Supported = {
        "Synapse X",
        "ScriptWare", 
        "KRNL",
        "Fluxus",
        "Oxygen U",
        "Comet",
        "Electron",
        "Coco Z",
        "JJSploit",
        "Trigon"
    }
}

-- Universal Execution Function
function Delta.Execute(script)
    local success, result = pcall(function()
        -- Try multiple execution methods
        local methods = {
            function() loadstring(script)() end,
            function() assert(loadstring(script))() end,
            function() getfenv().loadstring(script)() end,
            function() getgenv().loadstring(script)() end,
            function() _G.loadstring(script)() end,
            function() shared.loadstring(script)() end
        }
        
        for i, method in ipairs(methods) do
            local success, err = pcall(method)
            if success then
                return "Executed via method " .. i
            end
        end
        return "All methods failed"
    end)
    
    return success, result
end

-- Universal Hook Function
function Delta.HookFunction(funcName, newFunc)
    if not _G[funcName] then
        _G[funcName] = newFunc
        return true
    end
    
    -- Try to hook
    local oldFunc = _G[funcName]
    _G[funcName] = function(...)
        return newFunc(oldFunc, ...)
    end
    
    return true
end

-- Universal Get Scripts
function Delta.GetScripts()
    local scripts = {}
    
    -- Get from workspace
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") or obj:IsA("LocalScript") then
            table.insert(scripts, {
                Name = obj.Name,
                Source = obj.Source,
                Path = obj:GetFullName()
            })
        end
    end
    
    return scripts
end

-- Universal Remote Spoofer
function Delta.SpoofRemote(remoteName, returnValue)
    local remotes = {}
    
    -- Find all remotes
    for _, obj in pairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and 
           (string.find(obj.Name:lower(), remoteName:lower()) or remoteName == "") then
            table.insert(remotes, obj)
        end
    end
    
    -- Hook them
    for _, remote in ipairs(remotes) do
        if remote:IsA("RemoteEvent") then
            local oldFire = remote.FireServer
            remote.FireServer = function(self, ...)
                print("[Delta] Intercepted RemoteEvent:", remote.Name)
                return returnValue
            end
        elseif remote:IsA("RemoteFunction") then
            local oldInvoke = remote.InvokeServer
            remote.InvokeServer = function(self, ...)
                print("[Delta] Intercepted RemoteFunction:", remote.Name)
                return returnValue
            end
        end
    end
end

-- Universal Teleport
function Delta.Teleport(player, position)
    if typeof(position) == "Vector3" then
        player.Character:SetPrimaryPartCFrame(CFrame.new(position))
    elseif typeof(position) == "CFrame" then
        player.Character:SetPrimaryPartCFrame(position)
    end
end

-- Universal Speed Hack
function Delta.SpeedHack(speed)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.WalkSpeed = speed
end

-- Universal Jump Hack
function Delta.JumpHack(power)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.JumpPower = power
end

-- Universal God Mode
function Delta.GodMode(enabled)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

-- Universal ESP
function Delta.ESP(enabled, color)
    local players = game.Players:GetPlayers()
    
    for _, player in pairs(players) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.FillColor = color or Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = color or Color3.fromRGB(255, 0, 0)
                highlight.Enabled = enabled
            end
        end
    end
end

-- Universal Fly
function Delta.Fly(enabled, speed)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if enabled then
        -- Fly script
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.P = 1000
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then
                bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.LookVector * speed
            elseif input.KeyCode == Enum.KeyCode.S then
                bodyVelocity.Velocity = -character.HumanoidRootPart.CFrame.LookVector * speed
            elseif input.KeyCode == Enum.KeyCode.A then
                bodyVelocity.Velocity = -character.HumanoidRootPart.CFrame.RightVector * speed
            elseif input.KeyCode == Enum.KeyCode.D then
                bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.RightVector * speed
            elseif input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = Vector3.new(0, speed, 0)
            end
        end)
    else
        -- Remove fly
        for _, obj in pairs(character:GetDescendants()) do
            if obj:IsA("BodyVelocity") then
                obj:Destroy()
            end
        end
  end
end
  
