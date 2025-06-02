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
GaG = Window:AddTab({ Title = "Grow a Garden", Icon = "grape" })
Deadrails = Window:AddTab ({ Title = "Dead Rails", Icon = "train" })

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

------------------ BLOX FRUITS TAB ------------------
Bloxfruits:AddParagraph({
        Title = "Blox Fruits",
        Content = "This is the Blox Fruits scripts."
    })
Bloxfruits:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })
Bloxfruits:AddButton({
        Title = "Kai Hub V3 [ OUR SCRIPT ]",
        Description = "Keyless",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/takgoo31/realtakgoo999/refs/heads/main/MAIN_UI.lua"))()
        end
    })
Bloxfruits:AddButton({
        Title = "Redz Hub",
        Description = "Keyless, Latest version",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))(Settings)
                end
    })
Bloxfruits:AddButton({
        Title = "W-Azure",
        Description = "Keyless",
        Callback = function()
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"))()
                        end
    })
Bloxfruits:AddButton({
        Title = "Cokka Hub",
        Description = "Requires a key",
        Callback = function()
loadstring(game:HttpGet"https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua")()
                                end
    })
Bloxfruits:AddButton({
        Title = "Rubu Hub",
        Description = "Keyless",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/RubuRoblox/refs/heads/main/RubuBF"))()
                                        end
    })
Bloxfruits:AddButton({
        Title = "HoHo Hub",
        Description = "Requires a key",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
                                                end      
    })
Bloxfruits:AddButton({
        Title = "Ro Hub",
        Description = "Keyless",
        Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RO-HUB-CODEX/RO-HUB/refs/heads/main/bloxfruits.lua"))()
                                            end
    })
Bloxfruits:AddButton({
        Title = "Quantum ONYX",       
        Description = "No info found",
        Callback = function()                                                                    
loadstring(game:HttpGet("https://raw.githubusercontent.com/Trustmenotcondom/QTONYX/refs/heads/main/QuantumOnyx.lua"))()
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
