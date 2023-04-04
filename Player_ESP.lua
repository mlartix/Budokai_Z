pcall(function()
    getgenv().Connections.Stepped:Disconnect()
    getgenv().Connections.Stepped = nil
end)

local RefreshRate = 14
getgenv().ESPToggle = true
getgenv().Connections = {
    RenderStepped = nil,
    Stepped = nil,
    PlayerAdded = nil,
    PlayerRemoved = nil,
}

function WTS(part)
    local screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
    return Vector2.new(screen.x, screen.y), screen.z
end
    
function ESP(player)
    local LastRefresh = 0
  --  "["..math.floor(player.Character.Humanoid.Health + .05)"/"math.floor(player.Character.Humanoid.MaxHealth + .05))"]"
    local name = Drawing.new("Text")
    name.Text = player.Name
    name.Color = Color3.fromHSV(tick() * 24 % 255/255, 1, 1)
    --name.Position = WTS(player.Character.HumanoidRootPart)
    name.Size = 20.0
    name.Outline = true
    name.Center = true
    name.Visible = true
    
    getgenv().Connections.Stepped = game:GetService("RunService").Stepped:Connect(function()
        if (tick() - LastRefresh) > (RefreshRate / 1000) then
            LastRefresh = tick();
            pcall(function()
                local destroyed = player.Character.HumanoidRootPart:IsDescendantOf(workspace)
                if not destroyed and name ~= nil then
                    name:Remove()
                end
                if player.Character.HumanoidRootPart ~= nil then
                    name.Position = WTS(player.Character.HumanoidRootPart)
                end
                local _, screen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if screen and getgenv().ESPToggle then
 
                    name.Text = string.format("%s [%d/%d]\n%d [%d]", player.Name, math.floor(player.Character.Humanoid.Health + .05), math.floor(player.Character.Humanoid.MaxHealth + .05), select(2, WTS(player.Character.HumanoidRootPart)), player.Character.Core.PowerLevel.Value)
                    name.Position = WTS(player.Character.HumanoidRootPart)
                    name.Visible = true
                    name.Color = Color3.fromHSV(tick() * 24 % 255/255, 1, 1)
                else
                    name.Visible = false
                end
            end)
        end
    end)
end

for _,v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        ESP(v)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        ESP(player)
    end)
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    --if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[string.upper(tostring(_G.Keybind))] then
        if getgenv().ESPToggle then
            getgenv().ESPToggle = false
        else
            getgenv().ESPToggle = true
        end
    end
end)
