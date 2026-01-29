-- OVERNIGHT HUB | Việt hoá + Toggle Menu
-- Base script: gumanba

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Load script gốc
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/24HoursOvernight"))()
end)

-- ===== VIỆT HOÁ =====
local function VietHoa()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            v.Text = v.Text
                :gsub("Goto Spawn", "Về Điểm Hồi Sinh")
                :gsub("Auto Eat", "Tự Ăn Khi Đói")
                :gsub("Auto Crystal & Scrap", "Tự Nhặt Crystal & Phế Liệu")
                :gsub("Bring to Exchange", "Chuyển Đến Khu Trao Đổi")
                :gsub("Walk Speed", "Tốc Độ Di Chuyển")
                :gsub("Toggle Fly", "Bật / Tắt Bay")
                :gsub("Set Speed", "Chỉnh Tốc Độ")
                :gsub("Fullbright & NoFog", "Sáng Tối Đa & Xoá Sương")
                :gsub("Bring Items", "Hút Vật Phẩm")
                :gsub("Refresh Item List", "Làm Mới Danh Sách")
                :gsub("Bring Foods", "Hút Thức Ăn")
                :gsub("Select Item", "Chọn Vật Phẩm")
        end
    end
end

-- Việt hoá liên tục để không bị sót
task.spawn(function()
    while true do
        VietHoa()
        task.wait(1)
    end
end)

-- ===== TOGGLE MENU =====
local ToggleGui = Instance.new("ScreenGui", Player.PlayerGui)
ToggleGui.Name = "OvernightToggle"

local Btn = Instance.new("TextButton", ToggleGui)
Btn.Size = UDim2.new(0, 120, 0, 40)
Btn.Position = UDim2.new(0, 10, 0.5, -20)
Btn.Text = "OVERNIGHT HUB"
Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
Btn.TextColor3 = Color3.fromRGB(255,255,255)
Btn.BorderSizePixel = 0
Btn.Active = true
Btn.Draggable = true

local UICorner = Instance.new("UICorner", Btn)
UICorner.CornerRadius = UDim.new(0, 8)

-- Tìm GUI HUB gốc
local HubGui
task.delay(2, function()
    for _,v in pairs(Player.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v ~= ToggleGui then
            HubGui = v
        end
    end
end)

-- Bật / tắt menu
Btn.MouseButton1Click:Connect(function()
    if HubGui then
        HubGui.Enabled = not HubGui.Enabled
    end
end)    btn.Font = Enum.Font.GothamBold
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
