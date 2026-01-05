-- Xeno Executor Case Opening Loop Script
-- Configuration
local LOOP_ENABLED = true
local DELAY_BETWEEN_OPENS = 0.5  -- Seconds between each case opening

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Get local player
local player = Players.LocalPlayer

-- References
local openCaseRemote = ReplicatedStorage.Remotes.OpenCase
local casesScript = player.PlayerGui.Windows.Cases.CasesScript

-- Statistics
local totalCasesOpened = 0
local totalErrors = 0
local itemsObtained = {}

-- Function to format and display item
local function displayItem(item, index)
    if type(item) == "table" then
        local stattrak = item.Stattrak and " [StatTrak™]" or ""
        local wear = item.Wear or "Unknown"
        local itemName = item.Item or "Unknown Item"
        
        print(string.format("  [%d] %s | %s%s", index, itemName, wear, stattrak))
        
        -- Track items
        if not itemsObtained[itemName] then
            itemsObtained[itemName] = 0
        end
        itemsObtained[itemName] = itemsObtained[itemName] + 1
    end
end

-- Function to open a case
local function openCase()
    local success, result = pcall(function()
        return openCaseRemote:InvokeServer(casesScript)
    end)
    
    if success and result then
        totalCasesOpened = totalCasesOpened + 1
        
        print(string.format("\n╔════════════════════════════════════╗"))
        print(string.format("║  Case #%-4d Opened Successfully   ║", totalCasesOpened))
        print(string.format("╚════════════════════════════════════╝"))
        
        -- Process results
        if type(result) == "table" then
            -- Handle nested table structure
            local items = result[1] or result
            if type(items) == "table" then
                local itemList = items[1] or items
                
                if type(itemList) == "table" then
                    print("Items Received:")
                    for i, item in ipairs(itemList) do
                        displayItem(item, i)
                    end
                end
            end
        end
        
        return true
    else
        totalErrors = totalErrors + 1
        warn(string.format("\n[ERROR] Case #%d failed: %s", 
            totalCasesOpened + 1, tostring(result)))
        return false
    end
end

-- Function to display statistics
local function showStats()
    print("\n" .. string.rep("═", 50))
    print("CASE OPENING STATISTICS")
    print(string.rep("═", 50))
    print(string.format("Total Cases Opened: %d", totalCasesOpened))
    print(string.format("Total Errors: %d", totalErrors))
    print(string.format("Success Rate: %.1f%%", 
        totalCasesOpened > 0 and (totalCasesOpened / (totalCasesOpened + totalErrors) * 100) or 0))
    
    if next(itemsObtained) then
        print("\nTop Items Obtained:")
        local sortedItems = {}
        for item, count in pairs(itemsObtained) do
            table.insert(sortedItems, {name = item, count = count})
        end
        table.sort(sortedItems, function(a, b) return a.count > b.count end)
        
        for i = 1, math.min(5, #sortedItems) do
            print(string.format("  %d. %s (x%d)", i, sortedItems[i].name, sortedItems[i].count))
        end
    end
    
    print(string.rep("═", 50) .. "\n")
end

-- Main execution
print("╔════════════════════════════════════════════╗")
print("║  XENO CASE OPENER - LOOP INITIALIZED      ║")
print("╚════════════════════════════════════════════╝")
print(string.format("Delay between opens: %.1f seconds", DELAY_BETWEEN_OPENS))
print("Press STOP in executor to terminate\n")

-- Main loop
local statsCounter = 0
while LOOP_ENABLED do
    openCase()
    
    -- Show stats every 10 cases
    statsCounter = statsCounter + 1
    if statsCounter >= 10 then
        showStats()
        statsCounter = 0
    end
    
    task.wait(DELAY_BETWEEN_OPENS)
end

-- Final statistics on stop
print("\n[LOOP STOPPED]")
showStats()
print("Script terminated.")
