--// SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

--// PLAYER
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// REMOTE
local remoteFunction = ReplicatedStorage.Remotes.OpenCase

--// CONFIG
local config = {
    autoOpenEnabled = false,
    levelCasesEnabled = false,
    selectedAutoOpen = "Free",
    autoOpenAmount = 5,
    normalCaseCooldown = 1,
    levelCases = {},
}

--// INIT LEVEL CASES
local idx = 0
for i = 10,120,10 do
    config.levelCases["LEVEL"..i] = {
        enabled = false,
        lastOpened = 0,
        firstOpen = false,
        level = i,
        initialDelay = idx * 6,
        regularCooldown = 120
    }
    idx += 1
end

local scriptStart = 0
local loopRunning = false

--// OPEN CASE
local function openCase(caseType, amount)
    local ok, res = pcall(function()
        return remoteFunction:InvokeServer(caseType, amount, false, false)
    end)
    return ok
end

--// LEVEL CASE CHECK
local function handleLevelCases()
    if not config.levelCasesEnabled then return false end

    local now = tick()
    local elapsed = now - scriptStart
    local toOpen = {}

    for name,data in pairs(config.levelCases) do
        if data.enabled then
            if not data.firstOpen and elapsed >= data.initialDelay then
                table.insert(toOpen,name)
            elseif data.firstOpen and now - data.lastOpened >= data.regularCooldown then
                table.insert(toOpen,name)
            end
        end
    end

    if #toOpen > 0 then
        task.wait(6)
        for _,lvl in ipairs(toOpen) do
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

    local gui = Instance.new("ScreenGui")
    gui.Name = "CaseOpenerGUI"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false

    local blur = Instance.new("BlurEffect")
    blur.Size = 18
    blur.Parent = Lighting

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(740,470)
    main.Position = UDim2.fromScale(0.5,0.5)
    main.AnchorPoint = Vector2.new(0.5,0.5)
    main.BackgroundColor3 = Color3.fromRGB(20,20,28)
    main.BackgroundTransparency = 0.25
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner",main).CornerRadius = UDim.new(0,22)

    -- TITLE
    local title = Instance.new("TextLabel",main)
    title.Size = UDim2.new(1,-20,0,40)
    title.Position = UDim2.fromOffset(20,10)
    title.BackgroundTransparency = 1
    title.Text = "GITY.CC | CASE PARADISE"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextXAlignment = Left
    title.TextColor3 = Color3.new(1,1,1)

    -- SIDEBAR
    local sidebar = Instance.new("Frame",main)
    sidebar.Size = UDim2.fromOffset(90,360)
    sidebar.Position = UDim2.fromOffset(20,70)
    sidebar.BackgroundColor3 = Color3.fromRGB(25,25,35)
    sidebar.BackgroundTransparency = 0.3
    Instance.new("UICorner",sidebar).CornerRadius = UDim.new(0,18)

    local list = Instance.new("UIListLayout",sidebar)
    list.Padding = UDim.new(0,12)
    list.HorizontalAlignment = Center
    list.VerticalAlignment = Center

    -- CONTENT
    local content = Instance.new("Frame",main)
    content.Size = UDim2.new(1,-130,1,-90)
    content.Position = UDim2.fromOffset(120,70)
    content.BackgroundTransparency = 1

    local pages = {}
    local function page()
        local f = Instance.new("Frame",content)
        f.Size = UDim2.fromScale(1,1)
        f.BackgroundTransparency = 1
        f.Visible = false
        return f
    end

    pages.MAIN = page()
    pages.LEVELS = page()
    pages.INFO = page()
    pages.MAIN.Visible = true

    local function tab(icon,page)
        local b = Instance.new("ImageButton",sidebar)
        b.Size = UDim2.fromOffset(56,56)
        b.BackgroundColor3 = Color3.fromRGB(40,40,55)
        b.BackgroundTransparency = 0.25
        b.Image = icon
        Instance.new("UICorner",b).CornerRadius = UDim.new(1,0)

        b.MouseButton1Click:Connect(function()
            for _,p in pairs(pages) do p.Visible = false end
            page.Visible = true
        end)
    end

    tab("rbxassetid://7734053495", pages.MAIN)
    tab("rbxassetid://7733960981", pages.LEVELS)
    tab("rbxassetid://7734056608", pages.INFO)

    -- MAIN CONTENT
    local toggle = Instance.new("TextButton",pages.MAIN)
    toggle.Size = UDim2.fromOffset(240,44)
    toggle.Position = UDim2.fromOffset(20,20)
    toggle.Text = "AUTO OPEN"
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    toggle.BackgroundColor3 = Color3.fromRGB(0,200,150)
    toggle.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,12)

    toggle.MouseButton1Click:Connect(function()
        config.autoOpenEnabled = not config.autoOpenEnabled
        if config.autoOpenEnabled then
            task.spawn(mainLoop)
        else
            loopRunning = false
        end
    end)

    -- INFO
    local info = Instance.new("TextLabel",pages.INFO)
    info.Size = UDim2.fromOffset(300,60)
    info.Position = UDim2.fromOffset(20,20)
    info.BackgroundTransparency = 1
    info.Text = "author: komandos30"
    info.Font = Enum.Font.GothamBold
    info.TextSize = 16
    info.TextColor3 = Color3.fromRGB(220,220,220)
    info.TextXAlignment = Left

    local discord = Instance.new("TextButton",pages.INFO)
    discord.Size = UDim2.fromOffset(260,44)
    discord.Position = UDim2.fromOffset(20,90)
    discord.Text = "JOIN DISCORD"
    discord.Font = Enum.Font.GothamBold
    discord.TextSize = 14
    discord.BackgroundColor3 = Color3.fromRGB(88,101,242)
    discord.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",discord).CornerRadius = UDim.new(0,12)

    discord.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("https://discord.gg/zp5NKyJqMA")
        end)
    end)
end

createGUI()
