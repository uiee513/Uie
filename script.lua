local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "OVERNIGHT HUB",
   LoadingTitle = "Đang khởi tạo hệ thống...",
   LoadingSubtitle = "by Uiee513",
   ConfigurationSaving = { Enabled = false }
})

-- --- NÚT NỔI CAM (FIX LỖI KHÔNG MỞ ĐƯỢC MENU) ---
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
ToggleButton.Image = "rbxassetid://6031280359"
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 15)

ToggleButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
end)

local TabCombat = Window:CreateTab("Chiến Đấu", 4483362458)
local TabFarm = Window:CreateTab("Tự Động", 4483362458)
local TabMisc = Window:CreateTab("Tiện Ích", 4483362458)

-- --- 1. REACH (TĂNG TẦM ĐÁNH) ---
_G.ReachDist = 15
TabCombat:CreateSlider({
   Name = "Phạm vi đánh (Reach)",
   Range = {1, 50}, Increment = 1, Suffix = "Studs", CurrentValue = 15,
   Callback = function(v) _G.ReachDist = v end,
})

TabCombat:CreateToggle({
   Name = "Bật Reach",
   CurrentValue = false,
   Callback = function(v)
      _G.EnableReach = v
      task.spawn(function()
         while _G.EnableReach do
            pcall(function()
               local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
               if tool and tool:FindFirstChild("Handle") then
                  tool.Handle.Size = Vector3.new(_G.ReachDist, _G.ReachDist, _G.ReachDist)
                  tool.Handle.CanCollide = false
               end
            end)
            task.wait(0.5)
         end
      end)
   end,
})

-- --- 2. AUTO LOOT (HÚT ĐỒ ĂN & QUẶNG & VẬT PHẨM) ---
TabFarm:CreateToggle({
   Name = "Auto Hút Mọi Vật Phẩm",
   CurrentValue = false,
   Callback = function(v)
      _G.AutoLoot = v
      task.spawn(function()
         while _G.AutoLoot do
            for _, item in pairs(game.Workspace:GetChildren()) do
               if item:IsA("BasePart") and (item.Name:lower():find("food") or item.Name:lower():find("apple") or item.Name:lower():find("ore") or item:FindFirstChild("TouchInterest")) then
                  item.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
               end
            end
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
