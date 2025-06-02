local KaiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/takgoo170/Beta_Kai_Scripts/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = KaiUI:CreateWindow({
    Title = "Kai Hub : Universal",
    SubTitle = "by Kai Team",
    TabWidth = 149,
    Size = UDim2.fromOffset(540, 375),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
KaiUI:Notify({
        Title = "Kai Hub | Universal",
        Content = "Script loaded successfully.",
        SubContent = "Enjoy!", -- Optional
        Duration = 12 -- Set to nil to make the notification not disappear
    })
------------------ TABS -----------------------
Info = Window:AddTab({ Title = "Info", Icon = "info" })
Bloxfruits = Window:AddTab({ Title = "Blox Fruits", Icon = "apple" })
GaG = Window:AddTab({ Title = "Grow a Garden", Icon = "cherry" })
Deadrails = Window:AddTab ({ Title = "Dead Rails", Icon = "", })

------------- Interface Tab -----------------------
local Tabs = {
      Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-------------- INFO Tab ---------------------
Info:AddParagraph({
    Title = "Welcome to Kai Hub!",
    Content = "Kai Hub is self-developed and it is developed by Takgoo."
  })
Info:AddButton({
        Title = "Kai Hub | Discord Server",
        Description = "Join to our community for more updates.",
        Callback = function()
            Window:Dialog({
                Title = "Hey!",
                Content = "Would you like to copy our discord server link?",
                Buttons = {
                    {
                        Title = "Copy",
                        Callback = function()
                            setclipboard("https://discord.gg/wDMPK3QAmY")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the request.")
                        end
                    }
                }
            })
        end
    })

----------- MANAGER ----------
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
