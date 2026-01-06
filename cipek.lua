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
    levelCasesEnabled = false,
    selectedAutoOpen = "Free",
    autoOpenAmount = 5,
    normalCaseCooldown = 1,
    levelCases = {},
    levelCaseDelay = 6
}

-- Initialize level cases
local levelIndex = 0
for i = 10, 120, 10 do
    config.levelCases["LEVEL" .. i] = {
        enabled = false,
        lastOpened = 0,
        firstOpen = false,
        level = i,
        initialDelay = levelIndex * 6,
        regularCooldown = 120
    }
    levelIndex = levelIndex + 1
end

-- Statistics
local stats = {
    Free = {opened = 0, errors = 0},
    Group = {opened = 0, errors = 0},
    VIP = {opened = 0, errors = 0},
    Military = {opened = 0, errors = 0}
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
    if not config.levelCasesEnabled then
        return false
    end
    
    local currentTime = tick()
    local timeSinceStart = currentTime - scriptStartTime
    
    local sortedCases = {}
    for caseName, caseData in pairs(config.levelCases) do
        if caseData.enabled then
            table.insert(sortedCases, {name = caseName, data = caseData})
        end
    end
    
    table.sort(sortedCases, function(a, b)
        return a.data.level < b.data.level
    end)
    
    local casesToOpen = {}
    for _, caseInfo in ipairs(sortedCases) do
        local caseName = caseInfo.name
        local caseData = caseInfo.data
        
        if not caseData.firstOpen then
            if timeSinceStart >= caseData.initialDelay then
                table.insert(casesToOpen, {name = caseName, data = caseData, isFirst = true})
            end
        else
            if currentTime - caseData.lastOpened >= caseData.regularCooldown then
                table.insert(casesToOpen, {name = caseName, data = caseData, isFirst = false})
            end
        end
    end
    
    if #casesToOpen > 0 then
        print("\n[PAUSE] Pausing normal cases for 6s before opening level cases...")
        task.wait(6)
        
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
            
            openCase(caseName, 1)
            caseData.lastOpened = currentTime
            caseData.firstOpen = true
            
            if i < #casesToOpen then
                task.wait(6)
            end
        end
        
        print("[PAUSE] Waiting 6s after opening level cases before resuming normal cases...")
        task.wait(6)
        
        return true
    end
    
    return false
end

-- Main loop function
local function mainLoop()
    loopRunning = true
    scriptStartTime = tick()
    print("Auto-opener started!")
    print("Script start time: " .. scriptStartTime)
    print("Opening " .. config.autoOpenAmount .. " normal cases at a time with " .. config.normalCaseCooldown .. "s cooldown")
    
    while config.autoOpenEnabled and loopRunning do
        local levelCasesOpened = checkAndOpenAllLevelCases()
        
        if not levelCasesOpened then
            openCase(config.selectedAutoOpen, config.autoOpenAmount)
            task.wait(config.normalCaseCooldown)
        end
    end
    
    loopRunning = false
    print("Auto-opener stopped!")
end

-- Create GUI
local function createGUI()
    if CoreGui:FindFirstChild("CaseOpenerGUI") or playerGui:FindFirstChild("CaseOpenerGUI") then
        print("GUI already exists!")
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CaseOpenerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Blur Background
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 15
    blurEffect.Parent = game.Lighting
    
    -- Main Container (Glass effect)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Glass border glow
    local glowBorder = Instance.new("UIStroke")
    glowBorder.Color = Color3.fromRGB(255, 255, 255)
    glowBorder.Thickness = 2
    glowBorder.Transparency = 0.4
    glowBorder.Parent = mainFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame
    
    -- Inner glow effect
    local innerGlow = Instance.new("Frame")
    innerGlow.Size = UDim2.new(1, -4, 1, -4)
    innerGlow.Position = UDim2.new(0, 2, 0, 2)
    innerGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    innerGlow.BackgroundTransparency = 0.95
    innerGlow.BorderSizePixel = 0
    innerGlow.ZIndex = 0
    innerGlow.Parent = mainFrame
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(0, 14)
    innerCorner.Parent = innerGlow
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = titleBar
    
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(255, 255, 255)
    titleStroke.Thickness = 1
    titleStroke.Transparency = 0.7
    titleStroke.Parent = titleBar
    
    -- Title Text
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "GITY.CC | CASE PARADISE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 0.8
    title.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 7.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    local closeBtnStroke = Instance.new("UIStroke")
    closeBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    closeBtnStroke.Thickness = 1
    closeBtnStroke.Transparency = 0.5
    closeBtnStroke.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        blurEffect:Destroy()
        screenGui:Destroy()
    end)
    
    -- Left Sidebar (Category Menu)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 150, 1, -60)
    sidebar.Position = UDim2.new(0, 10, 0, 55)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    sidebar.BackgroundTransparency = 0.3
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent = sidebar
    
    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Color = Color3.fromRGB(255, 255, 255)
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = 0.6
    sidebarStroke.Parent = sidebar
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 8)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.PaddingBottom = UDim.new(0, 10)
    sidebarPadding.Parent = sidebar
    
    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -180, 1, -60)
    contentArea.Position = UDim2.new(0, 170, 0, 55)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    -- Category buttons data with icons
    local categories = {
        {name = "AUTO-OPEN", icon = "🎯", order = 1},
        {name = "LEVEL CASES", icon = "⭐", order = 2},
        {name = "INFO", icon = "ℹ️", order = 3}
    }
    
    local currentCategory = "AUTO-OPEN"
    local categoryButtons = {}
    
    -- Function to create category button
    local function createCategoryButton(categoryData)
        local btn = Instance.new("TextButton")
        btn.Name = categoryData.name
        btn.Size = UDim2.new(1, -20, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.BackgroundTransparency = 0.3
        btn.Text = categoryData.icon .. " " .. categoryData.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.LayoutOrder = categoryData.order
        btn.Parent = sidebar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(255, 255, 255)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.7
        btnStroke.Parent = btn
        
        categoryButtons[categoryData.name] = {button = btn, stroke = btnStroke}
        
        btn.MouseButton1Click:Connect(function()
            currentCategory = categoryData.name
            
            -- Update all buttons
            for name, data in pairs(categoryButtons) do
                if name == currentCategory then
                    data.button.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
                    data.button.BackgroundTransparency = 0.2
                    data.stroke.Transparency = 0.3
                else
                    data.button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                    data.button.BackgroundTransparency = 0.3
                    data.stroke.Transparency = 0.7
                end
            end
            
            -- Show/hide content
            for _, child in pairs(contentArea:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = (child.Name == currentCategory)
                end
            end
        end)
        
        return btn
    end
    
    -- Create category buttons
    for _, categoryData in ipairs(categories) do
        createCategoryButton(categoryData)
    end
    
    -- Set initial active category
    categoryButtons["AUTO-OPEN"].button.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    categoryButtons["AUTO-OPEN"].button.BackgroundTransparency = 0.2
    categoryButtons["AUTO-OPEN"].stroke.Transparency = 0.3
    
    -- AUTO-OPEN Content
    local autoOpenContent = Instance.new("Frame")
    autoOpenContent.Name = "AUTO-OPEN"
    autoOpenContent.Size = UDim2.new(1, 0, 1, 0)
    autoOpenContent.BackgroundTransparency = 1
    autoOpenContent.Parent = contentArea
    
    local autoOpenScroll = Instance.new("ScrollingFrame")
    autoOpenScroll.Size = UDim2.new(1, -10, 1, 0)
    autoOpenScroll.BackgroundTransparency = 1
    autoOpenScroll.BorderSizePixel = 0
    autoOpenScroll.ScrollBarThickness = 4
    autoOpenScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    autoOpenScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    autoOpenScroll.Parent = autoOpenContent
    
    local autoLayout = Instance.new("UIListLayout")
    autoLayout.Padding = UDim.new(0, 15)
    autoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    autoLayout.Parent = autoOpenScroll
    
    -- Toggle Section
    local toggleSection = Instance.new("Frame")
    toggleSection.Size = UDim2.new(1, 0, 0, 80)
    toggleSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleSection.BackgroundTransparency = 0.3
    toggleSection.BorderSizePixel = 0
    toggleSection.Parent = autoOpenScroll
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleSection
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(255, 255, 255)
    toggleStroke.Thickness = 1
    toggleStroke.Transparency = 0.6
    toggleStroke.Parent = toggleSection
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -20, 0, 30)
    toggleLabel.Position = UDim2.new(0, 10, 0, 10)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Auto-Opener Status"
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleSection
    
    local autoOpenToggle = Instance.new("TextButton")
    autoOpenToggle.Size = UDim2.new(0, 120, 0, 35)
    autoOpenToggle.Position = UDim2.new(0, 10, 0, 40)
    autoOpenToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    autoOpenToggle.BackgroundTransparency = 0.2
    autoOpenToggle.Text = "🔴 OFFLINE"
    autoOpenToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoOpenToggle.Font = Enum.Font.GothamBold
    autoOpenToggle.TextSize = 14
    autoOpenToggle.Parent = toggleSection
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 10)
    toggleBtnCorner.Parent = autoOpenToggle
    
    local toggleBtnStroke = Instance.new("UIStroke")
    toggleBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    toggleBtnStroke.Thickness = 1
    toggleBtnStroke.Transparency = 0.5
    toggleBtnStroke.Parent = autoOpenToggle
    
    autoOpenToggle.MouseButton1Click:Connect(function()
        config.autoOpenEnabled = not config.autoOpenEnabled
        
        if config.autoOpenEnabled then
            autoOpenToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
            autoOpenToggle.Text = "🟢 ONLINE"
            
            for _, caseData in pairs(config.levelCases) do
                caseData.firstOpen = false
                caseData.lastOpened = 0
            end
            
            task.spawn(mainLoop)
        else
            autoOpenToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            autoOpenToggle.Text = "🔴 OFFLINE"
            loopRunning = false
        end
    end)
    
    -- Case Selection Section
    local caseSection = Instance.new("Frame")
    caseSection.Size = UDim2.new(1, 0, 0, 150)
    caseSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    caseSection.BackgroundTransparency = 0.3
    caseSection.BorderSizePixel = 0
    caseSection.Parent = autoOpenScroll
    
    local caseCorner = Instance.new("UICorner")
    caseCorner.CornerRadius = UDim.new(0, 12)
    caseCorner.Parent = caseSection
    
    local caseStroke = Instance.new("UIStroke")
    caseStroke.Color = Color3.fromRGB(255, 255, 255)
    caseStroke.Thickness = 1
    caseStroke.Transparency = 0.6
    caseStroke.Parent = caseSection
    
    local caseLabel = Instance.new("TextLabel")
    caseLabel.Size = UDim2.new(1, -20, 0, 30)
    caseLabel.Position = UDim2.new(0, 10, 0, 10)
    caseLabel.BackgroundTransparency = 1
    caseLabel.Text = "Select Case Type"
    caseLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    caseLabel.Font = Enum.Font.Gotham
    caseLabel.TextSize = 14
    caseLabel.TextXAlignment = Enum.TextXAlignment.Left
    caseLabel.Parent = caseSection
    
    local caseTypes = {
        {name = "Free", icon = "🎁"},
        {name = "Group", icon = "👥"},
        {name = "VIP", icon = "⭐"},
        {name = "Military", icon = "🎖️"}
    }
    
    local caseButtons = {}
    
    for i, caseType in ipairs(caseTypes) do
        local row = math.floor((i - 1) / 2)
        local col = (i - 1) % 2
        
        local caseBtn = Instance.new("TextButton")
        caseBtn.Size = UDim2.new(0, 220, 0, 40)
        caseBtn.Position = UDim2.new(0, 10 + col * 230, 0, 50 + row * 50)
        caseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        caseBtn.BackgroundTransparency = 0.3
        caseBtn.Text = caseType.icon .. " " .. caseType.name
        caseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        caseBtn.Font = Enum.Font.GothamBold
        caseBtn.TextSize = 14
        caseBtn.Parent = caseSection
        
        local caseBtnCorner = Instance.new("UICorner")
        caseBtnCorner.CornerRadius = UDim.new(0, 10)
        caseBtnCorner.Parent = caseBtn
        
        local caseBtnStroke = Instance.new("UIStroke")
        caseBtnStroke.Color = Color3.fromRGB(255, 255, 255)
        caseBtnStroke.Thickness = 1
        caseBtnStroke.Transparency = 0.7
        caseBtnStroke.Parent = caseBtn
        
        caseButtons[caseType.name] = {button = caseBtn, stroke = caseBtnStroke}
        
        if caseType.name == config.selectedAutoOpen then
            caseBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
            caseBtn.BackgroundTransparency = 0.2
            caseBtnStroke.Transparency = 0.3
        end
        
        caseBtn.MouseButton1Click:Connect(function()
            config.selectedAutoOpen = caseType.name
            
            for name, data in pairs(caseButtons) do
                if name == config.selectedAutoOpen then
                    data.button.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
                    data.button.BackgroundTransparency = 0.2
                    data.stroke.Transparency = 0.3
                else
                    data.button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                    data.button.BackgroundTransparency = 0.3
                    data.stroke.Transparency = 0.7
                end
            end
        end)
    end
    
    -- Info Section
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0, 25)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "⚡ Opening 5 cases per batch • 1s cooldown"
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 12
    infoLabel.Parent = autoOpenScroll
    
    -- LEVEL CASES Content
    local levelContent = Instance.new("Frame")
    levelContent.Name = "LEVEL CASES"
    levelContent.Size = UDim2.new(1, 0, 1, 0)
    levelContent.BackgroundTransparency = 1
    levelContent.Visible = false
    levelContent.Parent = contentArea
    
    local levelScroll = Instance.new("ScrollingFrame")
    levelScroll.Size = UDim2.new(1, -10, 1, 0)
    levelScroll.BackgroundTransparency = 1
    levelScroll.BorderSizePixel = 0
    levelScroll.ScrollBarThickness = 4
    levelScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    levelScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    levelScroll.Parent = levelContent
    
    local levelLayout = Instance.new("UIListLayout")
    levelLayout.Padding = UDim.new(0, 15)
    levelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    levelLayout.Parent = levelScroll
    
    -- Level Master Toggle
    local levelMasterSection = Instance.new("Frame")
    levelMasterSection.Size = UDim2.new(1, 0, 0, 80)
    levelMasterSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    levelMasterSection.BackgroundTransparency = 0.3
    levelMasterSection.BorderSizePixel = 0
    levelMasterSection.Parent = levelScroll
    
    local levelMasterCorner = Instance.new("UICorner")
    levelMasterCorner.CornerRadius = UDim.new(0, 12)
    levelMasterCorner.Parent = levelMasterSection
    
    local levelMasterStroke = Instance.new("UIStroke")
    levelMasterStroke.Color = Color3.fromRGB(255, 255, 255)
    levelMasterStroke.Thickness = 1
    levelMasterStroke.Transparency = 0.6
    levelMasterStroke.Parent = levelMasterSection
    
    local levelMasterLabel = Instance.new("TextLabel")
    levelMasterLabel.Size = UDim2.new(1, -20, 0, 30)
    levelMasterLabel.Position = UDim2.new(0, 10, 0, 10)
    levelMasterLabel.BackgroundTransparency = 1
    levelMasterLabel.Text = "Master Control • 2 min cooldown • 6s delay"
    levelMasterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    levelMasterLabel.Font = Enum.Font.Gotham
    levelMasterLabel.TextSize = 14
    levelMasterLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelMasterLabel.Parent = levelMasterSection
    
    local levelMasterToggle = Instance.new("TextButton")
    levelMasterToggle.Size = UDim2.new(0, 140, 0, 35)
    levelMasterToggle.Position = UDim2.new(0, 10, 0, 40)
    levelMasterToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    levelMasterToggle.BackgroundTransparency = 0.2
    levelMasterToggle.Text = "ALL: OFF"
    levelMasterToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelMasterToggle.Font = Enum.Font.GothamBold
    levelMasterToggle.TextSize = 14
    levelMasterToggle.Parent = levelMasterSection
    
    local levelMasterBtnCorner = Instance.new("UICorner")
    levelMasterBtnCorner.CornerRadius = UDim.new(0, 10)
    levelMasterBtnCorner.Parent = levelMasterToggle
    
    local levelMasterBtnStroke = Instance.new("UIStroke")
    levelMasterBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    levelMasterBtnStroke.Thickness = 1
    levelMasterBtnStroke.Transparency = 0.5
    levelMasterBtnStroke.Parent = levelMasterToggle
    
    levelMasterToggle.MouseButton1Click:Connect(function()
        config.levelCasesEnabled = not config.levelCasesEnabled
        
        if config.levelCasesEnabled then
            levelMasterToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
            levelMasterToggle.Text = "ALL: ON"
        else
            levelMasterToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            levelMasterToggle.Text = "ALL: OFF"
        end
    end)
    
    -- Level Cases Grid
    local levelGridSection = Instance.new("Frame")
    levelGridSection.Size = UDim2.new(1, 0, 0, 0)
    levelGridSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    levelGridSection.BackgroundTransparency = 0.3
    levelGridSection.BorderSizePixel = 0
    levelGridSection.AutomaticSize = Enum.AutomaticSize.Y
    levelGridSection.Parent = levelScroll
    
    local levelGridCorner = Instance.new("UICorner")
    levelGridCorner.CornerRadius = UDim.new(0, 12)
    levelGridCorner.Parent = levelGridSection
    
    local levelGridStroke = Instance.new("UIStroke")
    levelGridStroke.Color = Color3.fromRGB(255, 255, 255)
    levelGridStroke.Thickness = 1
    levelGridStroke.Transparency = 0.6
    levelGridStroke.Parent = levelGridSection
    
    local levelGridPadding = Instance.new("UIPadding")
    levelGridPadding.PaddingTop = UDim.new(0, 10)
    levelGridPadding.PaddingBottom = UDim.new(0, 10)
    levelGridPadding.PaddingLeft = UDim.new(0, 10)
    levelGridPadding.PaddingRight = UDim.new(0, 10)
    levelGridPadding.Parent = levelGridSection
    
    local levelGrid = Instance.new("Frame")
    levelGrid.Size = UDim2.new(1, 0, 0, 0)
    levelGrid.BackgroundTransparency = 1
    levelGrid.AutomaticSize = Enum.AutomaticSize.Y
    levelGrid.Parent = levelGridSection
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 95, 0, 40)
    gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = levelGrid
    
    for level = 10, 120, 10 do
        local levelName = "LEVEL" .. level
        local levelBtn = Instance.new("TextButton")
        levelBtn.Name = levelName
        levelBtn.LayoutOrder = level
        levelBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        levelBtn.BackgroundTransparency = 0.2
        levelBtn.Text = "L" .. level
        levelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        levelBtn.Font = Enum.Font.GothamBold
        levelBtn.TextSize = 13
        levelBtn.Parent = levelGrid
        
        local levelBtnCorner = Instance.new("UICorner")
        levelBtnCorner.CornerRadius = UDim.new(0, 8)
        levelBtnCorner.Parent = levelBtn
        
        local levelBtnStroke = Instance.new("UIStroke")
        levelBtnStroke.Color = Color3.fromRGB(255, 255, 255)
        levelBtnStroke.Thickness = 1
        levelBtnStroke.Transparency = 0.5
        levelBtnStroke.Parent = levelBtn
        
        levelBtn.MouseButton1Click:Connect(function()
            config.levelCases[levelName].enabled = not config.levelCases[levelName].enabled
            
            if config.levelCases[levelName].enabled then
                levelBtn.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
                levelBtn.Text = "L" .. level .. " ✓"
            else
                levelBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
                levelBtn.Text = "L" .. level
            end
        end)
    end
    
    -- INFO Content
    local infoContent = Instance.new("Frame")
    infoContent.Name = "INFO"
    infoContent.Size = UDim2.new(1, 0, 1, 0)
    infoContent.BackgroundTransparency = 1
    infoContent.Visible = false
    infoContent.Parent = contentArea
    
    local infoScroll = Instance.new("ScrollingFrame")
    infoScroll.Size = UDim2.new(1, -10, 1, 0)
    infoScroll.BackgroundTransparency = 1
    infoScroll.BorderSizePixel = 0
    infoScroll.ScrollBarThickness = 4
    infoScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
    infoScroll.Parent = infoContent
    
    local infoLayout = Instance.new("UIListLayout")
    infoLayout.Padding = UDim.new(0, 15)
    infoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    infoLayout.Parent = infoScroll
    
    -- Author Section
    local authorSection = Instance.new("Frame")
    authorSection.Size = UDim2.new(1, 0, 0, 100)
    authorSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    authorSection.BackgroundTransparency = 0.3
    authorSection.BorderSizePixel = 0
    authorSection.Parent = infoScroll
    
    local authorCorner = Instance.new("UICorner")
    authorCorner.CornerRadius = UDim.new(0, 12)
    authorCorner.Parent = authorSection
    
    local authorStroke = Instance.new("UIStroke")
    authorStroke.Color = Color3.fromRGB(255, 255, 255)
    authorStroke.Thickness = 1
    authorStroke.Transparency = 0.6
    authorStroke.Parent = authorSection
    
    local authorLabel = Instance.new("TextLabel")
    authorLabel.Size = UDim2.new(1, -20, 0, 30)
    authorLabel.Position = UDim2.new(0, 10, 0, 15)
    authorLabel.BackgroundTransparency = 1
    authorLabel.Text = "👤 Script Information"
    authorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    authorLabel.Font = Enum.Font.GothamBold
    authorLabel.TextSize = 16
    authorLabel.TextXAlignment = Enum.TextXAlignment.Left
    authorLabel.Parent = authorSection
    
    local authorText = Instance.new("TextLabel")
    authorText.Size = UDim2.new(1, -20, 0, 30)
    authorText.Position = UDim2.new(0, 10, 0, 50)
    authorText.BackgroundTransparency = 1
    authorText.Text = "Author: komandos30"
    authorText.TextColor3 = Color3.fromRGB(150, 200, 255)
    authorText.Font = Enum.Font.Gotham
    authorText.TextSize = 18
    authorText.TextXAlignment = Enum.TextXAlignment.Left
    authorText.Parent = authorSection
    
    -- Discord Section
    local discordSection = Instance.new("Frame")
    discordSection.Size = UDim2.new(1, 0, 0, 120)
    discordSection.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    discordSection.BackgroundTransparency = 0.3
    discordSection.BorderSizePixel = 0
    discordSection.Parent = infoScroll
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 12)
    discordCorner.Parent = discordSection
    
    local discordStroke = Instance.new("UIStroke")
    discordStroke.Color = Color3.fromRGB(255, 255, 255)
    discordStroke.Thickness = 1
    discordStroke.Transparency = 0.6
    discordStroke.Parent = discordSection
    
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, -20, 0, 30)
    discordLabel.Position = UDim2.new(0, 10, 0, 15)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "💬 Join Our Discord"
    discordLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextSize = 16
    discordLabel.TextXAlignment = Enum.TextXAlignment.Left
    discordLabel.Parent = discordSection
    
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, -20, 0, 45)
    discordBtn.Position = UDim2.new(0, 10, 0, 60)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.BackgroundTransparency = 0.2
    discordBtn.Text = "🔗 discord.gg/zp5NKyJqMA"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 16
    discordBtn.Parent = discordSection
    
    local discordBtnCorner = Instance.new("UICorner")
    discordBtnCorner.CornerRadius = UDim.new(0, 10)
    discordBtnCorner.Parent = discordBtn
    
    local discordBtnStroke = Instance.new("UIStroke")
    discordBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    discordBtnStroke.Thickness = 1
    discordBtnStroke.Transparency = 0.4
    discordBtnStroke.Parent = discordBtn
    
    discordBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/zp5NKyJqMA")
        discordBtn.Text = "✓ Copied to Clipboard!"
        task.wait(2)
        discordBtn.Text = "🔗 discord.gg/zp5NKyJqMA"
    end)
    
    -- Parent GUI
    pcall(function()
        screenGui.Parent = CoreGui
    end)
    
    if not screenGui.Parent then
        screenGui.Parent = playerGui
    end
    
    print("GITY.CC | CASE PARADISE - GUI Created Successfully!")
end

createGUI()
