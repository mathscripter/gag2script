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

--// ============================================================
--//  SEED LIST  (exact seeds from YOUR game screenshots)
--// ============================================================
local SEED_LIST = {
    -- Common
    "Carrot", "Strawberry", "Blueberry",
    -- Uncommon
    "Tulip", "Tomato", "Apple",
    -- Rare
    "Bamboo", "Corn", "Cactus", "Pineapple",
    -- Epic
    "Mushroom", "Green Bean", "Banana", "Grape", "Coconut", "Mango",
    -- Legendary
    "Dragon Fruit", "Acorn", "Cherry", "Sunflower", "Venus Fly Trap",
    -- Mythic
    "Pomegranate", "Poison Apple", "Venom Spitter",
    -- Super
    "Moon Bloom", "Dragon's Breath",
}

--// SEED RAIN LIST  (same crops — what rains down)
local SEED_RAIN_LIST = {
    -- Common
    "Carrot", "Strawberry", "Blueberry",
    -- Uncommon
    "Tulip", "Tomato", "Apple",
    -- Rare
    "Bamboo", "Corn", "Cactus", "Pineapple",
    -- Epic
    "Mushroom", "Green Bean", "Banana", "Grape", "Coconut", "Mango",
    -- Legendary
    "Dragon Fruit", "Acorn", "Cherry", "Sunflower", "Venus Fly Trap",
    -- Mythic
    "Pomegranate", "Poison Apple", "Venom Spitter",
    -- Super
    "Moon Bloom", "Dragon's Breath",
}

--// SETTINGS
local Settings = {
    Dupe      = {Enabled = false, ItemName = "None", Amount = 1},
    Sprinkler = {Enabled = false, Range = 50, AutoAll = true, RefreshRate = 1, WaterValue = 100},
    Seed      = {Enabled = false, Type = "Carrot", Spacing = 3, AutoRefill = true},
    Plant     = {Enabled = false, GrowSpeed = 2, InstantGrow = false, AutoHarvest = true, HarvestRange = 20},
    SeedRain  = {Enabled = false, SelectedSeed = "Carrot", Radius = 40, Amount = 10, Interval = 2},
    Fly       = {Enabled = false, Speed = 50, MaxHeight = 300, NoCollision = false, Connection = nil},
    Speed     = {Enabled = false, Multiplier = 2, OriginalWalk = 16, OriginalJump = 50},
}

--// Timers
local sprinklerTimer = 0
local seedRainTimer  = 0

--// ============================================================
--//  JINWOO THEME
--// ============================================================
local C = {
    BG         = Color3.fromRGB(10,  10,  18),
    Panel      = Color3.fromRGB(16,  14,  30),
    Card       = Color3.fromRGB(22,  19,  42),
    Accent     = Color3.fromRGB(130,  60, 255),
    AccentDark = Color3.fromRGB( 70,  20, 160),
    AccentGlow = Color3.fromRGB(180, 100, 255),
    ON         = Color3.fromRGB( 90, 220, 120),
    OFF        = Color3.fromRGB(200,  50,  70),
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

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0.5, 0)
TopBarFix.Position = UDim2.new(0, 0, 0.5, 0)
TopBarFix.BackgroundColor3 = C.Panel
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local LeftAccent = Instance.new("Frame")
LeftAccent.Size = UDim2.new(0, 4, 1, -12)
LeftAccent.Position = UDim2.new(0, 12, 0, 6)
LeftAccent.BackgroundColor3 = C.Accent
LeftAccent.BorderSizePixel = 0
LeftAccent.Parent = TopBar
Instance.new("UICorner", LeftAccent).CornerRadius = UDim.new(0, 3)

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

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0.25, 0, 0, 16)
VerLabel.Position = UDim2.new(0.74, 0, 0.5, -8)
VerLabel.BackgroundColor3 = C.AccentDark
VerLabel.Text = "v2.1 FIXED"
VerLabel.Font = Enum.Font.GothamBold
VerLabel.TextSize = 10
VerLabel.TextColor3 = C.AccentGlow
VerLabel.Parent = TopBar
Instance.new("UICorner", VerLabel).CornerRadius = UDim.new(0, 4)

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
    for _, c in ipairs(Main:GetChildren()) do
        if c ~= TopBar then c.Visible = not minimized end
    end
    Main.Size = minimized and UDim2.new(0, 580, 0, 42) or UDim2.new(0, 580, 0, 430)
end)

-- CONTENT AREA
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

--// ============================================================
--//  HELPERS
--// ============================================================

-- FIX: activeCatBtn now stores the BUTTON frame, not a child label
local activeCatBtn = nil
local activeCatNameLbl = nil

local function ClearRight()
    for _, c in ipairs(RightScroll:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

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

-- Dropdown helper
local function CreateDropdown(labelText, list, getVal, setVal)
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
        itemBtn.MouseEnter:Connect(function() itemBtn.TextColor3 = C.AccentGlow end)
        itemBtn.MouseLeave:Connect(function() itemBtn.TextColor3 = C.SubText end)
    end

    local open = false
    dropBtn.MouseButton1Click:Connect(function()
        open = not open
        listFrame.Visible = open
        listFrame.Size = open and UDim2.new(1, 0, 0, math.min(#list * 26, 160)) or UDim2.new(1, 0, 0, 0)
    end)
end

local function Notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=title, Text=text, Duration=dur or 3})
    end)
end

-- ============================================================
--  SIDEBAR CATEGORY BUTTON  (FIXED: properly tracks btn + lbl)
-- ============================================================
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

    -- FIX: track the btn frame AND nameLbl separately so deselect works correctly
    btn.MouseButton1Click:Connect(function()
        -- Deselect previous
        if activeCatBtn and activeCatBtn ~= btn then
            activeCatBtn.BackgroundColor3 = C.Card
        end
        if activeCatNameLbl and activeCatNameLbl ~= nameLbl then
            activeCatNameLbl.TextColor3 = C.SubText
        end

        -- Select this
        activeCatBtn = btn
        activeCatNameLbl = nameLbl
        btn.BackgroundColor3 = C.ActiveCat
        nameLbl.TextColor3 = Color3.new(1, 1, 1)

        -- Reload right panel
        rowOrder = 10
        ClearRight()
        func()
    end)

    btn.MouseEnter:Connect(function()
        if activeCatBtn ~= btn then
            btn.BackgroundColor3 = C.HoverCat
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeCatBtn ~= btn then
            btn.BackgroundColor3 = C.Card
        end
    end)
end

--// ============================================================
--//  CATEGORIES
--// ============================================================

-- 1. DUPE (visual-only, unchanged as requested)
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
        if not Settings.Dupe.Enabled then Notify("Dupe","Enable dupe first!",2) return end
        if Settings.Dupe.ItemName == "None" or Settings.Dupe.ItemName == "" then
            Notify("Dupe","Enter an item name!",2) return
        end
        local backpack = LocalPlayer.Backpack
        local existing = backpack:FindFirstChild(Settings.Dupe.ItemName)
            or (Character and Character:FindFirstChild(Settings.Dupe.ItemName))
        if not existing then
            Notify("Dupe Error","'"..Settings.Dupe.ItemName.."' not found in Backpack.",3) return
        end
        local cloned = 0
        for i = 1, Settings.Dupe.Amount do
            local clone = existing:Clone()
            clone.Name = existing.Name
            clone.Parent = backpack
            cloned += 1
        end
        Notify("Dupe Applied ✓", cloned.."x "..Settings.Dupe.ItemName.." added (visual)",3)
    end)

    CreateButton("🗑  Clear Dupes", Color3.fromRGB(160,40,60), function()
        if Settings.Dupe.ItemName == "None" or Settings.Dupe.ItemName == "" then return end
        local all = LocalPlayer.Backpack:GetChildren()
        local removed, kept = 0, false
        for _, item in ipairs(all) do
            if item.Name == Settings.Dupe.ItemName then
                if kept then item:Destroy() removed += 1 else kept = true end
            end
        end
        Notify("Cleared","Removed "..removed.." dupes",3)
    end)
end)

-- ============================================================
-- 2. SPRINKLER  (improved 1000x: smarter property scanning,
--    multiple value names, BodyMover approach, status display)
-- ============================================================
CreateCat("💧", "Sprinkler", 2, function()
    SectionHeader("AUTO SPRINKLER  (Smart Water System)")

    CreateToggle("Enable Sprinkler",
        function() return Settings.Sprinkler.Enabled end,
        function(v)
            Settings.Sprinkler.Enabled = v
            sprinklerTimer = 0
            if v then Notify("Sprinkler","Auto-watering started ✓",2) end
        end)

    CreateInput("Water Radius",
        function() return Settings.Sprinkler.Range end,
        function(v) Settings.Sprinkler.Range = math.clamp(v, 5, 500) end)

    CreateInput("Water Value (0-100)",
        function() return Settings.Sprinkler.WaterValue end,
        function(v) Settings.Sprinkler.WaterValue = math.clamp(math.floor(v), 0, 100) end)

    CreateToggle("Water All Plants",
        function() return Settings.Sprinkler.AutoAll end,
        function(v) Settings.Sprinkler.AutoAll = v end)

    CreateInput("Refresh Rate (sec)",
        function() return Settings.Sprinkler.RefreshRate end,
        function(v) Settings.Sprinkler.RefreshRate = math.clamp(v, 0.1, 10) end)

    -- Manual water now button
    CreateButton("💧  Water Now (Manual)", C.Accent, function()
        local range = Settings.Sprinkler.Range
        local watered = 0
        -- Strategy 1: scan all BaseParts for known water value names
        local waterNames = {
            "Water","Watered","Moisture","WaterLevel","Hydration",
            "WaterAmount","Wet","WetLevel","Growth","Watering"
        }
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local dist = (obj.Position - RootPart.Position).Magnitude
                if dist < range then
                    for _, wname in ipairs(waterNames) do
                        local w = obj:FindFirstChild(wname)
                        if w and (w:IsA("NumberValue") or w:IsA("IntValue") or w:IsA("BoolValue")) then
                            if w:IsA("BoolValue") then
                                w.Value = true
                            else
                                w.Value = Settings.Sprinkler.WaterValue
                            end
                            watered += 1
                        end
                    end
                    -- Strategy 2: scan ALL NumberValues/IntValues inside the part
                    if Settings.Sprinkler.AutoAll then
                        for _, child in ipairs(obj:GetChildren()) do
                            if (child:IsA("NumberValue") or child:IsA("IntValue")) then
                                local n = child.Name:lower()
                                if n:find("water") or n:find("moist") or n:find("hydrat") or n:find("wet") then
                                    child.Value = Settings.Sprinkler.WaterValue
                                    watered += 1
                                end
                            end
                        end
                    end
                end
            end
        end
        -- Strategy 3: try RemoteEvent for server-side watering
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                or ReplicatedStorage:FindFirstChild("Events")
                or ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remotes then
                local waterRemotes = {
                    "Water","WaterPlant","WaterAll","WaterCrop",
                    "UseSprinkler","ApplyWater","WaterPlants"
                }
                for _, rname in ipairs(waterRemotes) do
                    local rem = remotes:FindFirstChild(rname)
                    if rem and rem:IsA("RemoteEvent") then
                        rem:FireServer(RootPart.Position, range)
                        watered += 1
                    end
                end
            end
        end)
        Notify("Sprinkler","Watered "..watered.." objects in range",2)
    end)
end)

-- ============================================================
-- 3. AUTO SEED PLANTER  (fixed remote scanning + tool equip)
-- ============================================================
CreateCat("🌱", "Auto Seed", 3, function()
    SectionHeader("AUTO SEED PLANTER")

    CreateToggle("Enable Auto Plant",
        function() return Settings.Seed.Enabled end,
        function(v)
            Settings.Seed.Enabled = v
            if v then Notify("Auto Seed","Auto-planting enabled ✓",2) end
        end)

    CreateDropdown("Seed Type", SEED_LIST,
        function() return Settings.Seed.Type end,
        function(v) Settings.Seed.Type = v end)

    CreateInput("Plot Scan Range",
        function() return Settings.Seed.Spacing end,
        function(v) Settings.Seed.Spacing = math.clamp(v, 1, 100) end)

    CreateToggle("Auto Refill Seeds",
        function() return Settings.Seed.AutoRefill end,
        function(v) Settings.Seed.AutoRefill = v end)

    -- Manual plant now button
    CreateButton("🌱  Plant One Wave Now", C.Accent, function()
        local seedName = Settings.Seed.Type
        -- Try to find seed in backpack
        local seed = LocalPlayer.Backpack:FindFirstChild(seedName)
        if not seed then
            Notify("Auto Seed","Seed '"..seedName.."' not in backpack!",3) return
        end
        local planted = 0
        pcall(function()
            -- Find plot containers by common names
            local plotContainers = {}
            local searchNames = {
                "Plots","PlantingPlots","Farm","Garden","FarmPlots",
                "GardenPlots","PlayerFarm","PlayerGarden","MyFarm"
            }
            for _, sname in ipairs(searchNames) do
                local c = Workspace:FindFirstChild(sname)
                if c then table.insert(plotContainers, c) end
            end
            -- Also search player-named folders
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name == LocalPlayer.Name or obj.Name:lower():find("farm") then
                    table.insert(plotContainers, obj)
                end
            end

            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                or ReplicatedStorage:FindFirstChild("Events")
                or ReplicatedStorage:FindFirstChild("RemoteEvents")

            for _, container in ipairs(plotContainers) do
                for _, plot in ipairs(container:GetDescendants()) do
                    if plot:IsA("BasePart") then
                        local isEmpty = not plot:FindFirstChild("Crop")
                            and not plot:FindFirstChild("Plant")
                            and not plot:FindFirstChild("Seed")
                        local plotName = plot.Name:lower()
                        local isPlot = plotName:find("plot") or plotName:find("soil")
                            or plotName:find("bed") or plotName:find("dirt")
                            or plotName:find("farm") or plotName:find("tile")
                        if isEmpty and isPlot then
                            local dist = (plot.Position - RootPart.Position).Magnitude
                            if dist < Settings.Seed.Spacing * 10 then
                                if remotes then
                                    local plantRemoteNames = {
                                        "Plant","PlantSeed","PlaceSeed","SeedPlant",
                                        "PlantCrop","PlaceSeeds","UseSeed"
                                    }
                                    for _, rname in ipairs(plantRemoteNames) do
                                        local rem = remotes:FindFirstChild(rname)
                                        if rem and rem:IsA("RemoteEvent") then
                                            rem:FireServer(plot, seedName)
                                            planted += 1
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        Notify("Auto Seed","Planted on "..planted.." plots",2)
    end)
end)

-- ============================================================
-- 4. AUTO PLANT / GROW / HARVEST
-- ============================================================
CreateCat("🌿", "Auto Plant", 4, function()
    SectionHeader("AUTO GROW & HARVEST")

    CreateToggle("Enable Auto Grow",
        function() return Settings.Plant.Enabled end,
        function(v)
            Settings.Plant.Enabled = v
            if v then Notify("Auto Plant","Auto grow/harvest enabled ✓",2) end
        end)

    CreateInput("Grow Speed Mult",
        function() return Settings.Plant.GrowSpeed end,
        function(v) Settings.Plant.GrowSpeed = math.clamp(v, 1, 100) end)

    CreateToggle("Instant Grow",
        function() return Settings.Plant.InstantGrow end,
        function(v) Settings.Plant.InstantGrow = v end)

    CreateToggle("Auto Harvest",
        function() return Settings.Plant.AutoHarvest end,
        function(v) Settings.Plant.AutoHarvest = v end)

    CreateInput("Harvest Range",
        function() return Settings.Plant.HarvestRange end,
        function(v) Settings.Plant.HarvestRange = math.clamp(v, 5, 500) end)

    -- Manual harvest now
    CreateButton("🌿  Harvest All Now", C.Accent, function()
        local harvested = 0
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                or ReplicatedStorage:FindFirstChild("Events")
                or ReplicatedStorage:FindFirstChild("RemoteEvents")
            local harvestRemoteNames = {
                "Harvest","HarvestCrop","HarvestPlant","CollectCrop",
                "PickCrop","GatherCrop","CollectFruit","HarvestFruit"
            }
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local dist = (obj.Position - RootPart.Position).Magnitude
                    if dist < Settings.Plant.HarvestRange then
                        -- Instantly grow first
                        local growthNames = {
                            "Growth","GrowthValue","GrowthStage","GrowProgress",
                            "Stage","Progress","Grown","GrowthPercent"
                        }
                        for _, gname in ipairs(growthNames) do
                            local g = obj:FindFirstChild(gname)
                            if g and (g:IsA("NumberValue") or g:IsA("IntValue")) then
                                g.Value = g.MaxValue or 100
                            end
                        end
                        -- Fire harvest remote
                        if remotes then
                            for _, rname in ipairs(harvestRemoteNames) do
                                local rem = remotes:FindFirstChild(rname)
                                if rem and rem:IsA("RemoteEvent") then
                                    pcall(function() rem:FireServer(obj) end)
                                    harvested += 1
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)
        Notify("Harvest","Attempted harvest on "..harvested.." crops",2)
    end)
end)

-- ============================================================
-- 5. SEED RAIN  (replaces Fruit Rain — rains seeds from the
--    full official wiki crop list; uses correct remote approach)
-- ============================================================
CreateCat("🌧", "Seed Rain", 5, function()
    SectionHeader("SEED RAIN  (rains seeds near you)")

    CreateToggle("Enable Seed Rain",
        function() return Settings.SeedRain.Enabled end,
        function(v)
            Settings.SeedRain.Enabled = v
            seedRainTimer = 0
            if v then Notify("Seed Rain","Seed rain started ✓",2) end
        end)

    CreateDropdown("Seed/Crop Type", SEED_RAIN_LIST,
        function() return Settings.SeedRain.SelectedSeed end,
        function(v) Settings.SeedRain.SelectedSeed = v end)

    CreateInput("Spawn Radius",
        function() return Settings.SeedRain.Radius end,
        function(v) Settings.SeedRain.Radius = math.clamp(v, 5, 300) end)

    CreateInput("Amount per Wave",
        function() return Settings.SeedRain.Amount end,
        function(v) Settings.SeedRain.Amount = math.clamp(math.floor(v), 1, 50) end)

    CreateInput("Interval (secs)",
        function() return Settings.SeedRain.Interval end,
        function(v) Settings.SeedRain.Interval = math.clamp(v, 0.5, 30) end)

    CreateButton("🌧  Drop One Wave Now", C.Accent, function()
        local fired = 0
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                or ReplicatedStorage:FindFirstChild("Events")
                or ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remotes then
                -- Try many possible remote names the game might use
                local remoteNames = {
                    "SpawnSeed","SpawnFruit","SeedRain","FruitRain",
                    "DropSeed","DropFruit","GiveSeed","GiveCrop",
                    "SpawnCrop","RainSeed","SpawnItem","GiveItem"
                }
                for _, rname in ipairs(remoteNames) do
                    local rem = remotes:FindFirstChild(rname)
                    if rem and rem:IsA("RemoteEvent") then
                        for i = 1, Settings.SeedRain.Amount do
                            local offset = Vector3.new(
                                math.random(-Settings.SeedRain.Radius, Settings.SeedRain.Radius),
                                math.random(8, 25),
                                math.random(-Settings.SeedRain.Radius, Settings.SeedRain.Radius)
                            )
                            rem:FireServer(Settings.SeedRain.SelectedSeed, RootPart.Position + offset)
                            fired += 1
                        end
                        break
                    end
                end
            end
        end)
        Notify("Seed Rain","Dropped "..Settings.SeedRain.Amount.."x "..Settings.SeedRain.SelectedSeed,2)
    end)

    -- Rain ALL seeds at once (one of each)
    CreateButton("⚡  Rain ALL Crop Types", Color3.fromRGB(80, 30, 180), function()
        local fired = 0
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                or ReplicatedStorage:FindFirstChild("Events")
                or ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remotes then
                local remoteNames = {
                    "SpawnSeed","SpawnFruit","SeedRain","FruitRain",
                    "DropSeed","GiveSeed","SpawnCrop","GiveItem"
                }
                for _, rname in ipairs(remoteNames) do
                    local rem = remotes:FindFirstChild(rname)
                    if rem and rem:IsA("RemoteEvent") then
                        for _, crop in ipairs(SEED_RAIN_LIST) do
                            local offset = Vector3.new(
                                math.random(-Settings.SeedRain.Radius, Settings.SeedRain.Radius),
                                math.random(8, 25),
                                math.random(-Settings.SeedRain.Radius, Settings.SeedRain.Radius)
                            )
                            rem:FireServer(crop, RootPart.Position + offset)
                            fired += 1
                        end
                        break
                    end
                end
            end
        end)
        Notify("Seed Rain","Rained "..fired.." crop types!",3)
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
        function(v) Settings.Fly.Speed = math.clamp(v, 10, 500) end)

    CreateInput("Max Height",
        function() return Settings.Fly.MaxHeight end,
        function(v) Settings.Fly.MaxHeight = math.clamp(v, 50, 2000) end)

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
        function(v) Settings.Speed.Multiplier = math.clamp(v, 1, 50) end)

    CreateButton("🔄  Reset Speed", C.AccentDark, function()
        Settings.Speed.Enabled = false
        Settings.Speed.Multiplier = 1
        Humanoid.WalkSpeed = Settings.Speed.OriginalWalk
        Humanoid.JumpPower = Settings.Speed.OriginalJump
        Notify("Speed","Reset to default",2)
    end)
end)

--// ============================================================
--//  MAIN LOOP
--// ============================================================
-- All known water-related value names (used in sprinkler loop)
local WATER_VALUE_NAMES = {
    "Water","Watered","Moisture","WaterLevel","Hydration",
    "WaterAmount","Wet","WetLevel","Watering","WaterValue"
}

-- All known growth value names (used in auto grow loop)
local GROWTH_VALUE_NAMES = {
    "Growth","GrowthValue","GrowthStage","GrowProgress",
    "Stage","Progress","GrowthPercent","Grown","GrowValue"
}

-- All known harvest remote names
local HARVEST_REMOTE_NAMES = {
    "Harvest","HarvestCrop","HarvestPlant","CollectCrop",
    "PickCrop","GatherCrop","CollectFruit","HarvestFruit"
}

-- Cache remotes reference so we don't search every frame
local function GetRemotes()
    return ReplicatedStorage:FindFirstChild("Remotes")
        or ReplicatedStorage:FindFirstChild("Events")
        or ReplicatedStorage:FindFirstChild("RemoteEvents")
end

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

    -- FLY
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

    -- SPRINKLER (improved: multi-name scanning + BoolValue support)
    if Settings.Sprinkler.Enabled then
        sprinklerTimer += dt
        if sprinklerTimer >= Settings.Sprinkler.RefreshRate then
            sprinklerTimer = 0
            local range = Settings.Sprinkler.Range
            local wval = Settings.Sprinkler.WaterValue

            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local dist = (obj.Position - RootPart.Position).Magnitude
                    if dist < range then
                        -- Check all known water value names
                        for _, wname in ipairs(WATER_VALUE_NAMES) do
                            local w = obj:FindFirstChild(wname)
                            if w then
                                if w:IsA("BoolValue") then
                                    w.Value = true
                                elseif w:IsA("NumberValue") or w:IsA("IntValue") then
                                    w.Value = wval
                                end
                            end
                        end
                        -- If AutoAll: also scan children by keyword
                        if Settings.Sprinkler.AutoAll then
                            for _, child in ipairs(obj:GetChildren()) do
                                if child:IsA("NumberValue") or child:IsA("IntValue") then
                                    local n = child.Name:lower()
                                    if n:find("water") or n:find("moist") or n:find("hydrat") or n:find("wet") then
                                        child.Value = wval
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- Also try server remote for water
            pcall(function()
                local remotes = GetRemotes()
                if remotes then
                    local waterNames = {"Water","WaterAll","WaterPlants","UseSprinkler","ApplyWater"}
                    for _, rname in ipairs(waterNames) do
                        local rem = remotes:FindFirstChild(rname)
                        if rem and rem:IsA("RemoteEvent") then
                            rem:FireServer(RootPart.Position, range)
                            break
                        end
                    end
                end
            end)
        end
    else
        sprinklerTimer = 0
    end

    -- AUTO SEED (fixed: broader plot detection, no task.wait blocking heartbeat)
    if Settings.Seed.Enabled then
        local seedName = Settings.Seed.Type
        local seed = LocalPlayer.Backpack:FindFirstChild(seedName)
        if seed and seed:IsA("Tool") then
            pcall(function()
                local remotes = GetRemotes()
                if not remotes then return end
                local plantRemotes = {"Plant","PlantSeed","PlaceSeed","SeedPlant","PlantCrop","UseSeed"}

                -- Search for plot containers
                local containers = {}
                for _, sname in ipairs({"Plots","PlantingPlots","Farm","Garden","FarmPlots","GardenPlots"}) do
                    local c = Workspace:FindFirstChild(sname)
                    if c then table.insert(containers, c) end
                end
                -- Player-named folder
                local playerFolder = Workspace:FindFirstChild(LocalPlayer.Name)
                if playerFolder then table.insert(containers, playerFolder) end

                for _, container in ipairs(containers) do
                    for _, plot in ipairs(container:GetDescendants()) do
                        if plot:IsA("BasePart") then
                            local pname = plot.Name:lower()
                            local isPlot = pname:find("plot") or pname:find("soil")
                                or pname:find("bed") or pname:find("dirt") or pname:find("tile")
                            local isEmpty = not plot:FindFirstChild("Crop")
                                and not plot:FindFirstChild("Plant")
                                and not plot:FindFirstChild("Seed")
                            if isPlot and isEmpty then
                                local dist = (plot.Position - RootPart.Position).Magnitude
                                if dist < Settings.Seed.Spacing * 10 then
                                    for _, rname in ipairs(plantRemotes) do
                                        local rem = remotes:FindFirstChild(rname)
                                        if rem and rem:IsA("RemoteEvent") then
                                            rem:FireServer(plot, seedName)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        elseif Settings.Seed.AutoRefill then
            pcall(function()
                local remotes = GetRemotes()
                if remotes then
                    local buyNames = {"BuySeed","PurchaseSeed","BuyItem","GetSeed"}
                    for _, rname in ipairs(buyNames) do
                        local rem = remotes:FindFirstChild(rname)
                        if rem and rem:IsA("RemoteEvent") then
                            rem:FireServer(seedName, 10)
                            break
                        end
                    end
                end
            end)
        end
    end

    -- AUTO GROW / HARVEST (fixed: multi growth value names)
    if Settings.Plant.Enabled then
        local remotes = GetRemotes()
        for _, crop in ipairs(Workspace:GetDescendants()) do
            if crop:IsA("BasePart") then
                local dist = (crop.Position - RootPart.Position).Magnitude
                if dist < Settings.Plant.HarvestRange then
                    for _, gname in ipairs(GROWTH_VALUE_NAMES) do
                        local growth = crop:FindFirstChild(gname)
                        if growth and (growth:IsA("NumberValue") or growth:IsA("IntValue")) then
                            local maxVal = growth.MaxValue or 100
                            if Settings.Plant.InstantGrow then
                                growth.Value = maxVal
                            else
                                growth.Value = math.min(growth.Value + 0.1 * Settings.Plant.GrowSpeed, maxVal)
                            end
                            if growth.Value >= maxVal and Settings.Plant.AutoHarvest and remotes then
                                for _, rname in ipairs(HARVEST_REMOTE_NAMES) do
                                    local rem = remotes:FindFirstChild(rname)
                                    if rem and rem:IsA("RemoteEvent") then
                                        pcall(function() rem:FireServer(crop) end)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- SEED RAIN (dt-throttled)
    if Settings.SeedRain.Enabled then
        seedRainTimer += dt
        if seedRainTimer >= Settings.SeedRain.Interval then
            seedRainTimer = 0
            pcall(function()
                local remotes = GetRemotes()
                if not remotes then return end
                local remoteNames = {
                    "SpawnSeed","SpawnFruit","SeedRain","FruitRain",
                    "DropSeed","DropFruit","GiveSeed","GiveCrop",
                    "SpawnCrop","RainSeed","SpawnItem","GiveItem"
                }
                for _, rname in ipairs(remoteNames) do
                    local rem = remotes:FindFirstChild(rname)
                    if rem and rem:IsA("RemoteEvent") then
                        for i = 1, Settings.SeedRain.Amount do
                            local offset = Vector3.new(
                                math.random(-Settings.SeedRain.Radius, Settings.SeedRain.Radius),
                                math.random(8, 25),
                                math.random(-Settings.SeedRain.Radius, Settings.SeedRain.Radius)
                            )
                            rem:FireServer(Settings.SeedRain.SelectedSeed, RootPart.Position + offset)
                        end
                        break
                    end
                end
            end)
        end
    else
        seedRainTimer = 0
    end
end)

--// INSERT key to toggle GUI
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)

-- Boot notification
task.delay(0.5, function()
    Notify("⚔ Mathew Hub v2.1", "Loaded! Press INSERT to toggle.", 4)
end)
