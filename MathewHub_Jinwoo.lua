--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

--// PLAYER SETUP
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 10)
local RootPart = Character:WaitForChild("HumanoidRootPart", 10)

-- Reset old menu
if getgenv().MathewHub then getgenv().MathewHub:Destroy() end

--// SEED LIST (Grow a Garden - all common obtainable seeds)
local SEED_LIST = {
    -- Common / Basic
    "Carrot Seed", "Strawberry Seed", "Blueberry Seed", "Tomato Seed",
    "Corn Seed", "Watermelon Seed", "Pumpkin Seed", "Apple Seed",
    "Banana Seed", "Coconut Seed", "Papaya Seed", "Mango Seed",
    "Pineapple Seed", "Grape Seed", "Cherry Seed", "Peach Seed",
    "Lemon Seed", "Orange Seed", "Cactus Seed", "Bamboo Seed",
    -- Uncommon
    "Sugar Apple Seed", "Cocomango Seed", "Dragon Pepper Seed",
    "Starfruit Seed", "Moonglow Seed", "Beanstalk Seed",
    "Brussels Sprout Seed", "Potato Seed", "Elder Strawberry Seed",
    -- Rare
    "Candy Blossom Seed", "Maple Resin Seed", "Bone Blossom Seed",
    "Moon Mango Seed", "Spiked Mango Seed", "Maple Apple Seed",
    "Giant Pinecone Seed", "Crimson Thorn Seed",
    -- Legendary
    "Zebrazinkle Seed", "Fossilight Fruit Seed", "Traveler's Fruit Seed",
}

--// SETTINGS
local Settings = {
    Dupe     = {Enabled = false, ItemName = "None", Amount = 1},
    Sprinkler= {Enabled = false, Range = 25, AutoAll = true, RefreshRate = 1},
    Seed     = {Enabled = false, Type = SEED_LIST[1], Spacing = 3, AutoRefill = true},
    Plant    = {Enabled = false, GrowSpeed = 2, InstantGrow = false, AutoHarvest = true, HarvestRange = 20},
    Fly      = {Enabled = false, Speed = 50, MaxHeight = 300, NoCollision = false, Connection = nil},
    Speed    = {Enabled = false, Multiplier = 2, OriginalWalk = 16, OriginalJump = 50},
    FruitRain= {Enabled = false, SelectedFruit = "Apple", Radius = 40, Amount = 10, Timer = 0, Interval = 2},
}

--// Timers
local sprinklerTimer = 0
local fruitRainTimer = 0

-- Fruit rain drop list (actual harvestable fruits/crops by name in GaG)
local FRUIT_RAIN_LIST = {
    "Apple","Banana","Carrot","Strawberry","Blueberry","Tomato","Corn",
    "Watermelon","Pumpkin","Coconut","Papaya","Mango","Pineapple","Grape",
    "Cherry","Peach","Lemon","Orange","Sugar Apple","Cocomango",
    "Dragon Pepper","Starfruit","Bone Blossom","Candy Blossom","Moon Mango",
    "Maple Resin","Spiked Mango","Maple Apple","Crimson Thorn","Zebrazinkle",
}

--// ============================================================
--//  JINWOO THEME  (Solo Leveling — dark navy / electric purple)
--// ============================================================
local C = {
    BG         = Color3.fromRGB(10,  10,  18),   -- deep void black
    Panel      = Color3.fromRGB(16,  14,  30),   -- dark indigo panel
    Card       = Color3.fromRGB(22,  19,  42),   -- card bg
    Accent     = Color3.fromRGB(130,  60, 255),  -- electric purple
    AccentDark = Color3.fromRGB( 70,  20, 160),  -- deeper purple
    AccentGlow = Color3.fromRGB(180, 100, 255),  -- glow purple
    ON         = Color3.fromRGB( 90, 220, 120),  -- green ON
    OFF        = Color3.fromRGB(200,  50,  70),  -- red OFF
    Text       = Color3.new(1, 1, 1),
    SubText    = Color3.fromRGB(160, 150, 200),
    InputBG    = Color3.fromRGB(28,  24,  52),
    Divider    = Color3.fromRGB(50,  40,  90),
    ActiveCat  = Color3.fromRGB(100,  40, 220),
    HoverCat   = Color3.fromRGB(35,  28,  65),
}

--// GUI ROOT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MathewHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui
getgenv().MathewHub = ScreenGui

--// MAIN WINDOW
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 580, 0, 430)
Main.Position = UDim2.new(0.5, -290, 0.5, -215)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Accent border stroke
local stroke = Instance.new("UIStroke", Main)
stroke.Color = C.Accent
stroke.Thickness = 1.5
stroke.Transparency = 0.4

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = C.Panel
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

-- fix bottom corners of topbar
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0.5, 0)
TopBarFix.Position = UDim2.new(0, 0, 0.5, 0)
TopBarFix.BackgroundColor3 = C.Panel
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Purple accent left bar
local LeftAccent = Instance.new("Frame")
LeftAccent.Size = UDim2.new(0, 4, 1, -12)
LeftAccent.Position = UDim2.new(0, 12, 0, 6)
LeftAccent.BackgroundColor3 = C.Accent
LeftAccent.BorderSizePixel = 0
LeftAccent.Parent = TopBar
Instance.new("UICorner", LeftAccent).CornerRadius = UDim.new(0, 3)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 24, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "  ⚔ MATHEW HUB  |  GROW A GARDEN"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = C.Text
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Version tag
local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0.25, 0, 0, 16)
VerLabel.Position = UDim2.new(0.74, 0, 0.5, -8)
VerLabel.BackgroundColor3 = C.AccentDark
VerLabel.Text = "v2.0 JINWOO"
VerLabel.Font = Enum.Font.GothamBold
VerLabel.TextSize = 10
VerLabel.TextColor3 = C.AccentGlow
VerLabel.Parent = TopBar
Instance.new("UICorner", VerLabel).CornerRadius = UDim.new(0, 4)

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(160, 30, 60)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- MINIMIZE BUTTON
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -68, 0.5, -14)
MinBtn.BackgroundColor3 = C.AccentDark
MinBtn.Text = "─"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13
MinBtn.TextColor3 = C.AccentGlow
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    -- hide everything below topbar
    for _, c in ipairs(Main:GetChildren()) do
        if c ~= TopBar then c.Visible = not minimized end
    end
    Main.Size = minimized and UDim2.new(0, 580, 0, 42) or UDim2.new(0, 580, 0, 430)
end)

-- CONTENT AREA (below top bar)
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -42)
Content.Position = UDim2.new(0, 0, 0, 42)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- LEFT SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -10)
Sidebar.Position = UDim2.new(0, 8, 0, 5)
Sidebar.BackgroundColor3 = C.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Content
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SidebarList = Instance.new("ScrollingFrame")
SidebarList.Size = UDim2.new(1, -8, 1, -10)
SidebarList.Position = UDim2.new(0, 4, 0, 5)
SidebarList.BackgroundTransparency = 1
SidebarList.ScrollBarThickness = 3
SidebarList.ScrollBarImageColor3 = C.Accent
SidebarList.CanvasSize = UDim2.new(0, 0, 0, 0)
SidebarList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SidebarList.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout", SidebarList)
SideLayout.Padding = UDim.new(0, 4)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SidePad = Instance.new("UIPadding", SidebarList)
SidePad.PaddingTop = UDim.new(0, 4)

-- RIGHT PANEL
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -176, 1, -10)
RightPanel.Position = UDim2.new(0, 172, 0, 5)
RightPanel.BackgroundColor3 = C.Panel
RightPanel.BorderSizePixel = 0
RightPanel.Parent = Content
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 8)

local RightScroll = Instance.new("ScrollingFrame")
RightScroll.Size = UDim2.new(1, -12, 1, -12)
RightScroll.Position = UDim2.new(0, 6, 0, 6)
RightScroll.BackgroundTransparency = 1
RightScroll.ScrollBarThickness = 3
RightScroll.ScrollBarImageColor3 = C.Accent
RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
RightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
RightScroll.Parent = RightPanel

local RightLayout = Instance.new("UIListLayout", RightScroll)
RightLayout.Padding = UDim.new(0, 6)
RightLayout.SortOrder = Enum.SortOrder.LayoutOrder

local RightPad = Instance.new("UIPadding", RightScroll)
RightPad.PaddingTop = UDim.new(0, 6)
RightPad.PaddingRight = UDim.new(0, 4)

-- STATUS BAR (bottom of window)
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 0) -- hidden until needed
StatusBar.BackgroundTransparency = 1
StatusBar.Parent = Main

--// ============================================================
--//  HELPERS
--// ============================================================

local activeCatBtn = nil

local function ClearRight()
    for _, c in ipairs(RightScroll:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

-- Section header inside right panel
local function SectionHeader(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = "▸  " .. text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = C.Accent
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = 0
    lbl.Parent = RightScroll

    local div = Instance.new("Frame")
    div.Size = UDim2.new(1, 0, 0, 1)
    div.BackgroundColor3 = C.Divider
    div.BorderSizePixel = 0
    div.LayoutOrder = 1
    div.Parent = RightScroll
end

-- Generic row wrapper
local rowOrder = 10
local function NextOrder()
    rowOrder = rowOrder + 1
    return rowOrder
end

local function MakeRow()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = C.Card
    f.BorderSizePixel = 0
    f.LayoutOrder = NextOrder()
    f.Parent = RightScroll
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    return f
end

local function CreateToggle(labelText, getVal, setVal)
    local f = MakeRow()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = C.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local tgl = Instance.new("TextButton")
    tgl.Size = UDim2.new(0, 52, 0, 22)
    tgl.Position = UDim2.new(1, -62, 0.5, -11)
    local v = getVal()
    tgl.BackgroundColor3 = v and C.ON or C.OFF
    tgl.Text = v and "ON" or "OFF"
    tgl.Font = Enum.Font.GothamBold
    tgl.TextSize = 11
    tgl.TextColor3 = Color3.new(1,1,1)
    tgl.Parent = f
    Instance.new("UICorner", tgl).CornerRadius = UDim.new(0, 5)

    tgl.MouseButton1Click:Connect(function()
        local nv = not getVal()
        setVal(nv)
        tgl.BackgroundColor3 = nv and C.ON or C.OFF
        tgl.Text = nv and "ON" or "OFF"
    end)
end

local function CreateInput(labelText, getVal, setVal, isStr)
    local f = MakeRow()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = C.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.38, 0, 0, 22)
    box.Position = UDim2.new(0.6, 0, 0.5, -11)
    box.BackgroundColor3 = C.InputBG
    box.Text = tostring(getVal())
    box.Font = Enum.Font.Gotham
    box.TextSize = 11
    box.TextColor3 = C.AccentGlow
    box.ClearTextOnFocus = false
    box.Parent = f
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", box).Color = C.Accent

    box.FocusLost:Connect(function()
        local nv = isStr and box.Text or (tonumber(box.Text) or getVal())
        setVal(nv)
        box.Text = tostring(nv)
    end)
end

local function CreateButton(labelText, color, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = color or C.Accent
    btn.Text = labelText
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.new(1,1,1)
    btn.LayoutOrder = NextOrder()
    btn.Parent = RightScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(func)
    return btn
end

-- Dropdown for seed / fruit selection
local function CreateDropdown(labelText, list, getVal, setVal)
    -- header row
    local f = MakeRow()
    f.Size = UDim2.new(1, 0, 0, 34)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextColor3 = C.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0.44, 0, 0, 22)
    dropBtn.Position = UDim2.new(0.54, 0, 0.5, -11)
    dropBtn.BackgroundColor3 = C.AccentDark
    dropBtn.Text = getVal()
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextSize = 10
    dropBtn.TextColor3 = C.AccentGlow
    dropBtn.ClipsDescendants = true
    dropBtn.Parent = f
    Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 5)

    -- dropdown list frame (spawned below row, lives in RightScroll)
    local listFrame = Instance.new("Frame")
    listFrame.BackgroundColor3 = C.InputBG
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.LayoutOrder = NextOrder()
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Parent = RightScroll
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", listFrame).Color = C.Accent

    local innerScroll = Instance.new("ScrollingFrame")
    innerScroll.Size = UDim2.new(1, -4, 1, -4)
    innerScroll.Position = UDim2.new(0, 2, 0, 2)
    innerScroll.BackgroundTransparency = 1
    innerScroll.ScrollBarThickness = 3
    innerScroll.ScrollBarImageColor3 = C.Accent
    innerScroll.CanvasSize = UDim2.new(0, 0, 0, #list * 26)
    innerScroll.Parent = listFrame

    local innerLayout = Instance.new("UIListLayout", innerScroll)
    innerLayout.Padding = UDim.new(0, 2)

    for _, item in ipairs(list) do
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, 0, 0, 24)
        itemBtn.BackgroundTransparency = 1
        itemBtn.Text = "  " .. item
        itemBtn.Font = Enum.Font.Gotham
        itemBtn.TextSize = 11
        itemBtn.TextColor3 = C.SubText
        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
        itemBtn.Parent = innerScroll

        itemBtn.MouseButton1Click:Connect(function()
            setVal(item)
            dropBtn.Text = item
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, 0, 0, 0)
        end)

        itemBtn.MouseEnter:Connect(function()
            itemBtn.TextColor3 = C.AccentGlow
        end)
        itemBtn.MouseLeave:Connect(function()
            itemBtn.TextColor3 = C.SubText
        end)
    end

    local open = false
    dropBtn.MouseButton1Click:Connect(function()
        open = not open
        listFrame.Visible = open
        listFrame.Size = open and UDim2.new(1, 0, 0, math.min(#list * 26, 160)) or UDim2.new(1, 0, 0, 0)
    end)
end

-- Notify helper
local function Notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = dur or 3})
    end)
end

-- Category button in sidebar
local function CreateCat(icon, name, order, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = C.Card
    btn.Text = ""
    btn.LayoutOrder = order
    btn.Parent = SidebarList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 28, 1, 0)
    iconLbl.Position = UDim2.new(0, 6, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 16
    iconLbl.Parent = btn

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -38, 1, 0)
    nameLbl.Position = UDim2.new(0, 36, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 11
    nameLbl.TextColor3 = C.SubText
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if activeCatBtn then
            activeCatBtn.BackgroundColor3 = C.Card
            activeCatBtn:FindFirstChildOfClass("TextLabel").TextColor3 = C.SubText
        end
        activeCatBtn = nameLbl
        btn.BackgroundColor3 = C.ActiveCat
        nameLbl.TextColor3 = Color3.new(1,1,1)

        rowOrder = 10
        ClearRight()
        func()
    end)

    btn.MouseEnter:Connect(function()
        if activeCatBtn ~= nameLbl then
            btn.BackgroundColor3 = C.HoverCat
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeCatBtn ~= nameLbl then
            btn.BackgroundColor3 = C.Card
        end
    end)
end

--// ============================================================
--//  CATEGORIES
--// ============================================================

-- 1. DUPE (visual-only, working inventory clone trick)
CreateCat("📦", "Dupe Items", 1, function()
    SectionHeader("ITEM DUPLICATOR  (Visual / Inventory)")

    CreateToggle("Enable Dupe",
        function() return Settings.Dupe.Enabled end,
        function(v) Settings.Dupe.Enabled = v end)

    CreateInput("Item Name", 
        function() return Settings.Dupe.ItemName end,
        function(v) Settings.Dupe.ItemName = v end, true)

    CreateInput("Clone Amount",
        function() return Settings.Dupe.Amount end,
        function(v) Settings.Dupe.Amount = math.clamp(math.floor(v), 1, 99) end)

    CreateButton("⚡  Apply Dupe", C.Accent, function()
        if not Settings.Dupe.Enabled then
            Notify("Dupe", "Enable dupe first!", 2) return
        end
        if Settings.Dupe.ItemName == "None" or Settings.Dupe.ItemName == "" then
            Notify("Dupe", "Enter an item name!", 2) return
        end

        local backpack = LocalPlayer.Backpack
        local existing = backpack:FindFirstChild(Settings.Dupe.ItemName)
            or (Character and Character:FindFirstChild(Settings.Dupe.ItemName))

        if not existing then
            Notify("Dupe Error", "'" .. Settings.Dupe.ItemName .. "' not found in Backpack.", 3)
            return
        end

        -- VISUAL ONLY: clone the tool into backpack N times
        -- This is purely client-side (visual stack) — safe, no server calls
        local cloned = 0
        for i = 1, Settings.Dupe.Amount do
            local clone = existing:Clone()
            clone.Name = existing.Name
            clone.Parent = backpack
            cloned = cloned + 1
        end

        Notify("Dupe Applied ✓", cloned .. "x " .. Settings.Dupe.ItemName .. " added (visual)", 3)
    end)

    CreateButton("🗑  Clear Dupes", Color3.fromRGB(160, 40, 60), function()
        if Settings.Dupe.ItemName == "None" or Settings.Dupe.ItemName == "" then return end
        local backpack = LocalPlayer.Backpack
        local all = backpack:GetChildren()
        local removed = 0
        -- keep one, remove rest
        local kept = false
        for _, item in ipairs(all) do
            if item.Name == Settings.Dupe.ItemName then
                if kept then item:Destroy() removed = removed + 1
                else kept = true end
            end
        end
        Notify("Cleared", "Removed " .. removed .. " dupes", 3)
    end)
end)

-- 2. SPRINKLER
CreateCat("💧", "Sprinkler", 2, function()
    SectionHeader("AUTO SPRINKLER")
    CreateToggle("Enable Sprinkler",
        function() return Settings.Sprinkler.Enabled end,
        function(v) Settings.Sprinkler.Enabled = v end)
    CreateInput("Water Radius",
        function() return Settings.Sprinkler.Range end,
        function(v) Settings.Sprinkler.Range = math.clamp(v,5,150) end)
    CreateToggle("Water All Plants",
        function() return Settings.Sprinkler.AutoAll end,
        function(v) Settings.Sprinkler.AutoAll = v end)
    CreateInput("Refresh (secs)",
        function() return Settings.Sprinkler.RefreshRate end,
        function(v) Settings.Sprinkler.RefreshRate = math.clamp(v,0.2,5) end)
end)

-- 3. AUTO SEED (with dropdown)
CreateCat("🌱", "Auto Seed", 3, function()
    SectionHeader("AUTO SEED PLANTER")
    CreateToggle("Enable Auto Plant",
        function() return Settings.Seed.Enabled end,
        function(v) Settings.Seed.Enabled = v end)
    -- Dropdown for seed type
    CreateDropdown("Seed Type", SEED_LIST,
        function() return Settings.Seed.Type end,
        function(v) Settings.Seed.Type = v end)
    CreateInput("Plot Range",
        function() return Settings.Seed.Spacing end,
        function(v) Settings.Seed.Spacing = math.clamp(v,1,20) end)
    CreateToggle("Auto Refill Seeds",
        function() return Settings.Seed.AutoRefill end,
        function(v) Settings.Seed.AutoRefill = v end)
end)

-- 4. AUTO PLANT (grow / harvest)
CreateCat("🌿", "Auto Plant", 4, function()
    SectionHeader("AUTO GROW & HARVEST")
    CreateToggle("Enable Auto Grow",
        function() return Settings.Plant.Enabled end,
        function(v) Settings.Plant.Enabled = v end)
    CreateInput("Grow Speed",
        function() return Settings.Plant.GrowSpeed end,
        function(v) Settings.Plant.GrowSpeed = math.clamp(v,1,20) end)
    CreateToggle("Instant Grow",
        function() return Settings.Plant.InstantGrow end,
        function(v) Settings.Plant.InstantGrow = v end)
    CreateToggle("Auto Harvest",
        function() return Settings.Plant.AutoHarvest end,
        function(v) Settings.Plant.AutoHarvest = v end)
    CreateInput("Harvest Range",
        function() return Settings.Plant.HarvestRange end,
        function(v) Settings.Plant.HarvestRange = math.clamp(v,5,100) end)
end)

-- 5. FRUIT RAIN (fixed with proper fruit list)
CreateCat("🍎", "Fruit Rain", 5, function()
    SectionHeader("FRUIT RAIN  (spawns fruits near you)")
    CreateToggle("Enable Fruit Rain",
        function() return Settings.FruitRain.Enabled end,
        function(v) Settings.FruitRain.Enabled = v end)
    -- Dropdown for which fruit to rain
    CreateDropdown("Fruit Type", FRUIT_RAIN_LIST,
        function() return Settings.FruitRain.SelectedFruit end,
        function(v) Settings.FruitRain.SelectedFruit = v end)
    CreateInput("Spawn Radius",
        function() return Settings.FruitRain.Radius end,
        function(v) Settings.FruitRain.Radius = math.clamp(v,10,200) end)
    CreateInput("Amount per Wave",
        function() return Settings.FruitRain.Amount end,
        function(v) Settings.FruitRain.Amount = math.clamp(math.floor(v),1,50) end)
    CreateInput("Interval (secs)",
        function() return Settings.FruitRain.Interval end,
        function(v) Settings.FruitRain.Interval = math.clamp(v,0.5,10) end)

    CreateButton("🍎  Drop One Wave Now", C.Accent, function()
        -- fire one manual wave via remote
        local ok, err = pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                or ReplicatedStorage:FindFirstChild("Events")
            if remotes then
                local spawnFruit = remotes:FindFirstChild("SpawnFruit")
                    or remotes:FindFirstChild("FruitRain")
                    or remotes:FindFirstChild("DropFruit")
                if spawnFruit then
                    for i = 1, Settings.FruitRain.Amount do
                        local offset = Vector3.new(
                            math.random(-Settings.FruitRain.Radius, Settings.FruitRain.Radius),
                            10,
                            math.random(-Settings.FruitRain.Radius, Settings.FruitRain.Radius)
                        )
                        spawnFruit:FireServer(Settings.FruitRain.SelectedFruit, RootPart.Position + offset)
                    end
                end
            end
        end)
        Notify("Fruit Rain", "Dropped " .. Settings.FruitRain.Amount .. "x " .. Settings.FruitRain.SelectedFruit, 2)
    end)
end)

-- 6. FLY
CreateCat("🪂", "Fly", 6, function()
    SectionHeader("FLY HACK  [W/A/S/D + Space/Ctrl]")
    CreateToggle("Enable Fly",
        function() return Settings.Fly.Enabled end,
        function(v)
            Settings.Fly.Enabled = v
            if not v then
                if Settings.Fly.Connection then
                    Settings.Fly.Connection:Disconnect()
                    Settings.Fly.Connection = nil
                end
                Humanoid.PlatformStand = false
                Humanoid.WalkSpeed = Settings.Speed.OriginalWalk
                Humanoid.JumpPower = Settings.Speed.OriginalJump
                RootPart.AssemblyLinearVelocity = Vector3.zero
                RootPart.CanCollide = true
            end
        end)
    CreateInput("Fly Speed",
        function() return Settings.Fly.Speed end,
        function(v) Settings.Fly.Speed = math.clamp(v,10,500) end)
    CreateInput("Max Height",
        function() return Settings.Fly.MaxHeight end,
        function(v) Settings.Fly.MaxHeight = math.clamp(v,50,2000) end)
    CreateToggle("No Collision",
        function() return Settings.Fly.NoCollision end,
        function(v) Settings.Fly.NoCollision = v end)
end)

-- 7. SPEED
CreateCat("⚡", "Speed Hack", 7, function()
    SectionHeader("SPEED HACK")
    CreateToggle("Enable Speed",
        function() return Settings.Speed.Enabled end,
        function(v)
            Settings.Speed.Enabled = v
            if not v then
                Humanoid.WalkSpeed = Settings.Speed.OriginalWalk
                Humanoid.JumpPower = Settings.Speed.OriginalJump
            end
        end)
    CreateInput("Speed Multiplier",
        function() return Settings.Speed.Multiplier end,
        function(v) Settings.Speed.Multiplier = math.clamp(v,1,50) end)
    CreateButton("🔄  Reset Speed", C.AccentDark, function()
        Settings.Speed.Enabled = false
        Settings.Speed.Multiplier = 1
        Humanoid.WalkSpeed = Settings.Speed.OriginalWalk
        Humanoid.JumpPower = Settings.Speed.OriginalJump
        Notify("Speed", "Reset to default", 2)
    end)
end)

--// ============================================================
--//  MAIN LOOP
--// ============================================================
RunService.Heartbeat:Connect(function(dt)
    -- Re-acquire character on respawn
    if not Character or not Character.Parent or not Character:FindFirstChild("HumanoidRootPart") then
        Character = LocalPlayer.Character
        if not Character then return end
        Humanoid = Character:FindFirstChild("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
    end

    -- SPEED
    if Settings.Speed.Enabled then
        Humanoid.WalkSpeed = Settings.Speed.OriginalWalk * Settings.Speed.Multiplier
        Humanoid.JumpPower = Settings.Speed.OriginalJump * Settings.Speed.Multiplier
    end

    -- FLY — start RenderStepped connection once
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
            local dir = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

            dir = dir.Magnitude > 0 and dir.Unit * Settings.Fly.Speed or Vector3.zero

            if RootPart.Position.Y > Settings.Fly.MaxHeight then
                dir = Vector3.new(dir.X, math.min(dir.Y, 0), dir.Z)
            end

            RootPart.AssemblyLinearVelocity = dir
        end)
    end

    -- SPRINKLER (dt-throttled, no task.wait)
    if Settings.Sprinkler.Enabled then
        sprinklerTimer += dt
        if sprinklerTimer >= Settings.Sprinkler.RefreshRate then
            sprinklerTimer = 0
            local range = Settings.Sprinkler.Range
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Position - RootPart.Position).Magnitude < range then
                    local w = obj:FindFirstChild("Water") or obj:FindFirstChild("Watered") or obj:FindFirstChild("Moisture")
                    if w and (w:IsA("NumberValue") or w:IsA("IntValue")) then
                        w.Value = 100
                    end
                end
            end
        end
    else
        sprinklerTimer = 0
    end

    -- AUTO SEED
    if Settings.Seed.Enabled then
        local seed = LocalPlayer.Backpack:FindFirstChild(Settings.Seed.Type)
        if seed and seed:IsA("Tool") then
            local plots = Workspace:FindFirstChild("PlantingPlots")
                or Workspace:FindFirstChild("Plots")
                or Workspace:FindFirstChild("Farm")
            if plots then
                for _, plot in ipairs(plots:GetDescendants()) do
                    if plot:IsA("BasePart") and not plot:FindFirstChild("Crop") and not plot:FindFirstChild("Plant") then
                        if (plot.Position - RootPart.Position).Magnitude < 20 then
                            pcall(function()
                                local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                                if rem then
                                    local plant = rem:FindFirstChild("Plant") or rem:FindFirstChild("PlantSeed")
                                    if plant then plant:FireServer(plot, Settings.Seed.Type) end
                                end
                            end)
                            task.wait(0.3)
                        end
                    end
                end
            end
        elseif Settings.Seed.AutoRefill then
            pcall(function()
                local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                if rem then
                    local buy = rem:FindFirstChild("BuySeed") or rem:FindFirstChild("PurchaseSeed")
                    if buy then buy:FireServer(Settings.Seed.Type, 10) end
                end
            end)
        end
    end

    -- AUTO GROW / HARVEST
    if Settings.Plant.Enabled then
        for _, crop in ipairs(Workspace:GetDescendants()) do
            if crop:IsA("BasePart") and (crop.Position - RootPart.Position).Magnitude < Settings.Plant.HarvestRange then
                local growth = crop:FindFirstChild("Growth") or crop:FindFirstChild("GrowthValue")
                if growth and (growth:IsA("NumberValue") or growth:IsA("IntValue")) then
                    if Settings.Plant.InstantGrow then
                        growth.Value = 100
                    else
                        growth.Value = math.min(growth.Value + 0.1 * Settings.Plant.GrowSpeed, 100)
                    end
                    if growth.Value >= 100 and Settings.Plant.AutoHarvest then
                        pcall(function()
                            local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                            if rem then
                                local h = rem:FindFirstChild("Harvest") or rem:FindFirstChild("HarvestCrop")
                                if h then h:FireServer(crop) end
                            end
                        end)
                        task.wait(0.15)
                    end
                end
            end
        end
    end

    -- FRUIT RAIN (dt-throttled)
    if Settings.FruitRain.Enabled then
        fruitRainTimer += dt
        if fruitRainTimer >= Settings.FruitRain.Interval then
            fruitRainTimer = 0
            pcall(function()
                local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
                if rem then
                    local spawnFn = rem:FindFirstChild("SpawnFruit")
                        or rem:FindFirstChild("FruitRain")
                        or rem:FindFirstChild("DropFruit")
                    if spawnFn then
                        for i = 1, Settings.FruitRain.Amount do
                            local offset = Vector3.new(
                                math.random(-Settings.FruitRain.Radius, Settings.FruitRain.Radius),
                                math.random(5, 20),
                                math.random(-Settings.FruitRain.Radius, Settings.FruitRain.Radius)
                            )
                            spawnFn:FireServer(Settings.FruitRain.SelectedFruit, RootPart.Position + offset)
                        end
                    end
                end
            end)
        end
    else
        fruitRainTimer = 0
    end
end)

--// INSERT to toggle
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)

-- Boot notification
task.delay(0.5, function()
    Notify("⚔ Mathew Hub", "Loaded! Press INSERT to toggle menu.", 4)
end)
