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
    
    -- Main Container with gradient
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    -- Subtle gradient overlay
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 35)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 10, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 20))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Removed for cleaner look
    
    -- Title Bar with gradient
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    titleBar.BackgroundTransparency = 0.1
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleBar
    
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 60, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 30, 80))
    }
    titleGradient.Rotation = 90
    titleGradient.Parent = titleBar
    
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
    
    -- Close Button with gradient
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -45, 0, 7.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 10)
    closeBtnCorner.Parent = closeBtn
    
    local closeBtnGradient = Instance.new("UIGradient")
    closeBtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 80))
    }
    closeBtnGradient.Rotation = 45
    closeBtnGradient.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        blurEffect:Destroy()
        screenGui:Destroy()
    end)
    
    -- Left Sidebar with gradient
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 150, 1, -60)
    sidebar.Position = UDim2.new(0, 10, 0, 55)
    sidebar.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    sidebar.BackgroundTransparency = 0.2
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 15)
    sidebarCorner.Parent = sidebar
    
    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 25, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 35))
    }
    sidebarGradient.Rotation = 180
    sidebarGradient.Parent = sidebar
    
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
        btn.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        btn.BackgroundTransparency = 0.2
        btn.Text = categoryData.icon .. " " .. categoryData.name
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.LayoutOrder = categoryData.order
        btn.Parent = sidebar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = btn
        
        local btnGradient = Instance.new("UIGradient")
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 35, 65)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 50))
        }
        btnGradient.Rotation = 90
        btnGradient.Parent = btn
        
        categoryButtons[categoryData.name] = {button = btn, gradient = btnGradient}
        
        btn.MouseButton1Click:Connect(function()
            currentCategory = categoryData.name
            
            -- Update all buttons with smooth gradient transitions
            for name, data in pairs(categoryButtons) do
                if name == currentCategory then
                    data.button.BackgroundTransparency = 0.1
                    data.button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    data.gradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 80, 200)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 50, 150))
                    }
                else
                    data.button.BackgroundTransparency = 0.2
                    data.button.TextColor3 = Color3.fromRGB(200, 200, 220)
                    data.gradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 35, 65)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 50))
                    }
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
    categoryButtons["AUTO-OPEN"].button.BackgroundTransparency = 0.1
    categoryButtons["AUTO-OPEN"].button.TextColor3 = Color3.fromRGB(255, 255, 255)
    categoryButtons["AUTO-OPEN"].gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 80, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 50, 150))
    }
    
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
    
    -- Toggle Section with gradient
    local toggleSection = Instance.new("Frame")
    toggleSection.Size = UDim2.new(1, 0, 0, 80)
    toggleSection.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    toggleSection.BackgroundTransparency = 0.2
    toggleSection.BorderSizePixel = 0
    toggleSection.Parent = autoOpenScroll
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleSection
    
    local toggleGradient = Instance.new("UIGradient")
    toggleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 40))
    }
    toggleGradient.Rotation = 135
    toggleGradient.Parent = toggleSection
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -20, 0, 30)
    toggleLabel.Position = UDim2.new(0, 10, 0, 10)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Auto-Opener Status"
    toggleLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleSection
    
    local autoOpenToggle = Instance.new("TextButton")
    autoOpenToggle.Size = UDim2.new(0, 120, 0, 35)
    autoOpenToggle.Position = UDim2.new(0, 10, 0, 40)
    autoOpenToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 90)
    autoOpenToggle.BackgroundTransparency = 0.1
    autoOpenToggle.Text = "🔴 OFFLINE"
    autoOpenToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoOpenToggle.Font = Enum.Font.GothamBold
    autoOpenToggle.TextSize = 14
    autoOpenToggle.Parent = toggleSection
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 12)
    toggleBtnCorner.Parent = autoOpenToggle
    
    local toggleBtnGradient = Instance.new("UIGradient")
    toggleBtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
    }
    toggleBtnGradient.Rotation = 45
    toggleBtnGradient.Parent = autoOpenToggle
    
    autoOpenToggle.MouseButton1Click:Connect(function()
        config.autoOpenEnabled = not config.autoOpenEnabled
        
        if config.autoOpenEnabled then
            autoOpenToggle.Text = "🟢 ONLINE"
            toggleBtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 200, 100))
            }
            
            for _, caseData in pairs(config.levelCases) do
                caseData.firstOpen = false
                caseData.lastOpened = 0
            end
            
            task.spawn(mainLoop)
        else
            autoOpenToggle.Text = "🔴 OFFLINE"
            toggleBtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
            }
            loopRunning = false
        end
    end)
    
    -- Case Selection Section with gradient
    local caseSection = Instance.new("Frame")
    caseSection.Size = UDim2.new(1, 0, 0, 150)
    caseSection.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    caseSection.BackgroundTransparency = 0.2
    caseSection.BorderSizePixel = 0
    caseSection.Parent = autoOpenScroll
    
    local caseCorner = Instance.new("UICorner")
    caseCorner.CornerRadius = UDim.new(0, 15)
    caseCorner.Parent = caseSection
    
    local caseGradient = Instance.new("UIGradient")
    caseGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 40))
    }
    caseGradient.Rotation = 135
    caseGradient.Parent = caseSection
    
    local caseLabel = Instance.new("TextLabel")
    caseLabel.Size = UDim2.new(1, -20, 0, 30)
    caseLabel.Position = UDim2.new(0, 10, 0, 10)
    caseLabel.BackgroundTransparency = 1
    caseLabel.Text = "Select Case Type"
    caseLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
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
        caseBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 55)
        caseBtn.BackgroundTransparency = 0.2
        caseBtn.Text = caseType.icon .. " " .. caseType.name
        caseBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
        caseBtn.Font = Enum.Font.GothamBold
        caseBtn.TextSize = 14
        caseBtn.Parent = caseSection
        
        local caseBtnCorner = Instance.new("UICorner")
        caseBtnCorner.CornerRadius = UDim.new(0, 12)
        caseBtnCorner.Parent = caseBtn
        
        local caseBtnGradient = Instance.new("UIGradient")
        caseBtnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 35, 65)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 50))
        }
        caseBtnGradient.Rotation = 90
        caseBtnGradient.Parent = caseBtn
        
        caseButtons[caseType.name] = {button = caseBtn, gradient = caseBtnGradient}
        
        if caseType.name == config.selectedAutoOpen then
            caseBtn.BackgroundTransparency = 0.1
            caseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            caseBtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 120, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 80, 200))
            }
        end
        
        caseBtn.MouseButton1Click:Connect(function()
            config.selectedAutoOpen = caseType.name
            
            for name, data in pairs(caseButtons) do
                if name == config.selectedAutoOpen then
                    data.button.BackgroundTransparency = 0.1
                    data.button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    data.gradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 120, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 80, 200))
                    }
                else
                    data.button.BackgroundTransparency = 0.2
                    data.button.TextColor3 = Color3.fromRGB(200, 200, 220)
                    data.gradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 35, 65)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 50))
                    }
                end
            end
        end)
    end
    
    -- Info Section
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0, 25)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "⚡ Opening 5 cases per batch • 1s cooldown"
    infoLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
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
    
    -- Level Master Toggle with gradient
    local levelMasterSection = Instance.new("Frame")
    levelMasterSection.Size = UDim2.new(1, 0, 0, 80)
    levelMasterSection.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    levelMasterSection.BackgroundTransparency = 0.2
    levelMasterSection.BorderSizePixel = 0
    levelMasterSection.Parent = levelScroll
    
    local levelMasterCorner = Instance.new("UICorner")
    levelMasterCorner.CornerRadius = UDim.new(0, 15)
    levelMasterCorner.Parent = levelMasterSection
    
    local levelMasterGradient = Instance.new("UIGradient")
    levelMasterGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 40))
    }
    levelMasterGradient.Rotation = 135
    levelMasterGradient.Parent = levelMasterSection
    
    local levelMasterLabel = Instance.new("TextLabel")
    levelMasterLabel.Size = UDim2.new(1, -20, 0, 30)
    levelMasterLabel.Position = UDim2.new(0, 10, 0, 10)
    levelMasterLabel.BackgroundTransparency = 1
    levelMasterLabel.Text = "Master Control • 2 min cooldown • 6s delay"
    levelMasterLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    levelMasterLabel.Font = Enum.Font.Gotham
    levelMasterLabel.TextSize = 14
    levelMasterLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelMasterLabel.Parent = levelMasterSection
    
    local levelMasterToggle = Instance.new("TextButton")
    levelMasterToggle.Size = UDim2.new(0, 140, 0, 35)
    levelMasterToggle.Position = UDim2.new(0, 10, 0, 40)
    levelMasterToggle.BackgroundColor3 = Color3.fromRGB(200, 60, 90)
    levelMasterToggle.BackgroundTransparency = 0.1
    levelMasterToggle.Text = "ALL: OFF"
    levelMasterToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelMasterToggle.Font = Enum.Font.GothamBold
    levelMasterToggle.TextSize = 14
    levelMasterToggle.Parent = levelMasterSection
    
    local levelMasterBtnCorner = Instance.new("UICorner")
    levelMasterBtnCorner.CornerRadius = UDim.new(0, 12)
    levelMasterBtnCorner.Parent = levelMasterToggle
    
    local levelMasterBtnGradient = Instance.new("UIGradient")
    levelMasterBtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
    }
    levelMasterBtnGradient.Rotation = 45
    levelMasterBtnGradient.Parent = levelMasterToggle
    
    levelMasterToggle.MouseButton1Click:Connect(function()
        config.levelCasesEnabled = not config.levelCasesEnabled
        
        if config.levelCasesEnabled then
            levelMasterToggle.Text = "ALL: ON"
            levelMasterBtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 200, 100))
            }
        else
            levelMasterToggle.Text = "ALL: OFF"
            levelMasterBtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
            }
        end
    end)
    
    -- Level Cases Grid with gradient
    local levelGridSection = Instance.new("Frame")
    levelGridSection.Size = UDim2.new(1, 0, 0, 0)
    levelGridSection.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    levelGridSection.BackgroundTransparency = 0.2
    levelGridSection.BorderSizePixel = 0
    levelGridSection.AutomaticSize = Enum.AutomaticSize.Y
    levelGridSection.Parent = levelScroll
    
    local levelGridCorner = Instance.new("UICorner")
    levelGridCorner.CornerRadius = UDim.new(0, 15)
    levelGridCorner.Parent = levelGridSection
    
    local levelGridGradient = Instance.new("UIGradient")
    levelGridGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 40))
    }
    levelGridGradient.Rotation = 135
    levelGridGradient.Parent = levelGridSection
    
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
        levelBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 90)
        levelBtn.BackgroundTransparency = 0.1
        levelBtn.Text = "L" .. level
        levelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        levelBtn.Font = Enum.Font.GothamBold
        levelBtn.TextSize = 13
        levelBtn.Parent = levelGrid
        
        local levelBtnCorner = Instance.new("UICorner")
        levelBtnCorner.CornerRadius = UDim.new(0, 10)
        levelBtnCorner.Parent = levelBtn
        
        local levelBtnGradient = Instance.new("UIGradient")
        levelBtnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
        }
        levelBtnGradient.Rotation = 45
        levelBtnGradient.Parent = levelBtn
        
        levelBtn.MouseButton1Click:Connect(function()
            config.levelCases[levelName].enabled = not config.levelCases[levelName].enabled
            
            if config.levelCases[levelName].enabled then
                levelBtn.Text = "L" .. level .. " ✓"
                levelBtnGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 150)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 200, 100))
                }
            else
                levelBtn.Text = "L" .. level
                levelBtnGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 120)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
                }
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
    
    -- Author Section with gradient
    local authorSection = Instance.new("Frame")
    authorSection.Size = UDim2.new(1, 0, 0, 100)
    authorSection.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    authorSection.BackgroundTransparency = 0.2
    authorSection.BorderSizePixel = 0
    authorSection.Parent = infoScroll
    
    local authorCorner = Instance.new("UICorner")
    authorCorner.CornerRadius = UDim.new(0, 15)
    authorCorner.Parent = authorSection
    
    local authorGradient = Instance.new("UIGradient")
    authorGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 40))
    }
    authorGradient.Rotation = 135
    authorGradient.Parent = authorSection
    
    local authorLabel = Instance.new("TextLabel")
    authorLabel.Size = UDim2.new(1, -20, 0, 30)
    authorLabel.Position = UDim2.new(0, 10, 0, 15)
    authorLabel.BackgroundTransparency = 1
    authorLabel.Text = "👤 Script Information"
    authorLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    authorLabel.Font = Enum.Font.GothamBold
    authorLabel.TextSize = 16
    authorLabel.TextXAlignment = Enum.TextXAlignment.Left
    authorLabel.Parent = authorSection
    
    local authorText = Instance.new("TextLabel")
    authorText.Size = UDim2.new(1, -20, 0, 30)
    authorText.Position = UDim2.new(0, 10, 0, 50)
    authorText.BackgroundTransparency = 1
    authorText.Text = "Author: komandos30"
    authorText.TextColor3 = Color3.fromRGB(150, 180, 255)
    authorText.Font = Enum.Font.Gotham
    authorText.TextSize = 18
    authorText.TextXAlignment = Enum.TextXAlignment.Left
    authorText.Parent = authorSection
    
    -- Discord Section with gradient
    local discordSection = Instance.new("Frame")
    discordSection.Size = UDim2.new(1, 0, 0, 120)
    discordSection.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
    discordSection.BackgroundTransparency = 0.2
    discordSection.BorderSizePixel = 0
    discordSection.Parent = infoScroll
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 15)
    discordCorner.Parent = discordSection
    
    local discordGradient = Instance.new("UIGradient")
    discordGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 30, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 40))
    }
    discordGradient.Rotation = 135
    discordGradient.Parent = discordSection
    
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, -20, 0, 30)
    discordLabel.Position = UDim2.new(0, 10, 0, 15)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "💬 Join Our Discord"
    discordLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextSize = 16
    discordLabel.TextXAlignment = Enum.TextXAlignment.Left
    discordLabel.Parent = discordSection
    
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, -20, 0, 45)
    discordBtn.Position = UDim2.new(0, 10, 0, 60)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.BackgroundTransparency = 0.1
    discordBtn.Text = "🔗 discord.gg/zp5NKyJqMA"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 16
    discordBtn.Parent = discordSection
    
    local discordBtnCorner = Instance.new("UICorner")
    discordBtnCorner.CornerRadius = UDim.new(0, 12)
    discordBtnCorner.Parent = discordBtn
    
    local discordBtnGradient = Instance.new("UIGradient")
    discordBtnGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(114, 137, 218)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242))
    }
    discordBtnGradient.Rotation = 45
    discordBtnGradient.Parent = discordBtn
    
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
