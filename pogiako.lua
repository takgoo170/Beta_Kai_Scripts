local KaiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/takgoo170/Beta_Kai_Scripts/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = KaiUI:CreateWindow({
    Title = "Kai Hub : Universal",
    SubTitle = "by Kai Team | (discord.gg/wDMPK3QAmY)",
    TabWidth = 149,
    Size = UDim2.fromOffset(540, 375),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
KaiUI:Notify({
        Title = "Kai Hub | Universal",
        Content = "Script loaded successfully.",
        SubContent = "", -- Optional
        Duration = 12 -- Set to nil to make the notification not disappear
    })
KaiUI:Notify({
        Title = "Hey!",
        Content = "Meme Sea, King Legacy Tab is currently empty right now.",
        Duration = 17
    })
------------------ TABS -----------------------
Info = Window:AddTab({ Title = "Info", Icon = "info" })
Server = Window:AddTab({ Title = "Server", Icon = "scroll" })
Bloxfruits = Window:AddTab({ Title = "Blox Fruits", Icon = "apple" })
GaG = Window:AddTab({ Title = "Grow a Garden", Icon = "carrot" })
Deadrails = Window:AddTab({ Title = "Dead Rails", Icon = "train" })
PSX = Window:AddTab({ Title = "Pet Simulator X", Icon = "bone" })
PS99 = Window:AddTab({ Title = "Pet Simulator 99", Icon = "bone" })
PetsGo = Window:AddTab({ Title = "Pet's Go", Icon = "bone" })
MemeSea = Window:AddTab({ Title = "Meme Sea", Icon = "laugh" })
KingLegacy = Window:AddTab({ Title = "King Legacy", Icon = "crown" })
More = Window:AddTab({ Title = "More Scripts", Icon = "globe" })
------------- Interface Tab -----------------------
local Tabs = {
      Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-------------- INFO Tab ---------------------
Info:AddSection("Kai Hub COMMUNITY")
Info:AddParagraph({
    Title = "👋🏻 Welcome to Kai Hub!",
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

Info:AddSection("Kai Team Info")
Info:AddParagraph({
        Title = "Owner/Developer",
        Content = "Takgoo"
    })
Info:AddParagraph({
        Title = "Admin",
        Content = "Sage, Chi"
    })
Info:AddParagraph({
        Title = "Beta Testers",
        Content = "None"
    })
Info:AddSection("Status")
Info:AddParagraph({
        Title = "Key System Status"
    })
Info:AddParagraph({
        Title = "Requires a key",
        Content = "The script has a key system."
    })
Info:AddParagraph({
        Title = "Keyless",
        Content = "The script has no key system."
    })
Info:AddParagraph({
        Title = "No info found",
        Content = "The script does not know whether there is a key system or not."
    })

Info:AddSection("Socials")
Info:AddParagraph({
        Title = "SOON",
        Description = ""
    })

------------------- SERVER TAB ---------------
Server:AddParagraph({
    Title = "Server Job ID",
    Content = game.JobId ~= "" and game.JobId or "Job ID not available."
})
local lastCopyTime = 0
local copyCooldown = 2
Server:AddButton({
    Title = "Copy Job ID",
    Description = "Copies the Server Job Id.",
    Callback = function()
        if tick() - lastCopyTime >= copyCooldown then
            lastCopyTime = tick()
            setclipboard(tostring(game.JobId))
	KaiUI:Notify({
	Title = "Job Id Copied!",
	Content = "Job ID copied to clipboard successfully!",
	Duration = 10
})
            print("JobId Copied!")
        else
            print("Please try again in a moment!")
	
        end
    end
})
Input = Server:AddInput("Input", {
     Title = "Job Id",
     Default = "",
     Placeholder = "Input Job Id",
     Numeric = false,
     Finished = false,
     Callback = function(Value)
         getgenv().Job = Value
     end
})    
local lastTeleportTime = 0
local teleportCooldown = 5
Server:AddButton({
    Title = "Join Server",
    Callback = function()
        if tick() - lastTeleportTime >= teleportCooldown then
            lastTeleportTime = tick()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.placeId, getgenv().Job, game.Players.LocalPlayer)        
        end
    end
})
------------------ BLOX FRUITS TAB ------------------

Bloxfruits:AddParagraph({
        Title = "Blox Fruits",
        Content = "Blox Fruits Scripts Section."
    })
Bloxfruits:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })
Bloxfruits:AddSection("Game Scripts")
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

--------------- GROW A GARDEN TAB ---------------
GaG:AddParagraph({
        Title = "[🐝] Grow a Garden",
        Content = "Grow a Garden Scripts Section"
    })
GaG:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })

GaG:AddSection("Game Scripts")
GaG:AddButton({
        Title = "Lunor Hub",
        Description = "Requires a key",
        Callback = function()
            loadstring(game:HttpGet('https://lunor.dev/loader'))()
        end
    })
GaG:AddButton({
        Title = "Blue Hub",
        Description = "Keyless",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tesghg/Grow-a-Garden/main/ameicaa_Grow_A_Garden.lua"))()
        end
    })
GaG:AddButton({
        Title = "No Lag",
        Description = "Keyless",
        Callback = function()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
        end
    })
GaG:AddButton({
        Title = "Menace Hub",
        Description = "Keyless",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/M-E-N-A-C-E/Menace-Hub/refs/heads/main/Old%20Server%20Finder%20Grow%20a%20Garden", true))()
        end
    })
GaG:AddButton({
        Title = "Skull Hub",
        Description = "Requires a key",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nf-36/Koronis/refs/heads/main/Scripts/Loader.lua"))()
        end
    })
------------ DEAD RAILS TAB ----------------
Deadrails:AddParagraph({
        Title = "Dead Rails [ALPHA]",
        Content = "Dead Rails Scripts Section"
    })
Deadrails:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })
Deadrails:AddSection("Game Scripts")
Deadrails:AddButton({
        Title = "Skull Hub",
        Description = "Requires a key",
        Callback = function()            
             loadstring(game:HttpGet('https://raw.githubusercontent.com/hungquan99/SkullHub/main/loader.lua'))()
        end
    })

--------------- PSX TAB ----------------------
PSX:AddParagraph({
        Title = "Pet Simulator X! 🐾",
        Content = "Pet Simulator X! 🐾 Scripts Section",
    })
PSX:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })

PSX:AddSection("Game Scripts")
PSX:AddButton({
        Title = "Extreme Hub",
        Description = "Requires a key",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ExtremeAntonis/loader/main/loader.lua"))()
        end
    })
PSX:AddButton({
        Title = "BlackTrap",
        Description = "Requires a key",
        Callback = function()
            loadstring(game:HttpGetAsync("https://lua-library.btteam.net/script-auth.txt"))()
        end
    })

--------------- PS99 TAB ---------------
PS99:AddParagraph({
        Title = "🏀 Pet Simulator 99! 🎯",
        Content = "🏀 Pet Simulator 99! 🎯 Scripts Section"
    })
PS99:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })

PS99:AddSection("Game Scripts")
PS99:AddButton({
        Title = "Speed Hub",
        Description = "No info found",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()
        end
    })
PS99:AddButton({
        Title = "Zap Hub",
        Description = "No info found",
        Callback = function()
            loadstring(game:HttpGet('https://zaphub.xyz/Exec'))()
        end
    })
PS99:AddButton({
        Title = "Nousigi Hub",
        Description = "No info found",
        Callback = function()
            loadstring(game:HttpGet("https://nousigi.com/loader.lua"))()
        end
    })
PS99:AddButton({
        Title = "Nameless Hub",
        Description = "No info found",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/HenSeu87PofghYT/pet-sim-99/main/Nameless%20Scripts"))()
        end
    })

-------------- PetsGo Tab ------------------
PetsGo:AddParagraph({
        Title = "PETS GO! 🌽",
        Content = "PETS GO! 🌽 Scripts Section"
    })
PetsGo:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })

PetsGo:AddSection("Game Scripts")
PetsGo:AddButton({
        Title = "Speed Hub",
        Description = "No info found",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
        end
    })
PetsGo:AddButton({
        Title = "Beecon Hub", 
        Description = "Requires a key",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconBossScript/BeeconHub/main/BeeconHub"))()
        end
    })





--------------- MORE SCRIPTS TAB ----------------
More:AddParagraph({
        Title = "More Scripts",
        Content = "Find more scripts"
    })
More:AddParagraph({
        Title = "Important Information",
        Content = "Just click the scripts name below and it will automatically execute."
    })
More:AddSection("Movement Settings")
More:AddParagraph({
        Title = "Coming Soon!"
    })
More:AddSection("FE Scripts")
More:AddButton({
        Title = "Infinite Yield",
        Description = "Keyless",
        Callback = function()
            loadstring(game:HttpGet('https://cdn.robloxscripts.gg/public/furky/furky-infinite-yield-roblox-admin-script-source.lua'))()
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
