--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

--// PLAYER SETUP
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 10)
local RootPart = Character:WaitForChild("HumanoidRootPart", 10)

-- Reset old menu
if getgenv().MathewHub then getgenv().MathewHub:Destroy() end

--// SETTINGS
local Settings = {
    AutoSteal = {Enabled = false, Range = 30, AutoTarget = true, Delay = 1.2, AntiDetect = true, Collect = true},
    Dupe = {Enabled = false, ItemName = "None", Amount = 1, Stack = true},
    Sprinkler = {Enabled = false, Range = 25, AutoAll = true, RefreshRate = 1},
    Seed = {Enabled = false, Type = "Basic Seed", Spacing = 3, AutoRefill = true},
    Plant = {Enabled = false, GrowSpeed = 2, InstantGrow = false, AutoHarvest = true, HarvestRange = 20},
    Fly = {Enabled = false, Speed = 50, MaxHeight = 300, NoCollision = false, Connection = nil},
    Speed = {Enabled = false, Multiplier = 2, OriginalWalk = 16, OriginalJump = 50},
    FruitRain = {Enabled = false, Radius = 50, Amount = 10} -- FIX: was missing from Settings table
}

--// Sprinkler throttle timer
local sprinklerTimer = 0

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MathewHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer.PlayerGui
getgenv().MathewHub = ScreenGui

-- Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 550, 0, 400)
Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Mathew Hub | Gag 2"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.Parent = TitleBar

-- Panels
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0.32, 0, 1, -45)
LeftPanel.Position = UDim2.new(0, 10, 0, 45)
LeftPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
LeftPanel.Parent = Main

local CatList = Instance.new("ScrollingFrame")
CatList.Size = UDim2.new(1, -10, 1, -10)
CatList.BackgroundTransparency = 1
CatList.ScrollBarThickness = 4
CatList.CanvasSize = UDim2.new(0, 0, 0, 360) -- FIX: increased to fit all 8 categories
CatList.Parent = LeftPanel

local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0.62, 0, 1, -45)
RightPanel.Position = UDim2.new(0.36, 0, 0, 45)
RightPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
RightPanel.Parent = Main

local SettingsContainer = Instance.new("Frame")
SettingsContainer.Size = UDim2.new(1, -20, 1, -20)
SettingsContainer.Position = UDim2.new(0, 10, 0, 10)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.Visible = false
SettingsContainer.Parent = RightPanel

--// HELPERS
local function ClearSettings()
    for _,c in ipairs(SettingsContainer:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

local function CreateCategory(name, y, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = CatList
    btn.MouseButton1Click:Connect(func)
end

local function CreateToggle(name, y, val, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 30)
    f.Position = UDim2.new(0, 0, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = SettingsContainer

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local tgl = Instance.new("TextButton")
    tgl.Size = UDim2.new(0, 45, 0, 22)
    tgl.Position = UDim2.new(0.72, 0, 0.5, -11)
    tgl.BackgroundColor3 = val and Color3.fromRGB(60,180,80) or Color3.fromRGB(180,60,60)
    tgl.Text = val and "ON" or "OFF"
    tgl.TextColor3 = Color3.new(1,1,1)
    tgl.Parent = f

    tgl.MouseButton1Click:Connect(function()
        val = not val
        tgl.BackgroundColor3 = val and Color3.fromRGB(60,180,80) or Color3.fromRGB(180,60,60)
        tgl.Text = val and "ON" or "OFF"
        callback(val)
    end)
end

local function CreateInput(name, y, val, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 30)
    f.Position = UDim2.new(0, 0, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = SettingsContainer

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.45, 0, 0, 22)
    box.Position = UDim2.new(0.52, 0, 0.5, -11)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    box.Text = tostring(val)
    box.TextColor3 = Color3.new(1,1,1)
    box.Parent = f

    box.FocusLost:Connect(function()
        local newVal = tonumber(box.Text) or box.Text
        callback(newVal)
        box.Text = tostring(newVal)
    end)
end

local function CreateButton(name, y, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = SettingsContainer
    btn.MouseButton1Click:Connect(func)
end

--// FEATURE UI

-- Dupe
CreateCategory("Dupe Items", 10, function()
    ClearSettings() SettingsContainer.Visible = true
    CreateToggle("Enable Dupe", 10, Settings.Dupe.Enabled, function(v) Settings.Dupe.Enabled = v end)
    CreateInput("Item Name", 45, Settings.Dupe.ItemName, function(v) Settings.Dupe.ItemName = v end)
    CreateInput("Amount / Stack", 80, Settings.Dupe.Amount, function(v) Settings.Dupe.Amount = math.clamp(v, 1, 9999) end)
    CreateButton("✅ Apply Dupe", 125, function()
        if not Settings.Dupe.Enabled or Settings.Dupe.ItemName == "None" then return end
        local backpack = LocalPlayer.Backpack
        local existing = backpack:FindFirstChild(Settings.Dupe.ItemName)
        if existing then
            if existing:FindFirstChild("Value") then
                existing.Value.Value = Settings.Dupe.Amount
            elseif existing:IsA("Tool") then
                local newClone = existing:Clone()
                newClone:SetAttribute("Stack", Settings.Dupe.Amount)
                newClone.Parent = backpack
                existing:Destroy()
            end
            StarterGui:SetCore("SendNotification", {Title = "Dupe Applied", Text = Settings.Dupe.Amount .. "x " .. Settings.Dupe.ItemName, Duration = 3})
        else
            StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Item not found in Backpack", Duration = 3})
        end
    end)
end)

-- Sprinkler
CreateCategory("Sprinkler", 47, function()
    ClearSettings() SettingsContainer.Visible = true
    CreateToggle("Enable Sprinkler", 10, Settings.Sprinkler.Enabled, function(v) Settings.Sprinkler.Enabled = v end)
    CreateInput("Water Radius", 45, Settings.Sprinkler.Range, function(v) Settings.Sprinkler.Range = math.clamp(v, 5, 100) end)
    CreateToggle("Auto Water All", 80, Settings.Sprinkler.AutoAll, function(v) Settings.Sprinkler.AutoAll = v end)
    CreateInput("Refresh Rate", 115, Settings.Sprinkler.RefreshRate, function(v) Settings.Sprinkler.RefreshRate = math.clamp(v, 0.2, 3) end)
end)

-- Seed
CreateCategory("Seed", 84, function()
    ClearSettings() SettingsContainer.Visible = true
    CreateToggle("Enable Auto Plant", 10, Settings.Seed.Enabled, function(v) Settings.Seed.Enabled = v end)
    CreateInput("Seed Type", 45, Settings.Seed.Type, function(v) Settings.Seed.Type = v end)
    CreateInput("Plant Spacing", 80, Settings.Seed.Spacing, function(v) Settings.Seed.Spacing = math.clamp(v, 1, 10) end)
    CreateToggle("Auto Refill", 115, Settings.Seed.AutoRefill, function(v) Settings.Seed.AutoRefill = v end)
end)

-- Plant
CreateCategory("Plant", 121, function()
    ClearSettings() SettingsContainer.Visible = true
    CreateToggle("Enable Auto Grow", 10, Settings.Plant.Enabled, function(v) Settings.Plant.Enabled = v end)
    CreateInput("Grow Speed", 45, Settings.Plant.GrowSpeed, function(v) Settings.Plant.GrowSpeed = math.clamp(v, 1, 20) end)
    CreateToggle("Instant Grow", 80, Settings.Plant.InstantGrow, function(v) Settings.Plant.InstantGrow = v end)
    CreateToggle("Auto Harvest", 115, Settings.Plant.AutoHarvest, function(v) Settings.Plant.AutoHarvest = v end)
    CreateInput("Harvest Range", 150, Settings.Plant.HarvestRange, function(v) Settings.Plant.HarvestRange = math.clamp(v, 5, 80) end)
end)

-- Fly
CreateCategory("Fly", 158, function()
    ClearSettings() SettingsContainer.Visible = true
    CreateToggle("Enable Fly", 10, Settings.Fly.Enabled, function(v)
        Settings.Fly.Enabled = v
        if not v then
            -- FIX: disconnect properly when toggled off
            if Settings.Fly.Connection then
                Settings.Fly.Connection:Disconnect()
                Settings.Fly.Connection = nil
            end
            Humanoid.PlatformStand = false
            Humanoid.WalkSpeed = Settings.Speed.OriginalWalk
            Humanoid.JumpPower = Settings.Speed.OriginalJump
            RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) -- FIX: .Velocity is deprecated
            RootPart.CanCollide = true
        end
    end)
    CreateInput("Fly Speed", 45, Settings.Fly.Speed, function(v) Settings.Fly.Speed = math.clamp(v, 10, 300) end)
    CreateInput("Max Height", 80, Settings.Fly.MaxHeight, function(v) Settings.Fly.MaxHeight = math.clamp(v, 50, 1000) end)
    CreateToggle("No Collision", 115, Settings.Fly.NoCollision, function(v) Settings.Fly.NoCollision = v end)
end)

-- Speed Hack
CreateCategory("Speed Hack", 195, function()
    ClearSettings() SettingsContainer.Visible = true
    CreateToggle("Enable Speed", 10, Settings.Speed.Enabled, function(v)
        Settings.Speed.Enabled = v
        if not v then
            Humanoid.WalkSpeed = Settings.Speed.OriginalWalk
            Humanoid.JumpPower = Settings.Speed.OriginalJump
        end
    end)
    CreateInput("Multiplier", 45, Settings.Speed.Multiplier, function(v) Settings.Speed.Multiplier = math.clamp(v, 1, 50) end)
    CreateButton("🔄 Reset", 80, function()
        Settings.Speed.Enabled = false
        Settings.Speed.Multiplier = 1
        Humanoid.WalkSpeed = Settings.Speed.OriginalWalk
        Humanoid.JumpPower = Settings.Speed.OriginalJump
    end)
end)

-- Fruit Rain
CreateCategory("Fruit Rain", 232, function()
    ClearSettings() SettingsContainer.Visible = true
    -- FIX: Settings.FruitRain now exists so this no longer crashes
    CreateToggle("Enable Fruit Rain", 10, Settings.FruitRain.Enabled, function(v) Settings.FruitRain.Enabled = v end)
    CreateInput("Radius", 45, Settings.FruitRain.Radius, function(v) Settings.FruitRain.Radius = math.clamp(v, 10, 200) end)
    CreateInput("Amount", 80, Settings.FruitRain.Amount, function(v) Settings.FruitRain.Amount = math.clamp(v, 1, 50) end)
end)

--// MAIN WORKING LOGIC
RunService.Heartbeat:Connect(function(dt)
    -- Refresh character if respawned
    if not Character or not Character.Parent or not Character:FindFirstChild("HumanoidRootPart") then
        Character = LocalPlayer.Character
        if not Character then return end
        Humanoid = Character:WaitForChild("Humanoid", 10)
        RootPart = Character:WaitForChild("HumanoidRootPart", 10)
        return
    end

    -- SPEED HACK
    if Settings.Speed.Enabled then
        Humanoid.WalkSpeed = Settings.Speed.OriginalWalk * Settings.Speed.Multiplier
        Humanoid.JumpPower = Settings.Speed.OriginalJump * Settings.Speed.Multiplier
    end

    -- FLY LOGIC — start connection if not already running
    if Settings.Fly.Enabled and not Settings.Fly.Connection then
        Settings.Fly.Connection = RunService.RenderStepped:Connect(function()
            if not Settings.Fly.Enabled then
                Settings.Fly.Connection:Disconnect()
                Settings.Fly.Connection = nil
                Humanoid.PlatformStand = false
                RootPart.CanCollide = true
                return
            end
            Humanoid.PlatformStand = true
            RootPart.CanCollide = not Settings.Fly.NoCollision

            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end

            -- FIX: guard against zero vector normalization (causes NaN)
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * Settings.Fly.Speed
            else
                moveDir = Vector3.new(0, 0, 0)
            end

            if RootPart.Position.Y > Settings.Fly.MaxHeight then
                moveDir = Vector3.new(moveDir.X, math.min(moveDir.Y, 0), moveDir.Z)
            end

            RootPart.AssemblyLinearVelocity = moveDir -- FIX: .Velocity deprecated
        end)
    end

    -- SPRINKLER LOGIC — FIX: use dt timer instead of task.wait() inside Heartbeat
    if Settings.Sprinkler.Enabled then
        sprinklerTimer += dt
        if sprinklerTimer >= Settings.Sprinkler.RefreshRate then
            sprinklerTimer = 0
            local range = Settings.Sprinkler.Range
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:FindFirstChild("Water") and obj:IsA("BasePart") then
                    if (obj.Position - RootPart.Position).Magnitude < range then
                        obj.Water.Value = 100
                    end
                end
            end
        end
    else
        sprinklerTimer = 0
    end

    -- AUTO SEED / PLANT
    if Settings.Seed.Enabled then
        local seed = LocalPlayer.Backpack:FindFirstChild(Settings.Seed.Type)
        if seed and seed:IsA("Tool") then
            local plots = Workspace:FindFirstChild("PlantingPlots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    if plot:IsA("BasePart") and not plot:FindFirstChild("Crop") then
                        if (plot.Position - RootPart.Position).Magnitude < 15 then
                            pcall(function()
                                ReplicatedStorage.Remotes.Plant:FireServer(plot, Settings.Seed.Type)
                            end)
                            task.wait(0.3)
                        end
                    end
                end
            end
        elseif Settings.Seed.AutoRefill then
            pcall(function()
                ReplicatedStorage.Remotes.BuySeed:FireServer(Settings.Seed.Type, 10)
            end)
        end
    end

    -- AUTO GROW / HARVEST
    if Settings.Plant.Enabled then
        local range = Settings.Plant.HarvestRange
        for _, crop in ipairs(Workspace:GetDescendants()) do
            if crop:FindFirstChild("Growth") and crop:IsA("BasePart") then
                if (crop.Position - RootPart.Position).Magnitude < range then
                    if Settings.Plant.InstantGrow then
                        crop.Growth.Value = 100
                    else
                        crop.Growth.Value = math.min(crop.Growth.Value + (0.1 * Settings.Plant.GrowSpeed), 100)
                    end
                    if crop.Growth.Value >= 100 and Settings.Plant.AutoHarvest then
                        pcall(function()
                            ReplicatedStorage.Remotes.Harvest:FireServer(crop)
                        end)
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end)

-- Toggle Menu with Insert Key
UserInputService.InputBegan:Connect(function(i, gameProcessed)
    if gameProcessed then return end -- FIX: ignore input consumed by UI/chat
    if i.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)
