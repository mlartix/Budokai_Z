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
    
function ESP(hrp)
    local LastRefresh = 0
  --  "["..math.floor(player.Character.Humanoid.Health + .05)"/"math.floor(player.Character.Humanoid.MaxHealth + .05))"]"
    local name = Drawing.new("Text")
    name.Text = hrp.Parent.Name
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
                local destroyed = not hrp:IsDescendantOf(workspace)
                if destroyed and name ~= nil then
                    name:Remove()
                end
                local _, screen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if screen and getgenv().ESPToggle then
 
                    name.Text = string.format("%s [%d/%d]\n%d [%d]", hrp.Parent.Name, math.floor(hrp.Parent.Humanoid.Health + .05), math.floor(hrp.Parent.Humanoid.MaxHealth + .05), select(2, WTS(hrp)), hrp.Parent.Core.PowerLevel.Value)
                    name.Position = WTS(hrp)
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
    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        ESP(v.Character.HumanoidRootPart)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if player == game.Players.LocalPlayer then return end;
    player.CharacterAdded:Connect(function(v)
        local hrp = v:WaitForChild("HumanoidRootPart")
        ESP(hrp)
    end)
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    --if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[string.upper(tostring(_G.Keybind))] then
        if _G.Keybind then
            getgenv().ESPToggle = false
        else
            getgenv().ESPToggle = true
        end
    end
end)
