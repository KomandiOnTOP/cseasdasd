--// SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--// PLAYER
local player = Players.LocalPlayer

--// REMOTE
local remoteFunction = ReplicatedStorage.Remotes.OpenCase

--// CONFIG
local config = {
    autoOpenEnabled = false,
    levelCasesEnabled = false,
    selectedAutoOpen = "Free",
    autoOpenAmount = 5,
    normalCaseCooldown = 1,
    levelCases = {}
}

--// INIT LEVEL CASES
local index = 0
for i = 10,120,10 do
    config.levelCases["LEVEL"..i] = {
        enabled = false,
        lastOpened = 0,
        firstOpen = false,
        level = i,
        initialDelay = index * 6,
        regularCooldown = 120
    }
    index += 1
end

local scriptStart = 0
local loopRunning = false

--// OPEN CASE
local function openCase(caseType, amount)
    pcall(function()
        remoteFunction:InvokeServer(caseType, amount, false, false)
    end)
end

--// LEVEL CASE HANDLER
local function handleLevelCases()
    if not config.levelCasesEnabled then return false end
    local now = tick()
    local elapsed = now - scriptStart
    local queue = {}

    for name,data in pairs(config.levelCases) do
        if data.enabled then
            if not data.firstOpen and elapsed >= data.initialDelay then
                table.insert(queue,name)
            elseif data.firstOpen and now - data.lastOpened >= data.regularCooldown then
                table.insert(queue,name)
            end
        end
    end

    if #queue > 0 then
        task.wait(6)
        for _,lvl in ipairs(queue) do
            openCase(lvl,1)
            config.levelCases[lvl].lastOpened = tick()
            config.levelCases[lvl].firstOpen = true
            task.wait(6)
        end
        task.wait(6)
        return true
    end
    return false
end

--// MAIN LOOP
local function mainLoop()
    loopRunning = true
    scriptStart = tick()
    while config.autoOpenEnabled and loopRunning do
        if not handleLevelCases() then
            openCase(config.selectedAutoOpen, config.autoOpenAmount)
            task.wait(config.normalCaseCooldown)
        end
    end
end

--// GUI
local function createGUI()
    if CoreGui:FindFirstChild("CaseOpenerGUI") then return end

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "CaseOpenerGUI"
    gui.ResetOnSpawn = false

    -- MAIN
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(760,480)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Color3.fromRGB(20,20,28)
    main.BackgroundTransparency = 0.25
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,22)

    -- GLASS BLUR (UI ONLY)
    local blur = Instance.new("ImageLabel", main)
    blur.Size = UDim2.fromScale(1,1)
    blur.BackgroundTransparency = 1
    blur.Image = "rbxassetid://8992230677"
    blur.ImageTransparency = 0.65
    blur.ScaleType = Enum.ScaleType.Slice
    blur.SliceCenter = Rect.new(99,99,99,99)
    Instance.new("UICorner", blur).CornerRadius = UDim.new(0,22)

    local contentRoot = Instance.new("Frame", main)
    contentRoot.Size = UDim2.fromScale(1,1)
    contentRoot.BackgroundTransparency = 1
    contentRoot.ZIndex = 2

    -- TITLE
    local title = Instance.new("TextLabel", contentRoot)
    title.Size = UDim2.new(1,-20,0,40)
    title.Position = UDim2.fromOffset(20,10)
    title.BackgroundTransparency = 1
    title.Text = "GITY.CC | CASE PARADISE"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextXAlignment = Left
    title.TextColor3 = Color3.new(1,1,1)

    -- SIDEBAR (CATEGORIES)
    local sidebar = Instance.new("Frame", contentRoot)
    sidebar.Size = UDim2.fromOffset(150,360)
    sidebar.Position = UDim2.fromOffset(20,70)
    sidebar.BackgroundColor3 = Color3.fromRGB(30,30,40)
    sidebar.BackgroundTransparency = 0.35
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,18)

    local sideLayout = Instance.new("UIListLayout", sidebar)
    sideLayout.Padding = UDim.new(0,10)
    sideLayout.HorizontalAlignment = Center
    sideLayout.VerticalAlignment = Top

    -- CONTENT AREA
    local content = Instance.new("Frame", contentRoot)
    content.Size = UDim2.new(1,-190,1,-90)
    content.Position = UDim2.fromOffset(180,70)
    content.BackgroundTransparency = 1

    local pages = {}
    local function newPage()
        local f = Instance.new("Frame", content)
        f.Size = UDim2.fromScale(1,1)
        f.Visible = false
        f.BackgroundTransparency = 1
        return f
    end

    pages.MAIN = newPage()
    pages.LEVELS = newPage()
    pages.INFO = newPage()
    pages.MAIN.Visible = true

    -- CATEGORY BUTTON
    local function categoryButton(text, icon, page)
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1,-20,0,44)
        btn.Text = "  "..text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextXAlignment = Left
        btn.BackgroundColor3 = Color3.fromRGB(45,45,60)
        btn.BackgroundTransparency = 0.2
        btn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

        local img = Instance.new("ImageLabel", btn)
        img.Size = UDim2.fromOffset(20,20)
        img.Position = UDim2.fromOffset(12,12)
        img.BackgroundTransparency = 1
        img.Image = icon

        btn.MouseButton1Click:Connect(function()
            for _,p in pairs(pages) do p.Visible = false end
            page.Visible = true
        end)
    end

    categoryButton("MAIN",   "rbxassetid://7734053495", pages.MAIN)
    categoryButton("LEVELS", "rbxassetid://7733960981", pages.LEVELS)
    categoryButton("INFO",   "rbxassetid://7734056608", pages.INFO)

    -- MAIN CONTENT
    local autoBtn = Instance.new("TextButton", pages.MAIN)
    autoBtn.Size = UDim2.fromOffset(260,44)
    autoBtn.Position = UDim2.fromOffset(20,20)
    autoBtn.Text = "AUTO OPEN"
    autoBtn.Font = Enum.Font.GothamBold
    autoBtn.TextSize = 14
    autoBtn.BackgroundColor3 = Color3.fromRGB(0,200,150)
    autoBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,12)

    autoBtn.MouseButton1Click:Connect(function()
        config.autoOpenEnabled = not config.autoOpenEnabled
        if config.autoOpenEnabled then
            task.spawn(mainLoop)
        else
            loopRunning = false
        end
    end)

    -- LEVELS CONTENT
    local lvlLayout = Instance.new("UIListLayout", pages.LEVELS)
    lvlLayout.Padding = UDim.new(0,8)

    for name,data in pairs(config.levelCases) do
        local b = Instance.new("TextButton", pages.LEVELS)
        b.Size = UDim2.new(0,260,0,38)
        b.Text = name
        b.Font = Enum.Font.GothamBold
        b.TextSize = 13
        b.BackgroundColor3 = Color3.fromRGB(60,60,80)
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)

        b.MouseButton1Click:Connect(function()
            data.enabled = not data.enabled
            config.levelCasesEnabled = true
            b.BackgroundColor3 = data.enabled and Color3.fromRGB(0,170,120) or Color3.fromRGB(60,60,80)
        end)
    end

    -- INFO CONTENT
    local info = Instance.new("TextLabel", pages.INFO)
    info.Size = UDim2.fromOffset(300,40)
    info.Position = UDim2.fromOffset(20,20)
    info.BackgroundTransparency = 1
    info.Text = "author: komandos30"
    info.Font = Enum.Font.GothamBold
    info.TextSize = 16
    info.TextColor3 = Color3.fromRGB(220,220,220)
    info.TextXAlignment = Left

    local discord = Instance.new("TextButton", pages.INFO)
    discord.Size = UDim2.fromOffset(260,44)
    discord.Position = UDim2.fromOffset(20,80)
    discord.Text = "JOIN DISCORD"
    discord.Font = Enum.Font.GothamBold
