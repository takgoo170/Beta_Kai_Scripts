local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Kai Hub : Universal",
    Icon = "door-open",
    Author = "by Kai Team",
    Folder = "KaiHub",
    Size = UDim2.fromOffset(540, 435),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 180,
    Background = "",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    KeySystem = {
        Key = { "1234", "5678" },
        Note = "Example Key System.",
        Thumbnail = {
            Image = "rbxassetid://",
            Title = "Thumbnail",
        },
        URL = "https://github.com/Footagesus/WindUI",
        SaveKey = true,
    },
})

WindUI:Popup({
    Title = "Welcome to Kai Hub!",
    Icon = "info",
    Content = "Kai Hub universal version.",
    Buttons = {
        {
            Title = "Cancel",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "Confirm",
            Icon = "arrow-right",
            Callback = function() end,
            Variant = "Primary",
        }
    }
})

------------- TABS ------------------
local Discord = Window:Tab({
    Title = "Discord",
    Icon = "info",
    Locked = false,
})
local Main = Window:Tab({
    Title = "Main",
    Icon = "house",
    Locked = false,
})
local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Locked = false,
})
local BloxFruits = Window:Tab({
    Title = "Blox Fruits",
    Icon = "apple",
    Locked = false,
})
local GaG = Window:Tab({
    Title = "Grow a Garden",
    Icon = "bird",
    Locked = false,
})
local DRails = Window:Tab({
    Title = "Dead Rails",
    Icon = "bird",
    Locked = false,
})
local KLegacy = Window:Tab({
    Title = "King Legacy",
    Icon = "bird",
    Locked = false,
})
local MemeSea = Window:Tab({
    Title = "Meme Sea",
    Icon = "bird",
    Locked = false,
})
local Tab = Window:Tab({
    Title = "EMPTY",
    Icon = "bird",
    Locked = false,
})

------------- DISCORD TAB -------------------
local Button = Tab:Button({
    Title = "Kai Hub | Community",
    Desc = "Join to our discord community for more information and updates!",
    Locked = false,
    Callback = function()
      setclipboard("https://discord.gg/wDMPK3QAmY")
        print("clicked")!
    end
})
