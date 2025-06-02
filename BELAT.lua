--[[ SHORTCUT:
- 72+ : Tabs
- 

]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Kai Hub : Universal",
    Icon = "door-open",
    Author = "by Kai Team",
    Folder = "KaiHub",
    Size = UDim2.fromOffset(540, 370),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 145,
    Background = "",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
})

-- Create UI elements for username and avatar
local userLabel = Window:AddLabel("Loading...")
local avatarImage = Window:AddImage("rbxasset://textures/ui/GuiImagePlaceholder.png", 50, 50)

local function updateDisplay()
    if not Window.User.Enabled then
        userLabel.Text = ""
        avatarImage.Image = ""
        return
    end
    if Window.User.Anonymous then
        userLabel.Text = "Anonymous"
        avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    else
        userLabel.Text = LocalPlayer.Name
        local thumb = Players:GetUser ThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        avatarImage.Image = thumb
    end
end

-- Update display initially
updateDisplay()

-- Toggle anonymous state on label click
userLabel.MouseButton1Click:Connect(function()
    Window.User.Anonymous = not Window.User.Anonymous
    updateDisplay()
    Window.User.Callback()
end)
    KeySystem = {
        Key = { "1234", "5678" },
        Note = "Kai Hub | Key System",
        Thumbnail = {
            Image = "rbxassetid://",
            Title = "Thumbnail",
        },
        URL = "https://github.com/Footagesus/WindUI",
        SaveKey = true,
    },
})

------------------- TABS --------------------
local info = Window:Tab({
    Title = "Info",
    Icon = "info",
    Locked = false,
})
local bloxfruits = Window:Tab({
    Title = "Blox Fruits",
    Icon = "apple",
    Locked = false,
})
local gag = Window:Tab({
    Title = "Grow a Garden",
    Icon = "bird",
    Locked = false,
})
local deadrails = Window:Tab({
    Title = "Dead Rails",
    Icon = "bird",
    Locked = false,
})
local misc = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    Locked = false,
})
