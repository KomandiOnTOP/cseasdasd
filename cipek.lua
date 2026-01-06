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
    currentTab = "MAIN" -- Current active tab
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
	if CoreGui:FindFirstChild("CaseOpenerGUI") then return end

	-- BLUR TŁA (ZA GUI)
	local Lighting = game:GetService("Lighting")
	local blur = Instance.new("BlurEffect")
	blur.Size = 18
	blur.Name = "GlassBlurEffect"
	blur.Parent = Lighting

	-- GUI
	local gui = Instance.new("ScreenGui")
	gui.Name = "CaseOpenerGUI"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = CoreGui

	-- MAIN GLASS FRAME
	local main = Instance.new("Frame")
	main.Size = UDim2.fromScale(0.55, 0.6)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	main.BackgroundTransparency = 0.85
	main.Parent = gui
	main.Active = true
	main.Draggable = true

	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 24)

	-- OSTRE SZKLANE KRAWĘDZIE
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.5
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.3
	stroke.Parent = main

	-- SOFT GLOW
	local glow = Instance.new("ImageLabel")
	glow.Image = "rbxassetid://5028857084"
	glow.Size = UDim2.fromScale(1.05, 1.05)
	glow.Position = UDim2.fromScale(0.5, 0.5)
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.BackgroundTransparency = 1
	glow.ImageTransparency = 0.6
	glow.ImageColor3 = Color3.fromRGB(120, 200, 255)
	glow.ZIndex = 0
	glow.Parent = main

	-- TYTUŁ
	local title = Instance.new("TextLabel")
	title.Text = "GITY.CC | CASE PARADISE"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.TextColor3 = Color3.fromRGB(230, 240, 255)
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -40, 0, 40)
	title.Position = UDim2.new(0, 20, 0, 10)
	title.TextXAlignment = Left
	title.Parent = main

	-- SIDEBAR (LEWA STRONA)
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 90, 1, -60)
	sidebar.Position = UDim2.new(0, 10, 0, 60)
	sidebar.BackgroundColor3 = Color3.fromRGB(255,255,255)
	sidebar.BackgroundTransparency = 0.88
	sidebar.Parent = main
	Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 18)

	local sidebarStroke = Instance.new("UIStroke", sidebar)
	sidebarStroke.Color = Color3.fromRGB(255,255,255)
	sidebarStroke.Transparency = 0.4

	local layout = Instance.new("UIListLayout", sidebar)
	layout.Padding = UDim.new(0, 12)
	layout.HorizontalAlignment = Center
	layout.VerticalAlignment = Center

	-- CONTENT
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -120, 1, -80)
	content.Position = UDim2.new(0, 110, 0, 70)
	content.BackgroundTransparency = 1
	content.Parent = main

	-- TABS
	local tabs = {}

	local function createTab(name, iconId)
		local btn = Instance.new("ImageButton")
		btn.Size = UDim2.new(0, 60, 0, 60)
		btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
		btn.BackgroundTransparency = 0.75
		btn.Image = iconId
		btn.Parent = sidebar

		Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

		local stroke = Instance.new("UIStroke", btn)
		stroke.Color = Color3.fromRGB(255,255,255)
		stroke.Transparency = 0.5

		local page = Instance.new("Frame")
		page.Size = UDim2.fromScale(1,1)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = content

		btn.MouseButton1Click:Connect(function()
			for _,v in pairs(tabs) do
				v.page.Visible = false
			end
			page.Visible = true
		end)

		tabs[name] = {button = btn, page = page}
	end

	-- IKONY (REALNE)
	createTab("MAIN", "rbxassetid://7734053495")
	createTab("LEVELS", "rbxassetid://7733960981")
	createTab("INFO", "rbxassetid://7734015324")

	tabs.MAIN.page.Visible = true

	-- INFO CONTENT
	local infoText = Instance.new("TextLabel")
	infoText.Text = "author: komandos30"
	infoText.Font = Enum.Font.Gotham
	infoText.TextSize = 18
	infoText.TextColor3 = Color3.fromRGB(220,230,255)
	infoText.BackgroundTransparency = 1
	infoText.Size = UDim2.new(1,0,0,40)
	infoText.Position = UDim2.new(0,0,0,40)
	infoText.Parent = tabs.INFO.page

	local discordBtn = Instance.new("TextButton")
	discordBtn.Text = "JOIN DISCORD"
	discordBtn.Font = Enum.Font.GothamBold
	discordBtn.TextSize = 16
	discordBtn.TextColor3 = Color3.fromRGB(255,255,255)
	discordBtn.BackgroundColor3 = Color3.fromRGB(88,101,242)
	discordBtn.Size = UDim2.new(0,220,0,50)
	discordBtn.Position = UDim2.new(0,0,0,100)
	discordBtn.Parent = tabs.INFO.page
	Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0,14)

	discordBtn.MouseButton1Click:Connect(function()
		setclipboard("https://discord.gg/zp5NKyJqMA")
	end)

	print("GITY.CC | CASE PARADISE loaded (Liquid Glass)")
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
    autoOpenLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    autoOpenLabel.Font = Enum.Font.GothamBold
    autoOpenLabel.TextSize = 16
    autoOpenLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoOpenLabel.Parent = autoOpenCard
    
    local autoOpenToggle = createToggleSwitch(autoOpenCard, UDim2.new(1, -80, 0, 15), function(state)
        config.autoOpenEnabled = state
        
        if state then
            for _, caseData in pairs(config.levelCases) do
                caseData.firstOpen = false
                caseData.lastOpened = 0
            end
            task.spawn(mainLoop)
        else
            loopRunning = false
        end
    end, false)
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 20)
    infoLabel.Position = UDim2.new(0, 20, 0, 55)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Opening 5 cases per batch • 1s cooldown"
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 12
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextTransparency = 0.3
    infoLabel.Parent = autoOpenCard
    
    -- Case Type Selection Title
    local caseTypeTitle = Instance.new("TextLabel")
    caseTypeTitle.Size = UDim2.new(1, -40, 0, 20)
    caseTypeTitle.Position = UDim2.new(0, 20, 0, 80)
    caseTypeTitle.BackgroundTransparency = 1
    caseTypeTitle.Text = "Select Case Type:"
    caseTypeTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    caseTypeTitle.Font = Enum.Font.GothamBold
    caseTypeTitle.TextSize = 13
    caseTypeTitle.TextXAlignment = Enum.TextXAlignment.Left
    caseTypeTitle.Parent = autoOpenCard
    
    -- Case Types Grid
    local caseTypesGrid = Instance.new("Frame")
    caseTypesGrid.Size = UDim2.new(1, 0, 0, 200)
    caseTypesGrid.Position = UDim2.new(0, 0, 0, 195)
    caseTypesGrid.BackgroundTransparency = 1
    caseTypesGrid.Parent = mainContent
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0, 110, 0, 90)
    gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = caseTypesGrid
    
    local caseTypes = {
        {name = "Free", icon = "◇", color = Color3.fromRGB(100, 200, 255)},
        {name = "Group", icon = "◈", color = Color3.fromRGB(150, 100, 255)},
        {name = "VIP", icon = "◆", color = Color3.fromRGB(255, 200, 0)},
        {name = "Military", icon = "◘", color = Color3.fromRGB(255, 100, 100)}
    }
    
    for i, caseData in ipairs(caseTypes) do
        local caseBtn = Instance.new("TextButton")
        caseBtn.Name = caseData.name
        caseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        caseBtn.BackgroundTransparency = 0.4
        caseBtn.Text = ""
        caseBtn.LayoutOrder = i
        caseBtn.Parent = caseTypesGrid
        
        local caseBtnCorner = Instance.new("UICorner")
        caseBtnCorner.CornerRadius = UDim.new(0, 12)
        caseBtnCorner.Parent = caseBtn
        
        local caseBtnGlow = Instance.new("ImageLabel")
        caseBtnGlow.Name = "Glow"
        caseBtnGlow.Size = UDim2.new(1, 20, 1, 20)
        caseBtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        caseBtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        caseBtnGlow.BackgroundTransparency = 1
        caseBtnGlow.Image = "rbxassetid://5028857084"
        caseBtnGlow.ImageColor3 = caseData.color
        caseBtnGlow.ImageTransparency = 1
        caseBtnGlow.ScaleType = Enum.ScaleType.Slice
        caseBtnGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        caseBtnGlow.ZIndex = 0
        caseBtnGlow.Parent = caseBtn
        
        local caseIcon = Instance.new("TextLabel")
        caseIcon.Size = UDim2.new(1, 0, 0, 35)
        caseIcon.Position = UDim2.new(0, 0, 0, 10)
        caseIcon.BackgroundTransparency = 1
        caseIcon.Text = caseData.icon
        caseIcon.TextColor3 = Color3.fromRGB(150, 150, 200)
        caseIcon.Font = Enum.Font.GothamBold
        caseIcon.TextSize = 32
        caseIcon.Parent = caseBtn
        
        local caseName = Instance.new("TextLabel")
        caseName.Size = UDim2.new(1, 0, 0, 25)
        caseName.Position = UDim2.new(0, 0, 1, -35)
        caseName.BackgroundTransparency = 1
        caseName.Text = caseData.name
        caseName.TextColor3 = Color3.fromRGB(150, 150, 200)
        caseName.Font = Enum.Font.GothamBold
        caseName.TextSize = 14
        caseName.Parent = caseBtn
        
        -- Set initial state
        if config.selectedAutoOpen == caseData.name then
            caseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
            caseIcon.TextColor3 = caseData.color
            caseName.TextColor3 = caseData.color
            caseBtnGlow.ImageTransparency = 0.5
        end
        
        caseBtn.MouseButton1Click:Connect(function()
            config.selectedAutoOpen = caseData.name
            
            -- Update all case buttons
            for _, child in pairs(caseTypesGrid:GetChildren()) do
                if child:IsA("TextButton") then
                    local childIcon = child:FindFirstChildOfClass("TextLabel")
                    local childName = child:FindFirstChild("TextLabel", true)
                    local childGlow = child:FindFirstChild("Glow")
                    
                    if child.Name == caseData.name then
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 65)}):Play()
                        if childIcon then
                            TweenService:Create(childIcon, TweenInfo.new(0.3), {TextColor3 = caseData.color}):Play()
                        end
                        if childName and childName ~= childIcon then
                            TweenService:Create(childName, TweenInfo.new(0.3), {TextColor3 = caseData.color}):Play()
                        end
                        if childGlow then
                            TweenService:Create(childGlow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
                        end
                    else
                        TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
                        if childIcon then
                            TweenService:Create(childIcon, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 200)}):Play()
                        end
                        if childName and childName ~= childIcon then
                            TweenService:Create(childName, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 200)}):Play()
                        end
                        if childGlow then
                            TweenService:Create(childGlow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
                        end
                    end
                end
            end
        end)
    end
    
    -- LEVELS TAB CONTENT
    local levelsTitle = Instance.new("TextLabel")
    levelsTitle.Size = UDim2.new(1, 0, 0, 40)
    levelsTitle.Position = UDim2.new(0, 0, 0, 10)
    levelsTitle.BackgroundTransparency = 1
    levelsTitle.Text = "LEVEL CASES"
    levelsTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
    levelsTitle.Font = Enum.Font.GothamBold
    levelsTitle.TextSize = 24
    levelsTitle.TextXAlignment = Enum.TextXAlignment.Left
    levelsTitle.Parent = levelsContent
    
    -- Level Master Toggle Card
    local levelMasterCard = Instance.new("Frame")
    levelMasterCard.Size = UDim2.new(1, 0, 0, 90)
    levelMasterCard.Position = UDim2.new(0, 0, 0, 60)
    levelMasterCard.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    levelMasterCard.BackgroundTransparency = 0.4
    levelMasterCard.BorderSizePixel = 0
    levelMasterCard.Parent = levelsContent
    
    local levelCardCorner = Instance.new("UICorner")
    levelCardCorner.CornerRadius = UDim.new(0, 15)
    levelCardCorner.Parent = levelMasterCard
    
    local levelCardGlow = Instance.new("ImageLabel")
    levelCardGlow.Size = UDim2.new(1, 20, 1, 20)
    levelCardGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    levelCardGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    levelCardGlow.BackgroundTransparency = 1
    levelCardGlow.Image = "rbxassetid://5028857084"
    levelCardGlow.ImageColor3 = Color3.fromRGB(255, 150, 0)
    levelCardGlow.ImageTransparency = 0.7
    levelCardGlow.ScaleType = Enum.ScaleType.Slice
    levelCardGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    levelCardGlow.ZIndex = 0
    levelCardGlow.Parent = levelMasterCard
    
    local levelMasterLabel = Instance.new("TextLabel")
    levelMasterLabel.Size = UDim2.new(0, 250, 0, 30)
    levelMasterLabel.Position = UDim2.new(0, 20, 0, 15)
    levelMasterLabel.BackgroundTransparency = 1
    levelMasterLabel.Text = "Enable All Level Cases"
    levelMasterLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    levelMasterLabel.Font = Enum.Font.GothamBold
    levelMasterLabel.TextSize = 16
    levelMasterLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelMasterLabel.Parent = levelMasterCard
    
    local levelMasterToggle = createToggleSwitch(levelMasterCard, UDim2.new(1, -80, 0, 15), function(state)
        config.levelCasesEnabled = state
    end, false)
    
    local levelInfoLabel = Instance.new("TextLabel")
    levelInfoLabel.Size = UDim2.new(1, -40, 0, 20)
    levelInfoLabel.Position = UDim2.new(0, 20, 0, 50)
    levelInfoLabel.BackgroundTransparency = 1
    levelInfoLabel.Text = "2 minute cooldown • 6s delay between cases"
    levelInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    levelInfoLabel.Font = Enum.Font.Gotham
    levelInfoLabel.TextSize = 12
    levelInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelInfoLabel.TextTransparency = 0.3
    levelInfoLabel.Parent = levelMasterCard
    
    -- Scroll Frame for Level Cases
    local levelScrollFrame = Instance.new("ScrollingFrame")
    levelScrollFrame.Size = UDim2.new(1, 0, 1, -170)
    levelScrollFrame.Position = UDim2.new(0, 0, 0, 160)
    levelScrollFrame.BackgroundTransparency = 1
    levelScrollFrame.BorderSizePixel = 0
    levelScrollFrame.ScrollBarThickness = 4
    levelScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
    levelScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    levelScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    levelScrollFrame.Parent = levelsContent
    
    local levelGridLayout = Instance.new("UIGridLayout")
    levelGridLayout.CellSize = UDim2.new(0, 110, 0, 70)
    levelGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    levelGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    levelGridLayout.Parent = levelScrollFrame
    
    -- Create level case buttons
    for level = 10, 120, 10 do
        local levelName = "LEVEL" .. level
        local levelBtn = Instance.new("TextButton")
        levelBtn.Name = levelName
        levelBtn.LayoutOrder = level
        levelBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        levelBtn.BackgroundTransparency = 0.4
        levelBtn.Text = ""
        levelBtn.Parent = levelScrollFrame
        
        local levelBtnCorner = Instance.new("UICorner")
        levelBtnCorner.CornerRadius = UDim.new(0, 12)
        levelBtnCorner.Parent = levelBtn
        
        local levelBtnGlow = Instance.new("ImageLabel")
        levelBtnGlow.Name = "Glow"
        levelBtnGlow.Size = UDim2.new(1, 15, 1, 15)
        levelBtnGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        levelBtnGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        levelBtnGlow.BackgroundTransparency = 1
        levelBtnGlow.Image = "rbxassetid://5028857084"
        levelBtnGlow.ImageColor3 = Color3.fromRGB(255, 200, 0)
        levelBtnGlow.ImageTransparency = 1
        levelBtnGlow.ScaleType = Enum.ScaleType.Slice
        levelBtnGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        levelBtnGlow.ZIndex = 0
        levelBtnGlow.Parent = levelBtn
        
        local levelNumber = Instance.new("TextLabel")
        levelNumber.Size = UDim2.new(1, 0, 0, 30)
        levelNumber.Position = UDim2.new(0, 0, 0, 8)
        levelNumber.BackgroundTransparency = 1
        levelNumber.Text = tostring(level)
        levelNumber.TextColor3 = Color3.fromRGB(150, 150, 200)
        levelNumber.Font = Enum.Font.GothamBold
        levelNumber.TextSize = 20
        levelNumber.Parent = levelBtn
        
        local levelLabel = Instance.new("TextLabel")
        levelLabel.Size = UDim2.new(1, 0, 0, 18)
        levelLabel.Position = UDim2.new(0, 0, 1, -26)
        levelLabel.BackgroundTransparency = 1
        levelLabel.Text = "OFF"
        levelLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
        levelLabel.Font = Enum.Font.Gotham
        levelLabel.TextSize = 11
        levelLabel.Parent = levelBtn
        
        levelBtn.MouseButton1Click:Connect(function()
            config.levelCases[levelName].enabled = not config.levelCases[levelName].enabled
            local isEnabled = config.levelCases[levelName].enabled
            
            if isEnabled then
                levelLabel.Text = "ON"
                TweenService:Create(levelBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 65)}):Play()
                TweenService:Create(levelNumber, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 200, 0)}):Play()
                TweenService:Create(levelLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 200, 0)}):Play()
                TweenService:Create(levelBtnGlow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
            else
                levelLabel.Text = "OFF"
                TweenService:Create(levelBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 50)}):Play()
                TweenService:Create(levelNumber, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 200)}):Play()
                TweenService:Create(levelLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(150, 150, 200)}):Play()
                TweenService:Create(levelBtnGlow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
            end
        end)
    end
    
    -- Parent GUI
    pcall(function()
        screenGui.Parent = CoreGui
    end)
    
    if not screenGui.Parent then
        screenGui.Parent = playerGui
    end
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    
    local entranceTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 450),
        BackgroundTransparency = 0.3
    })
    entranceTween:Play()
    
    print("Liquid Glass GUI Created Successfully!")
end

-- Create the GUI
createGUI()
