local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")

-- --- TẠO GUI CHÍNH ---
local gui = Instance.new("ScreenGui")
gui.Name = "OvernightHubV9"
gui.ResetOnSpawn = false
gui.Parent = pgui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 250) -- Tăng kích thước để đủ chỗ cho nút
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 0)), -- Màu cam chủ đạo
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 128)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
grad.Rotation = 45
grad.Parent = main

-- --- TIÊU ĐỀ ---
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "OVERNIGHT HUB v9.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

-- --- HÀM TẠO NÚT BẬT/TẮT (TOGGLE) ---
local function CreateButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 300, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.6
    btn.Text = name .. ": TẮT"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = main
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "BẬT" or "TẮT")
        btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
        callback(enabled)
    end)
end

-- --- 1. CHỨC NĂNG REACH (ĐÁNH XA) ---
CreateButton("BẬT REACH (15m)", UDim2.new(0.5, -150, 0, 50), function(val)
    _G.Reach = val
    task.spawn(function()
        while _G.Reach do
            pcall(function()
                local tool = lp.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(15, 15, 15)
                    tool.Handle.CanCollide = false
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- --- 2. AUTO HÚT ĐỒ ĂN & VẬT PHẨM ---
CreateButton("AUTO HÚT VẬT PHẨM", UDim2.new(0.5, -150, 0, 95), function(val)
    _G.Loot = val
    task.spawn(function()
        while _G.Loot do
            for _, item in pairs(game.Workspace:GetChildren()) do
                if item:IsA("BasePart") and (item.Name:lower():find("food") or item:FindFirstChild("TouchInterest")) then
                    item.CFrame = lp.Character.HumanoidRootPart.CFrame
                end
            end
            task.wait(0.3)
        end
    end)
end)

-- --- 3. BAY (FLY) ---
CreateButton("CHẾ ĐỘ BAY", UDim2.new(0.5, -150, 0, 140), function(val)
    _G.Fly = val
    if val then
        local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
        task.spawn(function()
            while _G.Fly do
                bv.Velocity = lp:GetMouse().Hit.lookVector * 50
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- --- HIỆU ỨNG XOAY MÀU (GRADIENT ROTATION) ---
task.spawn(function()
    while true do
        grad.Rotation = grad.Rotation + 2
        task.wait(0.02)
    end
end)

-- --- NÚT ĐÓNG MENU ---
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 0, 0)
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.Parent = main
close.MouseButton1Click:Connect(function() gui:Destroy() end)
            task.wait(0.3)
         end
      end)
   end,
})

-- --- 3. BAY (FLY) ---
TabMisc:CreateToggle({
   Name = "Bật Chế Độ Bay",
   CurrentValue = false,
   Callback = function(v)
      _G.Fly = v
      local lp = game.Players.LocalPlayer
      if v then
         local bv = Instance.new("BodyVelocity", lp.Character.HumanoidRootPart)
         bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
         task.spawn(function()
            while _G.Fly do
               bv.Velocity = lp:GetMouse().Hit.lookVector * 60
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

Rayfield:Notify({Title = "OVERNIGHT HUB", Content = "Đã sửa toàn bộ lỗi!", Duration = 5})
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
