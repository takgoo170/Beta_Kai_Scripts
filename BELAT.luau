local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "Kai Hub : Universal",
    Icon = "door-open",
    Author = "Example UI",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
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
