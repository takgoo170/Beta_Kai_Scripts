-- beta version
-- Kai Hub

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Kai Hub : Grow a Garden",
    Icon = "door-open",
    Author = "by Kai Team",
    Folder = "KaiHub",
    Size = UDim2.fromOffset(530, 400),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true, -- <- or false
        Callback = function() print("clicked") end, -- <- optional
        Anonymous = false -- <- or true
    },
    SideBarWidth = 150,
    --Background = "rbxassetid://13511292247", -- rbxassetid only
    HasOutline = true,
    -- remove it below if you don't want to use the key system in your script.
    --[[KeySystem = { -- <- keysystem enabled
        Key = { "1234", "5678" },
        Note = "Example Key System. \n\nThe Key is '1234' or '5678",
        -- Thumbnail = {
        --     Image = "rbxassetid://18220445082", -- rbxassetid only
        --     Title = "Thumbnail"
        -- },
        URL = "https://github.com/Footagesus/WindUI", -- remove this if the key is not obtained from the link.
        SaveKey = true, -- optional
    },
})
  ]]
------------------ TABS -----------------------
  local Tabs = {
  Discord = Window:Tab({ Title = "Discord", Icon = "info" }),
  Main = Window:Tab({ Title = "Main", Icon = "house" }),
  Settings = Window:Tab ({ Title = "Settings", Icon = "settings" })
}

------------------ DISCORD TAB ----------------
 --[[ for _,i in next, { "Default", "Red", "Orange", "Green", "Blue", "Grey", "White" } do
    Tabs.Discord:Paragraph({
        Title = ",
        Desc = "Paragraph with color",
        Image = "bird",
        Color = i ~= "Blue" and i or nil, ]]
        
        Tabs.Discord:Button({
        Title = "Kai Hub | Community",
        Desc = "Join to our community for future updates!",
        Callback = function()
          setclipboard("https://discord.gg/wDMPK3QAmY")
        end
      }

-------------- MAIN TAB --------------
      Tabs.Main:Paragraph({
    Title = "Welcome to our Grow a Garden script!",
    Desc = "Kai Hub Grow a Garden script, thank you for using it!"
})
      Tabs.Main:Section({
          Title = "Money"
        })
      Tabs.Main:Toggle({
    Title = "Instant Money",
    Desc = "Enable this if someone is holding a pet, so you can earn money!",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function()
task.spawn(function()
    while true do wait()
        for i, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= game.Players.LocalPlayer then
                local Pet = v.Character:FindFirstChildOfClass("Tool")
                if Pet and Pet:GetAttribute("ItemType") == "Pet" then
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SellPet_RE"):FireServer(Pet)
                --[[WindUI:Popup({
    Title = "Welcome! Popup Example",
    Icon = "info",
    Content = "This is an Example UI for the " .. gradient("WindUI", Color3.fromHex("#00FF87"), Color3.fromHex("#60EFFF")) .. " Lib",
    Buttons = {
        {
            Title = "Cancel",
            --Icon = "",
            Callback = function() end,
            Variant = "Secondary", -- Primary, Secondary, Tertiary
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary", -- Primary, Secondary, Tertiary
        }
    }
}) 


repeat wait() until Confirmed]]
        
                end
            end
        end
    end
end)
             end
})
