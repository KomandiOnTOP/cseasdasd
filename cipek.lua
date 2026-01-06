-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Player
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- References
local remoteFunction = ReplicatedStorage.Remotes.OpenCase

-- Configuration
local config = {
    autoOpenEnabled = false,
    levelCasesEnabled = false, -- Master toggle for all level cases
    selectedAutoOpen = "Free", -- "Free", "Group", "VIP", or "MILSPEC"
    autoOpenAmount = 5, -- Back to 5 for normal cases
    normalCaseCooldown = 1, -- 1 second between normal case batches
    levelCases = {},
    levelCaseDelay = 6 -- 6 seconds between each level case opening
}

-- Initialize level cases (10 to 120, every 10 levels)
local levelIndex = 0
for i = 10, 120, 10 do
    config.levelCases["LEVEL" .. i] = {
        enabled = false,
        lastOpened = 0,
        firstOpen = false,
        level = i,
        initialDelay = levelIndex * 6, -- 0s, 6s, 12s, 18s, 24s, etc.
        regularCooldown = 120 -- 120 seconds (2 minutes) for all level cases
    }
    levelIndex = levelIndex + 1
end

-- Statistics
local stats = {
    Free = {opened = 0, errors = 0},
    Group = {opened = 0, errors = 0},
    VIP = {opened = 0, errors = 0},
    MILSPEC = {opened = 0, errors = 0}
}

for level, _ in pairs(config.levelCases) do
    stats[level] = {opened = 0, errors = 0}
end

local scriptStartTime = 0
local loopRunning = false

-- Function to open a case
local function openCase(caseType, amount)
    local success, result = pcall(function()
        return remoteFunction:InvokeServer(caseType, amount, false, false)
    end)
    
    if success then
        stats[caseType].opened = stats[caseType].opened + 1
        if amount > 1 then
            print("[" .. caseType .. "] Batch #" .. stats[caseType].opened .. " opened (" .. amount .. " cases)")
        else
            print("[" .. caseType .. "] Case #" .. stats[caseType].opened .. " opened")
        end
        
        if result and type(result) == "table" then
            for _, item in ipairs(result[1] or result) do
                if type(item) == "table" then
                    local stattrakText = item.Stattrak and " (StatTrak)" or ""
                    print("  - " .. item.Item .. " | " .. item.Wear .. stattrakText)
                end
            end
        end
    else
        stats[caseType].errors = stats[caseType].errors + 1
        warn("[" .. caseType .. "] Error: " .. tostring(result))
    end
    
    return success
end

-- Function to check and open ALL ready level cases
local function checkAndOpenAllLevelCases()
    -- Check if level cases are globally enabled
    if not config.levelCasesEnabled then
        return false
    end
    
    local currentTime = tick()
    local timeSinceStart = currentTime - scriptStartTime
    
    -- Sort level cases by level number
    local sortedCases = {}
    for caseName, caseData in pairs(config.levelCases) do
        if caseData.enabled then
            table.insert(sortedCases, {name = caseName, data = caseData})
        end
    end
    
    table.sort(sortedCases, function(a, b)
        return a.data.level < b.data.level
    end)
    
    -- Collect all level cases that are ready to open
    local casesToOpen = {}
    for _, caseInfo in ipairs(sortedCases) do
        local caseName = caseInfo.name
        local caseData = caseInfo.data
        
        -- First opening: check if initial delay has passed
        if not caseData.firstOpen then
            if timeSinceStart >= caseData.initialDelay then
                table.insert(casesToOpen, {name = caseName, data = caseData, isFirst = true})
            end
        -- Subsequent openings: check regular cooldown (2 minutes)
        else
            if currentTime - caseData.lastOpened >= caseData.regularCooldown then
                table.insert(casesToOpen, {name = caseName, data = caseData, isFirst = false})
            end
        end
    end
    
    -- If there are cases to open, open them all with delays
    if #casesToOpen > 0 then
        print("\n[PAUSE] Pausing normal cases for 6s before opening level cases...")
        task.wait(6) -- 6s pause BEFORE opening level cases
        
        print("[LEVEL CASES] Opening " .. #casesToOpen .. " level case(s)...")
        
        for i, caseToOpen in ipairs(casesToOpen) do
            local caseName = caseToOpen.name
            local caseData = caseToOpen.data
            local isFirst = caseToOpen.isFirst
            
            if isFirst then
                print("[LEVEL CASE - FIRST] Opening " .. caseName .. " (after " .. caseData.initialDelay .. "s)...")
            else
                print("[LEVEL CASE] Opening " .. caseName .. " (cooldown: " .. caseData.regularCooldown .. "s / 2 minutes)...")
            end
            
            openCase(caseName, 1) -- Level cases always open 1 at a time
            caseData.lastOpened = currentTime
            caseData.firstOpen = true
            
            -- Wait 6 seconds between each level case (except after the last one)
            if i < #casesToOpen then
                task.wait(6)
            end
        end
        
        print("[PAUSE] Waiting 6s after opening level cases before resuming normal cases...")
        task.wait(6) -- 6s pause AFTER opening all level cases
        
        return true
    end
    
    return false
end

-- Main loop function
local function mainLoop()
    loopRunning = true
    scriptStartTime = tick() -- Reset start time when loop starts
    print("Auto-opener started!")
    print("Script start time: " .. scriptStartTime)
    print("Opening " .. config.autoOpenAmount .. " normal cases at a time with " .. config.normalCaseCooldown .. "s cooldown")
    
    while config.autoOpenEnabled and loopRunning do
        -- Check if any level cases need to be opened
        local levelCasesOpened = checkAndOpenAllLevelCases()
        
        if not levelCasesOpened then
            -- No level cases to open, proceed with normal auto-open (5 at a time)
            openCase(config.selectedAutoOpen, config.autoOpenAmount)
            task.wait(config.normalCaseCooldown) -- Wait cooldown between normal cases
        end
    end
    
    loopRunning = false
    print("Auto-opener stopped!")
end

-- Create GUI
local function createGUI()
    -- Check if GUI already exists
    if CoreGui:FindFirstChild("CaseOpenerGUI") or playerGui:FindFirstChild("CaseOpenerGUI") then
        print("GUI already exists!")
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CaseOpenerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    title.BorderSizePixel = 0
    title.Text = "Case Auto-Opener"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = mainFrame
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Scroll Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -60)
    scrollFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = mainFrame
    
    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scrollFrame
    
    -- Auto-Open Section
    local autoOpenSection = Instance.new("Frame")
    autoOpenSection.Name = "AutoOpenSection"
    autoOpenSection.Size = UDim2.new(1, 0, 0, 190)
    autoOpenSection.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    autoOpenSection.BorderSizePixel = 0
    autoOpenSection.LayoutOrder = 1
    autoOpenSection.Parent = scrollFrame
    
    local autoOpenCorner = Instance.new("UICorner")
    autoOpenCorner.CornerRadius = UDim.new(0, 8)
    autoOpenCorner.Parent = autoOpenSection
    
    local autoOpenTitle = Instance.new("TextLabel")
    autoOpenTitle.Size = UDim2.new(1, -20, 0, 30)
    autoOpenTitle.Position = UDim2.new(0, 10, 0, 5)
    autoOpenTitle.BackgroundTransparency = 1
    autoOpenTitle.Text = "Auto-Open Settings"
    autoOpenTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoOpenTitle.Font = Enum.Font.GothamBold
    autoOpenTitle.TextSize = 16
    autoOpenTitle.TextXAlignment = Enum.TextXAlignment.Left
    autoOpenTitle.Parent = autoOpenSection
    
    -- Auto-Open Toggle
    local autoOpenToggle = Instance.new("TextButton")
    autoOpenToggle.Name = "AutoOpenToggle"
    autoOpenToggle.Size = UDim2.new(0, 80, 0, 30)
    autoOpenToggle.Position = UDim2.new(0, 10, 0, 40)
    autoOpenToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    autoOpenToggle.Text = "OFF"
    autoOpenToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoOpenToggle.Font = Enum.Font.GothamBold
    autoOpenToggle.TextSize = 14
    autoOpenToggle.Parent = autoOpenSection
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = autoOpenToggle
    
    autoOpenToggle.MouseButton1Click:Connect(function()
        config.autoOpenEnabled = not config.autoOpenEnabled
        
        if config.autoOpenEnabled then
            autoOpenToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            autoOpenToggle.Text = "ON"
            
            -- Reset firstOpen flags when starting
            for _, caseData in pairs(config.levelCases) do
                caseData.firstOpen = false
                caseData.lastOpened = 0
            end
            
            task.spawn(mainLoop)
        else
            autoOpenToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            autoOpenToggle.Text = "OFF"
            loopRunning = false
        end
    end)
    
    -- Case Type Selection (now includes MILSPEC)
    local caseTypes = {"Free", "Group", "VIP", "MILSPEC"}
    for i, caseType in ipairs(caseTypes) do
        local row = math.floor((i - 1) / 2)
        local col = (i - 1) % 2
        
        local caseBtn = Instance.new("TextButton")
        caseBtn.Size = UDim2.new(0, 100, 0, 30)
        caseBtn.Position = UDim2.new(0, 10 + col * 110, 0, 80 + row * 40)
        caseBtn.BackgroundColor3 = config.selectedAutoOpen == caseType and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(60, 60, 65)
        caseBtn.Text = caseType
        caseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        caseBtn.Font = Enum.Font.Gotham
        caseBtn.TextSize = 14
        caseBtn.Parent = autoOpenSection
        
        local caseBtnCorner = Instance.new("UICorner")
        caseBtnCorner.CornerRadius = UDim.new(0, 6)
        caseBtnCorner.Parent = caseBtn
        
        caseBtn.MouseButton1Click:Connect(function()
            config.selectedAutoOpen = caseType
            
            -- Update all buttons
            for _, child in pairs(autoOpenSection:GetChildren()) do
                if child:IsA("TextButton") and child.Name ~= "AutoOpenToggle" then
                    local childText = child.Text
                    if childText == config.selectedAutoOpen then
                        child.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                    else
                        child.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
                    end
                end
            end
        end)
    end
    
    -- Amount info
    local amountLabel = Instance.new("TextLabel")
    amountLabel.Size = UDim2.new(1, -20, 0, 20)
    amountLabel.Position = UDim2.new(0, 10, 0, 160)
    amountLabel.BackgroundTransparency = 1
    amountLabel.Text = "Opening 5 cases per batch (1s cooldown)"
    amountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    amountLabel.Font = Enum.Font.Gotham
    amountLabel.TextSize = 12
    amountLabel.TextXAlignment = Enum.TextXAlignment.Left
    amountLabel.Parent = autoOpenSection
    
    -- Level Cases Section
    local levelSection = Instance.new("Frame")
    levelSection.Name = "LevelSection"
    levelSection.Size = UDim2.new(1, 0, 0, 0)
    levelSection.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    levelSection.BorderSizePixel = 0
    levelSection.LayoutOrder = 2
    levelSection.AutomaticSize = Enum.AutomaticSize.Y
    levelSection.Parent = scrollFrame
    
    local levelCorner = Instance.new("UICorner")
    levelCorner.CornerRadius = UDim.new(0, 8)
    levelCorner.Parent = levelSection
    
    -- Level Cases Header Frame
    local levelHeader = Instance.new("Frame")
    levelHeader.Name = "LevelHeader"
    levelHeader.Size = UDim2.new(1, -20, 0, 40)
    levelHeader.Position = UDim2.new(0, 10, 0, 5)
    levelHeader.BackgroundTransparency = 1
    levelHeader.Parent = levelSection
    
    local levelTitle = Instance.new("TextLabel")
    levelTitle.Size = UDim2.new(0, 250, 1, 0)
    levelTitle.Position = UDim2.new(0, 0, 0, 0)
    levelTitle.BackgroundTransparency = 1
    levelTitle.Text = "Level Cases (2min cd, 6s delay)"
    levelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelTitle.Font = Enum.Font.GothamBold
    levelTitle.TextSize = 16
    levelTitle.TextXAlignment = Enum.TextXAlignment.Left
    levelTitle.Parent = levelHeader
    
    -- Master Level Cases Toggle
    local levelMasterToggle = Instance.new("TextButton")
    levelMasterToggle.Name = "LevelMasterToggle"
    levelMasterToggle.Size = UDim2.new(0, 100, 0, 30)
    levelMasterToggle.Position = UDim2.new(1, -100, 0, 5)
    levelMasterToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    levelMasterToggle.Text = "All: OFF"
    levelMasterToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelMasterToggle.Font = Enum.Font.GothamBold
    levelMasterToggle.TextSize = 14
    levelMasterToggle.Parent = levelHeader
    
    local levelMasterCorner = Instance.new("UICorner")
    levelMasterCorner.CornerRadius = UDim.new(0, 6)
    levelMasterCorner.Parent = levelMasterToggle
    
    levelMasterToggle.MouseButton1Click:Connect(function()
        config.levelCasesEnabled = not config.levelCasesEnabled
        
        if config.levelCasesEnabled then
            levelMasterToggle.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            levelMasterToggle.Text = "All: ON"
        else
            levelMasterToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            levelMasterToggle.Text = "All: OFF"
        end
    end)
    
    -- Level cases grid
    local levelGrid = Instance.new("Frame")
    levelGrid.Name = "LevelGrid"
    levelGrid.Size = UDim2.new(1, -20, 0, 0)
    levelGrid.Position = UDim2.new(0, 10, 0, 50)
    levelGrid.BackgroundTransparency = 1
    levelGrid.AutomaticSize = Enum.AutomaticSize.Y
    levelGrid.Parent = levelSection
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 100, 0, 35)
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = levelGrid
    
    -- Create level case toggles IN ORDER (10-120)
    for level = 10, 120, 10 do
        local levelName = "LEVEL" .. level
        local levelBtn = Instance.new("TextButton")
        levelBtn.Name = levelName
        levelBtn.LayoutOrder = level -- This ensures proper ordering
        levelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        levelBtn.Text = "L" .. level .. ": OFF"
        levelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        levelBtn.Font = Enum.Font.Gotham
        levelBtn.TextSize = 12
        levelBtn.Parent = levelGrid
        
        local levelBtnCorner = Instance.new("UICorner")
        levelBtnCorner.CornerRadius = UDim.new(0, 6)
        levelBtnCorner.Parent = levelBtn
        
        levelBtn.MouseButton1Click:Connect(function()
            config.levelCases[levelName].enabled = not config.levelCases[levelName].enabled
            
            if config.levelCases[levelName].enabled then
                levelBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                levelBtn.Text = "L" .. level .. ": ON"
            else
                levelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                levelBtn.Text = "L" .. level .. ": OFF"
            end
        end)
    end
    
    -- Update level section size
    task.wait(0.1) -- Wait for layout to calculate
    levelSection.Size = UDim2.new(1, 0, 0, 60 + gridLayout.AbsoluteContentSize.Y)
    
    -- Parent to PlayerGui or CoreGui
    pcall(function()
        screenGui.Parent = CoreGui
    end)
    
    if not screenGui.Parent then
        screenGui.Parent = playerGui
    end
    
    print("GUI Created Successfully!")
end

-- Create the GUI
createGUI()
