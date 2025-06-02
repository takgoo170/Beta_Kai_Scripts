local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Kai Hub : Universal", "DarkTheme")

---------------- TABS -----------------------
local info = Window:NewTab("Info")
local settings = Window:NewTab("Settings")
local featured = Window:NewTab("Featured")
local bloxfruits = Window:NewTab("Blox Fruits")
local gag = Window:NewTab("Grow A Garden")
local idk = Window:NewTab("Unknown")

------------ INFO TAB -------------
local dc = info:NewSection("Discord")
dc:NewLabel("Wala kaming Label. 😢")
dc:NewButton("Kai Hub | COMMUNITY", "Join to our community for more updates.", function()
    setclipboard("https://discord.gg/wDMPK3QAmY")
end)
