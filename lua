-- [[ Family 🦖 Complete Script - Fixed + Cash Farm + Anti-AFK ]] --
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Family 🦖 Hub",
    SubTitle = "Fixed + Cash Farm + Anti-AFK",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "ฟาร์ม & ขโมย", Icon = "home" }),
    Movement = Window:AddTab({ Title = "เคลื่อนที่ & วาร์ป", Icon = "plane" }),
    Settings = Window:AddTab({ Title = "ตั้งค่า / เพิ่มความลื่น", Icon = "settings" })
}

-- [[ Variables ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportSpeed = 100
local FlySpeed = 50
local IsFlying = false

-- [[ 11. ระบบ Anti-AFK ป้องกันหลุดเกม (ทำงานอัตโนมัติ) ]] --
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

Tabs.Settings:AddToggle("AntiAFKToggle", {Title = "🛡️ เปิดใช้งาน Anti-AFK (ป้องกันหลุด)", Default = true}):OnChanged(function(Value)
    _G.AntiAFK = Value
    task.spawn(function()
        while _G.AntiAFK do
            task.wait(60)
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end)

-- [[ 10. ออโต้เก็บเงิน / เหรียญ ]] --
Tabs.Main:AddToggle("AutoFarmCash", {Title = "💰 ออโต้เก็บเงิน / เหรียญ (Auto Cash)", Default = false}):OnChanged(function(Value)
    _G.AutoFarmCash = Value
    task.spawn(function()
        while _G.AutoFarmCash do
            task.wait(0.2)
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                for _, obj in pairs(workspace:GetDescendants()) do
                    if not _G.AutoFarmCash then break end
                    
                    local name = obj.Name:lower()
                    if name:find("cash") or name:find("coin") or name:find("money") or name:find("dollar") or name:find("gem") then
                        local targetPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if targetPart then
                            firetouchinterest(char.HumanoidRootPart, targetPart, 0)
                            firetouchinterest(char.HumanoidRootPart, targetPart, 1)

                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ProximityPrompt"))
                            if prompt then fireproximityprompt(prompt) end

                            local clicker = obj:FindFirstChildOfClass("ClickDetector") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ClickDetector"))
                            if clicker then fireclickdetector(clicker) end
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ 1. ออโต้ฟาร์มลู่วิ่ง ]] --
Tabs.Main:AddToggle("AutoTreadmill", {Title = "1. ออโต้ฟาร์มลู่วิ่ง", Default = false}):OnChanged(function(Value)
    _G.AutoTreadmill = Value
    task.spawn(function()
        while _G.AutoTreadmill do
            task.wait(0.1)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if not _G.AutoTreadmill then break end
                        if v.Name:lower():find("treadmill") or v.Name:lower():find("tread") then
                            local part = v:IsA("BasePart") and v or (v:IsA("Model") and v.PrimaryPart)
                            if part then
                                char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                                if char:FindFirstChildOfClass("Humanoid") then
                                    char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ 2. ออโต้ขโมยไข่ ]] --
Tabs.Main:AddToggle("AutoStealEgg", {Title = "2. ออโต้ขโมยไข่", Default = false}):OnChanged(function(Value)
    _G.AutoStealEgg = Value
    task.spawn(function()
        while _G.AutoStealEgg do
            task.wait(0.3)
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                for _, obj in pairs(workspace:GetDescendants()) do
                    if not _G.AutoStealEgg then break end
                    
                    if obj.Name:lower():find("egg") then
                        local targetPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                        if targetPart then
                            char.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                        end
                        
                        local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ProximityPrompt"))
                        if prompt then fireproximityprompt(prompt) end
                        
                        local clicker = obj:FindFirstChildOfClass("ClickDetector") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ClickDetector"))
                        if clicker then fireclickdetector(clicker) end

                        local touch = obj:FindFirstChildOfClass("TouchInterest") or (targetPart and targetPart:FindFirstChild("TouchInterest"))
                        if touch and targetPart then
                            firetouchinterest(char.HumanoidRootPart, targetPart, 0)
                            firetouchinterest(char.HumanoidRootPart, targetPart, 1)
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ 3. ออโต้ทำอีเว้นท์ ]] --
Tabs.Main:AddToggle("AutoEvent", {Title = "3. ออโต้ทำอีเว้นท์", Default = false}):OnChanged(function(Value)
    _G.AutoEvent = Value
    task.spawn(function()
        while _G.AutoEvent do
            task.wait(0.5)
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if not _G.AutoEvent then break end
                    if v.Name:lower():find("event") then
                        local part = v:IsA("BasePart") and v or (v:IsA("Model") and v.PrimaryPart)
                        if part then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                        end
                    end
                end
            end)
        end
    end)
end)

-- [[ 4. ขโมยไข่ที่ดีที่สุด ]] --
Tabs.Main:AddButton({
    Title = "4. ขโมยไข่ที่ดีที่สุด (Best Egg)",
    Callback = function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            for _, obj in pairs(workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if name:find("legendary") or name:find("mythic") or name:find("golden") or name:find("best") or name:find("egg") then
                    local targetPart = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
                    if targetPart then
                        char.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                        
                        local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ProximityPrompt"))
                        if prompt then fireproximityprompt(prompt) end
                        
                        local clicker = obj:FindFirstChildOfClass("ClickDetector") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ClickDetector"))
                        if clicker then fireclickdetector(clicker) end
                        break
                    end
                end
            end
        end)
    end
})

-- [[ 5. ลดแลค / ลื่นขึ้น (No Lag) ]] --
Tabs.Settings:AddButton({
    Title = "5. เปิดโหมดลื่น (Boost FPS)",
    Description = "ลดกราฟิก ลบ Texture เพื่อให้เกมไม่กระตุก",
    Callback = function()
        pcall(function()
            local settings = UserSettings():GetService("UserGameSettings")
            settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 9e9
            
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end)
    end
})

-- [[ 6. วาร์ปไปหาผู้เล่นอื่น ]] --
Tabs.Movement:AddButton({
    Title = "6. วาร์ปไปหาผู้เล่นสุ่ม (Teleport)",
    Callback = function()
        pcall(function()
            local allPlayers = Players:GetPlayers()
            for _, p in pairs(allPlayers) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetCFrame = p.Character.HumanoidRootPart.CFrame
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
                    local duration = dist / TeleportSpeed
                    
                    local tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                    tween:Play()
                    break
                end
            end
        end)
    end
})

-- [[ 7. บิน (Fly) ]] --
Tabs.Movement:AddToggle("FlyToggle", {Title = "7. เปิด/ปิด การบิน", Default = false}):OnChanged(function(Value)
    IsFlying = Value
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if IsFlying then
        local bv = char.HumanoidRootPart:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Parent = char.HumanoidRootPart
        
        task.spawn(function()
            while IsFlying and char:FindFirstChild("HumanoidRootPart") do
                local cam = workspace.CurrentCamera
                bv.Velocity = cam.CFrame.LookVector * FlySpeed
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        if char.HumanoidRootPart:FindFirstChild("FlyVelocity") then
            char.HumanoidRootPart.FlyVelocity:Destroy()
        end
    end
end)

-- [[ 8. กำหนดความเร็วบิน (1-1000) ]] --
Tabs.Movement:AddSlider("FlySpeed", {
    Title = "8. กำหนดความเร็วบิน (1-1000)",
    Default = 50,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        FlySpeed = Value
    end
})

-- [[ 9. กำหนดความเร็ววาร์ป (1-1000) ]] --
Tabs.Movement:AddSlider("TPSpeed", {
    Title = "9. กำหนดความเร็วการวาร์ป (1-1000)",
    Default = 100,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        TeleportSpeed = Value
    end
})

-- UI Setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Family 🦖 Hub",
    Content = "โหลดสคริปต์สำเร็จ! เพิ่ม Anti-AFK เรียบร้อย",
    Duration = 5
})
