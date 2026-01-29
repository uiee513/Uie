--// DEMO HUB - DÙNG CHO ROBLOX STUDIO / MAP TEST
--// UI + Toggle + Chức năng mô phỏng (an toàn)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")

--================ CẤU HÌNH =================
local Settings = {
    Fly = false,
    FlySpeed = 40,

    ESP_NPC = false,
    ESP_Item = false,

    Magnet = false,
    MagnetRange = 15,
}

--================ GUI =================
local gui = Instance.new("ScreenGui", pgui)
gui.Name = "DemoHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 340, 0, 260)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(128,0,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,128,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,20))
}

--================ THANH TRÊN =================
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-20,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Demo Hub - 24 Hours Overnight"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Left

--================ KHU NÚT =================
local body = Instance.new("Frame", main)
body.Size = UDim2.new(1,0,1,-40)
body.Position = UDim2.new(0,0,0,40)
body.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", body)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Center

local function ToggleButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,280,0,32)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text .. ": TẮT"
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.Parent = body
    return btn
end

local flyBtn     = ToggleButton("Bay")
local espNpcBtn  = ToggleButton("ESP NPC")
local espItemBtn = ToggleButton("ESP Vật Phẩm")
local magBtn     = ToggleButton("Hút Vật Phẩm")

--================ TOGGLE LOGIC =================
local function bindToggle(btn, key)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = btn.Text:split(":")[1] .. (Settings[key] and ": BẬT" or ": TẮT")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(60,120,60) or Color3.fromRGB(40,40,40)
    end)
end

bindToggle(flyBtn, "Fly")
bindToggle(espNpcBtn, "ESP_NPC")
bindToggle(espItemBtn, "ESP_Item")
bindToggle(magBtn, "Magnet")

--================ KÉO THẢ =================
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

--================ BAY (DEMO) =================
task.spawn(function()
    local bv
    RunService.RenderStepped:Connect(function()
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if Settings.Fly and hrp then
            if not bv then
                bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            end
            bv.Velocity = hrp.CFrame.LookVector * Settings.FlySpeed
        else
            if bv then bv:Destroy() bv=nil end
        end
    end)
end)

--================ ESP NPC (DEMO) =================
task.spawn(function()
    while task.wait(1) do
        if Settings.ESP_NPC then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= lp.Character then
                    if not v:FindFirstChild("ESP") then
                        local h = Instance.new("Highlight", v)
                        h.Name = "ESP"
                        h.FillColor = Color3.fromRGB(255,0,0)
                    end
                end
            end
        end
    end
end)

--================ ESP ITEM (DEMO) =================
task.spawn(function()
    while task.wait(1) do
        if Settings.ESP_Item then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") or v:IsA("BasePart") then
                    if not v:FindFirstChild("ESP") then
                        local h = Instance.new("Highlight", v)
                        h.Name = "ESP"
                        h.FillColor = Color3.fromRGB(0,255,255)
                    end
                end
            end
        end
    end
end)

--================ HÚT VẬT PHẨM (DEMO) =================
task.spawn(function()
    while task.wait(0.3) do
        if Settings.Magnet then
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _,v in pairs(workspace:GetDescendants()) do
                    if (v:IsA("Tool") or v:IsA("BasePart")) and v:IsDescendantOf(workspace) then
                        if (v.Position - hrp.Position).Magnitude <= Settings.MagnetRange then
                            pcall(function()
                                v.CFrame = hrp.CFrame
                            end)
                        end
                    end
                end
            end
        end
    end
end)

--================ XOAY GRADIENT =================
task.spawn(function()
    while true do
        grad.Rotation += 1
        task.wait(0.02)
    end
end)
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
