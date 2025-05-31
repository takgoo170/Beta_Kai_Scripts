local KaiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/takgoo170/Beta_Kai_Scripts/refs/heads/main/Beta.lua"))()
local Window = KaiUI:CreateWindow({
    Title = "Kai Hub : Grow a Garden 🌴",
    SubTitle = "by Kai Team",
    TabWidth = 160,
    Size = UDim2.fromOffset(520, 420),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
KaiUI:Notify({
        Title = "Kai Hub | Grow a Garden",
        Content = "Welcome to our Kai Hub | Grow a Garden script!",
        SubContent = "Thank you for using it.", -- Optional
        Duration = 11 -- Set to nil to make the notification not disappear
    })
---------TABS---------
local Tabs = {
    Discord = Window:AddTab({ Title = "Discord", Icon = "info" }),
    Main = Window:AddTab({ Title = "Main", Icon = "house" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
----------------- DISCORD TAB ---------------

----------------- MAIN TAB -------------------
    Tabs.Main:AddSection("Money")
    local Toggle = Tabs.Main:AddToggle("Toggle", {
    Title = "Instant Money",
    Description = "❗Enable this if someone is holding a pet, and you will automatically earn money.",
    Default = false
})

Toggle:OnChanged(function(state)
    if state then
        task.spawn(function()
            while Toggle:Get() do
                wait(1) -- Adjust the wait time as needed
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game.Players.LocalPlayer then
                        local Pet = player.Character and player.Character:FindFirstChildOfClass("Tool")
                        if Pet and Pet:GetAttribute("ItemType") == "Pet" then
                            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SellPet_RE"):FireServer(Pet)
                        end
                    end
                end
            end
        end)
    end
end)



--------------- NOTIFICATION ---------------
KaiUI:Notify({
    Title = "Kai Hub",
    Content = "The script has been loaded.",
    Duration = 9
})
