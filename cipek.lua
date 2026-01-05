-- RemoteFunction Loop
while true do
    local result = game:GetService("ReplicatedStorage").Remotes.OpenCase:InvokeServer(
        game:GetService("Players").royamador.PlayerGui.Windows.Cases.CasesScript
    )
    
    -- Optional: Print the result each iteration
    print("Case opened:", result)
    
    -- Optional: Add a small delay between iterations to avoid overwhelming the server
    task.wait(0.1) -- Adjust delay as needed (in seconds)
end
