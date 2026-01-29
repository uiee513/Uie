--// OVERNIGHT HUB - FLY + ITEM MAGNET (BASE)

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- STATES
local flying = false
local flySpeed = 60
local flyBV, flyBG

-- ================= UI =================
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "OvernightHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 180)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- Drag UI
do
    local dragging, startPos, startInput
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startInput = input.Position
            startPos = main.Position
        end
    end)
    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startInput
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "🌙 OVERNIGHT HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- Button creator
local function createButton(text, y)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(1,-30,0,40)
    btn.Position = UDim2.new(0,15,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    return btn
end

-- ================= FLY =================
local flyBtn = createButton("🕊 Fly: OFF", 50)

local function startFly()
    flying = true
    flyBV = Instance.new("BodyVelocity", hrp)
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)

    flyBG = Instance.new("BodyGyro", hrp)
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)

    RunService:BindToRenderStep("Fly", 0, function()
        local cam = workspace.CurrentCamera
        local move = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= cam.CFrame.UpVector end

        if move.Magnitude > 0 then
            flyBV.Velocity = move.Unit * flySpeed
        else
            flyBV.Velocity = Vector3.zero
        end
        flyBG.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    RunService:UnbindFromRenderStep("Fly")
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyBtn.Text = "🕊 Fly: OFF"
    else
        startFly()
        flyBtn.Text = "🕊 Fly: ON"
    end
end)

-- ================= ITEM MAGNET =================
local magnetBtn = createButton("🧲 Hút vật phẩm: OFF", 100)
local magnet = false

-- ⚠️ ĐỔI TÊN FOLDER CHO ĐÚNG GAME
local ITEM_FOLDER_NAME = "Items"

magnetBtn.MouseButton1Click:Connect(function()
    magnet = not magnet
    magnetBtn.Text = magnet and "🧲 Hút vật phẩm: ON" or "🧲 Hút vật phẩm: OFF"

    task.spawn(function()
        while magnet do
            local folder = workspace:FindFirstChild(ITEM_FOLDER_NAME)
            if folder then
                for _,v in pairs(folder:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CFrame = hrp.CFrame
                    end
                end
            end
            task.wait(0.25)
        end
    end)
end)

-- ================= CLOSE =================
local closeBtn = createButton("❌ Đóng UI", 145)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
