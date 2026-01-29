--[[
    24H OVERNIGHT HUB - CUSTOM EDITION
    Cấu trúc: Floating Button + Multi-Tab Menu
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7Lib/7Lib/main/Gui.lua"))()
local Window = Library:CreateWindow("OVERNIGHT HUB", "v3.0", 10044538000)

-- --- TẠO NÚT NỔI (FLOATING BUTTON) ---
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 120, 0) -- Màu cam nổi bật
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Image = "rbxassetid://6031280359"
ToggleButton.Active = true
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    local target = game:GetService("CoreGui"):FindFirstChild("7LibGui")
    if target then
        target.Enabled = not target.Enabled
    end
end)

-- --- CÁC TAB CHỨC NĂNG ---
local TabCombat = Window:CreateTab("Chiến Đấu")
local TabAuto = Window:CreateTab("Tự Động")
local TabVisuals = Window:CreateTab("Hiển Thị")

-- --- 1. CHIẾN ĐẤU (REACH) ---
_G.ReachDistance = 15
TabCombat:CreateSlider("Phạm Vi Đánh (Reach)", 5, 50, function(v) _G.ReachDistance = v end)

TabCombat:CreateToggle("Bật Reach", function(state)
    _G.EnableReach = state
    task.spawn(function()
        while _G.EnableReach do
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local weapon = char:FindFirstChildOfClass("Tool")
                if weapon then
                    for _, v in pairs(game.Workspace:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v ~= char then
                            local dist = (v.PrimaryPart.Position - char.HumanoidRootPart.Position).Magnitude
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

-- --- 2. TỰ ĐỘNG (FOOD & ORE) ---
TabAuto:CreateToggle("Auto Lút Đồ Ăn", function(state)
    _G.AutoFood = state
    task.spawn(function()
        while _G.AutoFood do
            pcall(function()
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:lower():find("food") or v.Name:lower():find("apple") or v.Name:lower():find("meat") then
                        v:PivotTo(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

TabAuto:CreateToggle("Auto Hút Quặng/Drops", function(state)
    _G.AutoMine = state
    task.spawn(function()
        while _G.AutoMine do
            pcall(function()
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:lower():find("ore") or v.Name:lower():find("drop") or v.Name:lower():find("gem") then
                        v:PivotTo(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- --- 3. ESP (HIỂN THỊ) ---
local function ApplyESP(part, text, color)
    if part:FindFirstChild("Tag") then return end
    local bg = Instance.new("BillboardGui", part)
    bg.Name = "Tag"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 100, 0, 40)
    local l = Instance.new("TextLabel", bg)
    l.Text = text; l.TextColor3 = color; l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,1,0)
    l.Font = Enum.Font.SourceSansBold; l.TextSize = 14
end

TabVisuals:CreateToggle("ESP Item Hiếm", function(state)
    _G.ESPRare = state
    task.spawn(function()
        while _G.ESPRare do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Diamond") or v.Name:find("Gold") or v.Name:find("Crystal") then
                    ApplyESP(v, "💎 HIẾM", Color3.fromRGB(0, 255, 255))
                end
            end
            task.wait(3)
        end
    end)
end)

TabVisuals:CreateToggle("ESP Quái", function(state)
    _G.ESPMobs = state
    task.spawn(function()
        while _G.ESPMobs do
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Name ~= game.Players.LocalPlayer.Name then
                    local hrp = v:FindFirstChild("HumanoidRootPart")
                    if hrp then ApplyESP(hrp, "👹 QUÁI", Color3.fromRGB(255, 0, 0)) end
                end
            end
            task.wait(3)
        end
    end)
end)

-- --- ANTI-AFK (LUÔN CHẠY) ---
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
end)

print("--- Overnight Hub v3.0 Loaded Successfully ---")
