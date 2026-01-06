-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

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
    levelCaseDelay = 6,
    currentTab = "MAIN"
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

-- Create GUI with Liquid Glass Effect
local function createGUI()
    if CoreGui:FindFirstChild("CaseOpenerGUI") or playerGui:FindFirstChild("CaseOpenerGUI") then
        print("GUI already exists!")
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CaseOpenerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (Liquid Glass Effect)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(240, 245, 255)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 24)
    mainCorner.Parent = mainFrame
    
    -- Frosted Glass Blur Layer
    local blurLayer = Instance.new("Frame")
    blurLayer.Name = "BlurLayer"
    blurLayer.Size = UDim2.new(1, 0, 1, 0)
    blurLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    blurLayer.BackgroundTransparency = 0.5
    blurLayer.BorderSizePixel = 0
    blurLayer.ZIndex = 1
    blurLayer.Parent = mainFrame
    
    local blurCorner = Instance.new("UICorner")
    blurCorner.CornerRadius = UDim.new(0, 24)
    blurCorner.Parent = blurLayer
    
    -- Sharp White Glass Edge (Top Border)
    local topEdge = Instance.new("Frame")
    topEdge.Name = "TopEdge"
    topEdge.Size = UDim2.new(1, -4, 0, 1)
    topEdge.Position = UDim2.new(0, 2, 0, 24)
    topEdge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topEdge.BackgroundTransparency = 0.3
    topEdge.BorderSizePixel = 0
    topEdge.ZIndex = 3
    topEdge.Parent = mainFrame
    
    -- Glass Reflection Gradient
    local reflectionGradient = Instance.new("Frame")
    reflectionGradient.Size = UDim2.new(1, 0, 0.3, 0)
    reflectionGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    reflectionGradient.BackgroundTransparency = 0.7
    reflectionGradient.BorderSizePixel = 0
    reflectionGradient.ZIndex = 2
    reflectionGradient.Parent = mainFrame
    
    local reflectCorner = Instance.new("UICorner")
    reflectCorner.CornerRadius = UDim.new(0, 24)
    reflectCorner.Parent = reflectionGradient
    
    local reflectGradient = Instance.new("UIGradient")
    reflectGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    reflectGradient.Rotation = 90
    reflectGradient.Parent = reflectionGradient
    
    -- Soft Rounded Glow
    local softGlow = Instance.new("ImageLabel")
    softGlow.Name = "SoftGlow"
    softGlow.Size = UDim2.new(1, 60, 1, 60)
    softGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    softGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    softGlow.BackgroundTransparency = 1
    softGlow.Image = "rbxassetid://5028857084"
    softGlow.ImageColor3 = Color3.fromRGB(150, 200, 255)
    softGlow.ImageTransparency = 0.4
    softGlow.ScaleType = Enum.ScaleType.Slice
    softGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    softGlow.ZIndex = 0
    softGlow.Parent = mainFrame
    
    -- Animate glow
    local glowTween = TweenService:Create(softGlow, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        ImageColor3 = Color3.fromRGB(180, 220, 255)
    })
    glowTween:Play()
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 70)
    titleBar.BackgroundTransparency = 1
    titleBar.ZIndex = 4
    titleBar.Parent = mainFrame
    
    -- Logo/Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 400, 0, 30)
    titleLabel.Position = UDim2.new(0, 25, 0, 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "GITY.CC | CASE PARADISE"
    titleLabel.TextColor3 = Color3.fromRGB(60, 90, 140)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 5
    titleLabel.Parent = titleBar
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(0, 400, 0, 18)
    subtitleLabel.Position = UDim2.new(0, 25, 0, 45)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = "Advanced Case Opening System"
    subtitleLabel.TextColor3 = Color3.fromRGB(120, 140, 180)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.TextSize = 11
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.TextTransparency = 0.3
    subtitleLabel.ZIndex = 5
    subtitleLabel.Parent = titleBar
    
    -- Close Button (Glass style)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 45, 0, 45)
    closeBtn.Position = UDim2.new(1, -60, 0, 12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.ZIndex = 10
    closeBtn.Parent = mainFrame
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 12)
    closeBtnCorner.Parent = closeBtn
    
    local closeBtnEdge = Instance.new("UIStroke")
    closeBtnEdge.Color = Color3.fromRGB(255, 255, 255)
    closeBtnEdge.Thickness = 1
    closeBtnEdge.Transparency = 0.5
    closeBtnEdge.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        screenGui:Destroy()
    end)
    
    -- Left Sidebar Navigation
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, -90)
    sidebar.Position = UDim2.new(0, 15, 0, 80)
    sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sidebar.BackgroundTransparency = 0.4
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 3
    sidebar.Parent = mainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 18)
    sidebarCorner.Parent = sidebar
    
    local sidebarEdge = Instance.new("UIStroke")
    sidebarEdge.Color = Color3.fromRGB(255, 255, 255)
    sidebarEdge.Thickness = 1
    sidebarEdge.Transparency = 0.6
    sidebarEdge.Parent = sidebar
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 8)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 12)
    sidebarPadding.PaddingBottom = UDim.new(0, 12)
    sidebarPadding.Parent = sidebar
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -180, 1, -100)
    contentFrame.Position = UDim2.new(0, 165, 0, 85)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 3
    contentFrame.Parent = mainFrame
    
    -- Main Tab Content
    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.Size = UDim2.new(1, 0, 1, 0)
    mainContent.BackgroundTransparency = 1
    mainContent.Visible = true
    mainContent.Parent = contentFrame
    
    -- Levels Tab Content
    local levelsContent = Instance.new("Frame")
    levelsContent.Name = "LevelsContent"
    levelsContent.Size = UDim2.new(1, 0, 1, 0)
    levelsContent.BackgroundTransparency = 1
    levelsContent.Visible = false
    levelsContent.Parent = contentFrame
    
    -- Info Tab Content
    local infoContent = Instance.new("Frame")
    infoContent.Name = "InfoContent"
    infoContent.Size = UDim2.new(1, 0, 1, 0)
    infoContent.BackgroundTransparency = 1
    infoContent.Visible = false
    infoContent.Parent = contentFrame
    
    -- Function to create tab button
    local function createTabButton(tabName, icon, order, contentToShow)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName .. "Tab"
        tabBtn.Size = UDim2.new(0, 116, 0, 80)
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.Text = ""
        tabBtn.LayoutOrder = order
        tabBtn.ZIndex = 4
        tabBtn.Parent = sidebar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 14)
        btnCorner.Parent = tabBtn
        
        local btnEdge = Instance.new("UIStroke")
        btnEdge.Color = Color3.fromRGB(255, 255, 255)
        btnEdge.Thickness = 1
        btnEdge.Transparency = 0.7
        btnEdge.Parent = tabBtn
        
        -- Icon Image
        local iconImage = Instance.new("ImageLabel")
        iconImage.Size = UDim2.new(0, 32, 0, 32)
        iconImage.Position = UDim2.new(0.5, 0, 0, 15)
        iconImage.AnchorPoint = Vector2.new(0.5, 0)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = icon
        iconImage.ImageColor3 = Color3.fromRGB(120, 150, 200)
        iconImage.ZIndex = 5
        iconImage.Parent = tabBtn
        
        -- Label
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(1, -10, 0, 22)
        labelText.Position = UDim2.new(0, 5, 1, -30)
        labelText.BackgroundTransparency = 1
        labelText.Text = tabName
        labelText.TextColor3 = Color3.fromRGB(100, 130, 180)
        labelText.Font = Enum.Font.GothamBold
        labelText.TextSize = 13
        labelText.ZIndex = 5
        labelText.Parent = tabBtn
        
        -- Active indicator bar
        local activeBar = Instance.new("Frame")
        activeBar.Name = "ActiveBar"
        activeBar.Size = UDim2.new(0, 4, 0.6, 0)
        activeBar.Position = UDim2.new(0, -10, 0.5, 0)
        activeBar.AnchorPoint = Vector2.new(0, 0.5)
        activeBar.BackgroundColor3 = Color3.fromRGB(100, 160, 255)
        activeBar.BorderSizePixel = 0
        activeBar.Visible = false
        activeBar.ZIndex = 6
        activeBar.Parent = tabBtn
        
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(1, 0)
        barCorner.Parent = activeBar
        
        -- Set initial active state
        if config.currentTab == tabName then
            activeBar.Visible = true
            iconImage.ImageColor3 = Color3.fromRGB(80, 140, 255)
            labelText.TextColor3 = Color3.fromRGB(80, 140, 255)
            tabBtn.BackgroundColor3 = Color3.fromRGB(230, 240, 255)
            btnEdge.Transparency = 0.3
        end
        
        tabBtn.MouseButton1Click:Connect(function()
            -- Hide all content
            mainContent.Visible = false
            levelsContent.Visible = false
            infoContent.Visible = false
            
            -- Show selected content
            contentToShow.Visible = true
            config.currentTab = tabName
            
            -- Update all tab buttons
            for _, child in pairs(sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    local childIcon = child:FindFirstChildOfClass("ImageLabel")
                    local childLabel = child:FindFirstChildOfClass("TextLabel")
                    local childEdge = child:FindFirstChildOfClass("UIStroke")
                    local childBar = child:FindFirstChild("ActiveBar")
                    
                    if child == tabBtn then
                        -- Active state
                        if childBar then childBar.Visible = true end
                        if childIcon then
                            TweenService:Create(childIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(80, 140, 255)}):Play()
                        end
                        if childLabel then
                            TweenService:Create(childLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(80, 140, 255)}):Play()
                        end
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(230, 240, 255)}):Play()
                        if childEdge then
                            TweenService:Create(childEdge, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
                        end
                    else
                        -- Inactive state
                        if childBar then childBar.Visible = false end
                        if childIcon then
                            TweenService:Create(childIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(120, 150, 200)}):Play()
                        end
                        if childLabel then
                            TweenService:Create(childLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(100, 130, 180)}):Play()
                        end
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        if childEdge then
                            TweenService:Create(childEdge, TweenInfo.new(0.3), {Transparency = 0.7}):Play()
                        end
                    end
                end
            end
        end)
        
        return tabBtn
    end
    
    -- Create tabs with icons
    createTabButton("MAIN", "rbxassetid://7733911828", 1, mainContent)
    createTabButton("LEVELS", "rbxassetid://7734053426", 2, levelsContent)
    createTabButton("INFO", "rbxassetid://7733955511", 3, infoContent)
    
    -- Function to create modern toggle switch
    local function createToggleSwitch(parent, position, callback, initialState)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 56, 0, 30)
        toggleFrame.Position = position
        toggleFrame.BackgroundColor3 = initialState and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(200, 210, 230)
        toggleFrame.BackgroundTransparency = 0.2
        toggleFrame.BorderSizePixel = 0
        toggleFrame.ZIndex = 5
        toggleFrame.Parent = parent
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleFrame
        
        local toggleEdge = Instance.new("UIStroke")
        toggleEdge.Color = Color3.fromRGB(255, 255, 255)
        toggleEdge.Thickness = 1
        toggleEdge.Transparency = 0.6
        toggleEdge.Parent = toggleFrame
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 24, 0, 24)
        knob.Position = initialState and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        knob.AnchorPoint = Vector2.new(0, 0.5)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 6
        knob.Parent = toggleFrame
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local knobShadow = Instance.new("ImageLabel")
        knobShadow.Size = UDim2.new(1, 10, 1, 10)
        knobShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        knobShadow.BackgroundTransparency = 1
        knobShadow.Image = "rbxassetid://5028857084"
        knobShadow.ImageColor3 = Color3.fromRGB(120, 140, 180)
        knobShadow.ImageTransparency = 0.7
        knobShadow.ScaleType = Enum.ScaleType.Slice
        knobShadow.SliceCenter = Rect.new(24, 24, 276, 276)
        knobShadow.ZIndex = 5
        knobShadow.Parent = knob
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(1, 0, 1, 0)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        toggleBtn.ZIndex = 7
        toggleBtn.Parent = toggleFrame
        
        local isOn = initialState
        
        toggleBtn.MouseButton1Click:Connect(function()
            isOn = not isOn
            
            local knobPos = isOn and UDim2.new(1, -27, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            local bgColor = isOn and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(200, 210, 230)
            
            TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = knobPos}):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.25), {BackgroundColor3 = bgColor}):Play()
            
            if callback then
                callback(isOn)
            end
        end)
        
        return toggleFrame
    end
    
    -- MAIN TAB CONTENT
    local mainTitle = Instance.new("TextLabel")
    mainTitle.Size = UDim2.new(1, 0, 0, 35)
    mainTitle.Position = UDim2.new(0, 0, 0, 5)
    mainTitle.BackgroundTransparency = 1
    mainTitle.Text = "AUTO OPENER"
    mainTitle.TextColor3 = Color3.fromRGB(70, 100, 150)
    mainTitle.Font = Enum.Font.GothamBold
    mainTitle.TextSize = 22
    mainTitle.TextXAlignment = Enum.TextXAlignment.Left
    mainTitle.ZIndex = 4
    mainTitle.Parent = mainContent
    
    -- Auto-Open Card
    local autoOpenCard = Instance.new("Frame")
    autoOpenCard.Size = UDim2.new(1, 0, 0, 110)
    autoOpenCard.Position = UDim2.new(0, 0, 0, 50)
    autoOpenCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    autoOpenCard.BackgroundTransparency = 0.4
    autoOpenCard.BorderSizePixel = 0
    autoOpenCard.ZIndex = 4
    autoOpenCard.Parent = mainContent
