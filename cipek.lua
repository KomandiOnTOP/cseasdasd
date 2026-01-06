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
    
    -- Main Frame (Glass Effect)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 650, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -240)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    -- Glass Blur Effect
    local blurEffect = Instance.new("ImageLabel")
    blurEffect.Name = "GlassBlur"
    blurEffect.Size = UDim2.new(1, 0, 1, 0)
    blurEffect.BackgroundTransparency = 1
    blurEffect.Image = "rbxassetid://8992230677"
    blurEffect.ImageColor3 = Color3.fromRGB(20, 20, 35)
    blurEffect.ImageTransparency = 0.7
    blurEffect.ScaleType = Enum.ScaleType.Slice
    blurEffect.SliceCenter = Rect.new(99, 99, 99, 99)
    blurEffect.Parent = mainFrame
    
    local blurCorner = Instance.new("UICorner")
    blurCorner.CornerRadius = UDim.new(0, 20)
    blurCorner.Parent = blurEffect
    
    -- Neon Glow Border
    local glowBorder = Instance.new("ImageLabel")
    glowBorder.Name = "GlowBorder"
    glowBorder.Size = UDim2.new(1, 40, 1, 40)
    glowBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
    glowBorder.AnchorPoint = Vector2.new(0.5, 0.5)
    glowBorder.BackgroundTransparency = 1
    glowBorder.Image = "rbxassetid://5028857084"
    glowBorder.ImageColor3 = Color3.fromRGB(0, 255, 200)
    glowBorder.ImageTransparency = 0.5
    glowBorder.ScaleType = Enum.ScaleType.Slice
    glowBorder.SliceCenter = Rect.new(24, 24, 276, 276)
    glowBorder.ZIndex = 0
    glowBorder.Parent = mainFrame
    
    -- Animate glow
    local glowTween = TweenService:Create(glowBorder, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        ImageColor3 = Color3.fromRGB(100, 200, 255)
    })
    glowTween:Play()
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    titleBar.BackgroundTransparency = 0.4
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "GITY.CC | CASE PARADISE"
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Close Button (Glass style with X symbol)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.ZIndex = 10
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 10)
    closeBtnCorner.Parent = closeBtn
    
    local closeBtnGlow = Instance.new("ImageLabel")
    closeBtnGlow.Size = UDim2.new(1, 20, 1, 20)
    closeBtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    closeBtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    closeBtnGlow.BackgroundTransparency = 1
    closeBtnGlow.Image = "rbxassetid://5028857084"
    closeBtnGlow.ImageColor3 = Color3.fromRGB(255, 100, 100)
    closeBtnGlow.ImageTransparency = 0.7
    closeBtnGlow.ScaleType = Enum.ScaleType.Slice
    closeBtnGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    closeBtnGlow.ZIndex = 9
    closeBtnGlow.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        screenGui:Destroy()
    end)
    
    -- Tab Navigation (LEFT side)
    local tabNav = Instance.new("Frame")
    tabNav.Name = "TabNavigation"
    tabNav.Size = UDim2.new(0, 140, 1, -70)
    tabNav.Position = UDim2.new(0, 10, 0, 60)
    tabNav.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    tabNav.BackgroundTransparency = 0.4
    tabNav.BorderSizePixel = 0
    tabNav.Parent = mainFrame
    
    local tabNavCorner = Instance.new("UICorner")
    tabNavCorner.CornerRadius = UDim.new(0, 15)
    tabNavCorner.Parent = tabNav
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabNav
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 15)
    tabPadding.PaddingBottom = UDim.new(0, 15)
    tabPadding.Parent = tabNav
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -170, 1, -70)
    contentFrame.Position = UDim2.new(0, 160, 0, 60)
    contentFrame.BackgroundTransparency = 1
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
    local function createTabButton(tabName, iconImage, order, contentToShow)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName .. "Tab"
        tabBtn.Size = UDim2.new(0, 110, 0, 80)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.Text = ""
        tabBtn.LayoutOrder = order
        tabBtn.Parent = tabNav
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 12)
        btnCorner.Parent = tabBtn
        
        -- Icon
        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Size = UDim2.new(0, 36, 0, 36)
        iconLabel.Position = UDim2.new(0.5, 0, 0, 12)
        iconLabel.AnchorPoint = Vector2.new(0.5, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = iconImage
        iconLabel.ImageColor3 = Color3.fromRGB(150, 150, 200)
        iconLabel.Parent = tabBtn
        
        -- Label
        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(1, 0, 0, 20)
        labelText.Position = UDim2.new(0, 0, 1, -26)
        labelText.BackgroundTransparency = 1
        labelText.Text = tabName
        labelText.TextColor3 = Color3.fromRGB(150, 150, 200)
        labelText.Font = Enum.Font.GothamBold
        labelText.TextSize = 13
        labelText.Parent = tabBtn
        
        -- Glow effect
        local btnGlow = Instance.new("ImageLabel")
        btnGlow.Name = "Glow"
        btnGlow.Size = UDim2.new(1, 20, 1, 20)
        btnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        btnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        btnGlow.BackgroundTransparency = 1
        btnGlow.Image = "rbxassetid://5028857084"
        btnGlow.ImageColor3 = Color3.fromRGB(0, 255, 200)
        btnGlow.ImageTransparency = 1
        btnGlow.ScaleType = Enum.ScaleType.Slice
        btnGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        btnGlow.ZIndex = 0
        btnGlow.Parent = tabBtn
        
        -- Active indicator (left side bar)
        local activeBar = Instance.new("Frame")
        activeBar.Name = "ActiveBar"
        activeBar.Size = UDim2.new(0, 4, 0.6, 0)
        activeBar.Position = UDim2.new(0, -2, 0.5, 0)
        activeBar.AnchorPoint = Vector2.new(0, 0.5)
        activeBar.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        activeBar.BorderSizePixel = 0
        activeBar.Visible = false
        activeBar.Parent = tabBtn
        
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(1, 0)
        barCorner.Parent = activeBar
        
        -- Set initial active state
        if config.currentTab == tabName then
            activeBar.Visible = true
            iconLabel.ImageColor3 = Color3.fromRGB(0, 255, 200)
            labelText.TextColor3 = Color3.fromRGB(0, 255, 200)
            tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            TweenService:Create(btnGlow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
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
            for _, child in pairs(tabNav:GetChildren()) do
                if child:IsA("TextButton") then
                    local childIcon = child:FindFirstChildOfClass("ImageLabel")
                    local childLabel = child:FindFirstChild("TextLabel")
                    local childGlow = child:FindFirstChild("Glow")
                    local childBar = child:FindFirstChild("ActiveBar")
                    
                    if child == tabBtn then
                        -- Active state
                        if childBar then childBar.Visible = true end
                        if childIcon then
                            TweenService:Create(childIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(0, 255, 200)}):Play()
                        end
                        if childLabel then
                            TweenService:Create(childLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 200)}):Play()
                        end
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
                        if childGlow then
                            TweenService:Create(childGlow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
                        end
                    else
                        -- Inactive state
                        if childBar then childBar.Visible = false end
                        if childIcon then
                            TweenService:Create(childIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 200)}):Play()
                        end
                        if childLabel then
                            TweenService:Create(childLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 200)}):Play()
                        end
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
                        if childGlow then
                            TweenService:Create(childGlow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
                        end
                    end
                end
            end
        end)
        
        return tabBtn
    end
    
    -- Create tabs with Lucide-style icons
    createTabButton("MAIN", "rbxassetid://11422142913", 1, mainContent)
    createTabButton("LEVELS", "rbxassetid://11293981586", 2, levelsContent)
    createTabButton("INFO", "rbxassetid://11422143397", 3, infoContent)
    
    -- Function to create modern toggle switch
    local function createToggleSwitch(parent, position, callback, initialState)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 60, 0, 30)
        toggleFrame.Position = position
        toggleFrame.BackgroundColor3 = initialState and Color3.fromRGB(0, 200, 150) or Color3.fromRGB(40, 40, 60)
        toggleFrame.BackgroundTransparency = 0.3
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = parent
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleFrame
        
        -- Glow
        local toggleGlow = Instance.new("ImageLabel")
        toggleGlow.Size = UDim2.new(1, 15, 1, 15)
        toggleGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        toggleGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        toggleGlow.BackgroundTransparency = 1
        toggleGlow.Image = "rbxassetid://5028857084"
        toggleGlow.ImageColor3 = initialState and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(100, 100, 150)
        toggleGlow.ImageTransparency = initialState and 0.5 or 0.8
        toggleGlow.ScaleType = Enum.ScaleType.Slice
        toggleGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        toggleGlow.ZIndex = 0
        toggleGlow.Parent = toggleFrame
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 22, 0, 22)
        knob.Position = initialState and UDim2.new(1, -26, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
        knob.AnchorPoint = Vector2.new(0, 0.5)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.Parent = toggleFrame
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(1, 0, 1, 0)
        toggleBtn.BackgroundTransparency = 1
        toggleBtn.Text = ""
        toggleBtn.Parent = toggleFrame
        
        local isOn = initialState
        
        toggleBtn.MouseButton1Click:Connect(function()
            isOn = not isOn
            
            local knobPos = isOn and UDim2.new(1, -26, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)
            local bgColor = isOn and Color3.fromRGB(0, 200, 150) or Color3.fromRGB(40, 40, 60)
            local glowColor = isOn and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(100, 100, 150)
            local glowTrans = isOn and 0.5 or 0.8
            
            TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = knobPos}):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(toggleGlow, TweenInfo.new(0.2), {
                ImageColor3 = glowColor,
                ImageTransparency = glowTrans
            }):Play()
            
            if callback then
                callback(isOn)
            end
        end)
        
        return toggleFrame
    end
    
    -- MAIN TAB CONTENT
    local mainTitle = Instance.new("TextLabel")
    mainTitle.Size = UDim2.new(1, 0, 0, 40)
    mainTitle.Position = UDim2.new(0, 0, 0, 10)
    mainTitle.BackgroundTransparency = 1
    mainTitle.Text = "AUTO OPENER"
    mainTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
    mainTitle.Font = Enum.Font.GothamBold
    mainTitle.TextSize = 24
    mainTitle.TextXAlignment = Enum.TextXAlignment.Left
    mainTitle.Parent = mainContent
    
    -- Auto-Open Card
    local autoOpenCard = Instance.new("Frame")
    autoOpenCard.Size = UDim2.new(1, 0, 0, 120)
    autoOpenCard.Position = UDim2.new(0, 0, 0, 60)
    autoOpenCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    autoOpenCard.BackgroundTransparency = 0.4
    autoOpenCard.BorderSizePixel = 0
    autoOpenCard.Parent = mainContent
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 15)
    cardCorner.Parent = autoOpenCard
    
    local cardGlow = Instance.new("ImageLabel")
    cardGlow.Size = UDim2.new(1, 20, 1, 20)
    cardGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    cardGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    cardGlow.BackgroundTransparency = 1
    cardGlow.Image = "rbxassetid://5028857084"
    cardGlow.ImageColor3 = Color3.fromRGB(0, 150, 255)
    cardGlow.ImageTransparency = 0.7
    cardGlow.ScaleType = Enum.ScaleType.Slice
    cardGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    cardGlow.ZIndex = 0
    cardGlow.Parent = autoOpenCard
    
    local autoOpenLabel = Instance.new("TextLabel")
    autoOpenLabel.Size = UDim2.new(0, 200, 0, 30)
    autoOpenLabel.Position = UDim2.new(0, 20, 0, 15)
    autoOpenLabel.BackgroundTransparency = 1
    autoOpenLabel.Text = "Auto-Open Status"
    autoOpenLabel.TextColor3 = Color3
