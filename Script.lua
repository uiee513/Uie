local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "OVERNIGHT HUB",
    SubTitle = "v5.0 - FIX ALL",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460), Theme = "Dark"
})

-- --- FIX LỖI MENU (NÚT NỔI CHUẨN) ---
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.5, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
ToggleButton.Image = "rbxassetid://6031280359"
ToggleButton.Draggable = true -- Có thể kéo di chuyển
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

ToggleButton.MouseButton1Click:Connect(function()
    Window:Toggle() -- Nhấn để đóng/mở menu
end)

local Tabs = {
    Main = Window:AddTab({ Title = "Chiến Đấu", Icon = "swords" }),
    Farm = Window:AddTab({ Title = "Tự Động", Icon = "workflow" }),
    Misc = Window:AddTab({ Title = "Tiện Ích", Icon = "settings" })
}

-- --- 1. TĂNG PHẠM VI TẤN CÔNG (REACH) ---
_G.ReachSize = 15
Tabs.Main:AddSlider("Reach", {Title = "Phạm Vi Tấn Công", Default = 15, Min = 5, Max = 50, Rounding = 1, Callback = function(v) _G.ReachSize = v end})

task.spawn(function()
    while task.wait(0.5) do
        if _G.EnableReach then
            pcall(function()
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(_G.ReachSize, _G.ReachSize, _G.ReachSize)
                    tool.Handle.CanCollide = false
                end
            end)
        end
    end
end)
Tabs.Main:AddToggle("ReachT", {Title = "Bật Reach", Default = false, Callback = function(v) _G.EnableReach = v end})

-- --- 2. FIX AUTO LÚT ĐỒ ĂN & VẬT PHẨM ---
Tabs.Farm:AddToggle("AutoLoot", {Title = "Auto Hút Mọi Vật Phẩm", Default = false, Callback = function(v)
    _G.Loot = v
    task.spawn(function()
        while _G.Loot do
            for _, item in pairs(game.Workspace:GetChildren()) do
                if item:IsA("BasePart") and (item.Name:lower():find("food") or item.Name:lower():find("apple") or item:FindFirstChild("TouchInterest")) then
                    item.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
            task.wait(0.3)
        end
    end)
end})

-- --- 3. CHỨC NĂNG BAY (FLY) ---
Tabs.Misc:AddToggle("Fly", {Title = "Bật Chế Độ Bay", Default = false, Callback = function(v)
    _G.Flying = v
    local lp = game.Players.LocalPlayer
    local mouse = lp:GetMouse()
    if v then
        task.spawn(function()
            local bg = Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
            local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
            bg.maxTorque = Vector3.new(4e5, 4e5, 4e5)
            bg.cframe = lp.Character.HumanoidRootPart.CFrame
            bv.maxForce = Vector3.new(4e5, 4e5, 4e5)
            bv.velocity = Vector3.new(0, 0.1, 0)
            while _G.Flying do
                lp.Character.Humanoid.PlatformStand = true
                bv.velocity = mouse.Hit.lookVector * 50
                bg.cframe = CFrame.new(lp.Character.HumanoidRootPart.Position, mouse.Hit.p)
                task.wait()
            end
            bg:Destroy(); bv:Destroy()
            lp.Character.Humanoid.PlatformStand = false
        end)
    end
end})
