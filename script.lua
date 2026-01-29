--[[
    OVERNIGHT HUB v4.0 - FIXED FOR DELTA X
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "OVERNIGHT HUB",
    SubTitle = "v4.0",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- --- TẠO NÚT NỔI (FLOATING BUTTON) ---
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("ImageButton", ScreenGui)
local UICorner = Instance.new("UICorner", ToggleButton)

ToggleButton.Name = "OvernightToggle"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 120, 0) -- Màu cam giống ảnh
ToggleButton.Image = "rbxassetid://6031280359"
ToggleButton.Draggable = true
UICorner.CornerRadius = UDim.new(0, 15)

ToggleButton.MouseButton1Click:Connect(function()
    Window:Toggle() -- Đóng mở Menu
end)

-- --- CÁC TAB CHỨC NĂNG ---
local Tabs = {
    Combat = Window:AddTab({ Title = "Chiến Đấu", Icon = "swords" }),
    Farm = Window:AddTab({ Title = "Tự Động", Icon = "workflow" }),
    ESP = Window:AddTab({ Title = "Hiển Thị", Icon = "eye" })
}

-- --- CHIẾN ĐẤU: REACH ---
_G.ReachDistance = 15
Tabs.Combat:AddSlider("ReachSlider", {
    Title = "Phạm Vi Đánh (Reach)",
    Default = 15, Min = 5, Max = 50, Rounding = 1,
    Callback = function(Value) _G.ReachDistance = Value end
})

Tabs.Combat:AddToggle("ReachToggle", {Title = "Bật Reach", Default = false}):OnChanged(function(Value)
    _G.EnableReach = Value
    task.spawn(function()
        while _G.EnableReach do
            pcall(function()
                local weapon = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if weapon then
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v ~= game.Players.LocalPlayer.Character then
                            local dist = (v.PrimaryPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if dist <= _G.ReachDistance then
                                firetouchinterest(v.PrimaryPart, weapon.Handle, 0)
                                firetouchinterest(v.PrimaryPart, weapon.Handle, 1)
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- --- TỰ ĐỘNG: FOOD & ORE ---
Tabs.Farm:AddToggle("AutoFood", {Title = "Auto Lút Đồ Ăn", Default = false}):OnChanged(function(Value)
    _G.AutoFood = Value
    task.spawn(function()
        while _G.AutoFood do
            pcall(function()
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:lower():find("food") or v.Name:lower():find("apple") then
                        v:PivotTo(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- --- ANTI-AFK ---
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
end)

Fluent:Notify({ Title = "Overnight Hub", Content = "Script đã sẵn sàng!", Duration = 5 })
