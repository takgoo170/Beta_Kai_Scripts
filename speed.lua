local KaiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/takgoo170/Beta_Kai_Scripts/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = KaiUI:CreateWindow({
    Title = "Kai Hub : Legends of Speed",
    SubTitle = "by Kai Team | (discord.gg/wDMPK3QAmY)",
    TabWidth = 149,
    Size = UDim2.fromOffset(540, 375),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-------------------------- TABS -------------------
main = Window:AddTab({ Title = "Main", Icon = "house" })
farm = Window:AddTab({ Title = "Auto Farm", Icon = "rbxassetid://7044284832" })
tp = Window:AddTab({ Title = "Teleport", Icon = "rbxassetid://6035190846" })
race = Window:AddTab({ Title = "Race", Icon = "rbxassetid://7251993295" })
crystal = Window:AddTab({ Title = "Crystal", Icon = "rbxassetid://6031265976" })
local Tabs = {
      misc = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-------------------- MAIN TAB -----------------
main:AddSection("Intro")
main:AddParagraph({
    Title = "Hello! Welcome to Kai Hub!",
    Content = "Warmest welcome to you, thank you for using our script!"
  })
main:AddSection("Discord")
main:AddButton({
    Title = "Copy Discord Server Link",
    Description = "Join to our discord community for more updates.",
    Callback = function()
      setclipboard("https://discord.gg/wDMPK3QAmY")
    end 
  })

main:AddSection("Auto")
main:AddButton({
    Title = "Claim All Chest",
    Callback = function()
      workspace.goldenChest.circleInner.CFrame = player.Character.HumanoidRootPart.CFrame
	workspace.enchantedChest.circleInner.CFrame = player.Character.HumanoidRootPart.CFrame
	workspace.magmaChest.circleInner.CFrame = player.Character.HumanoidRootPart.CFrame
	workspace.groupRewardsCircle.circleInner.CFrame = player.Character.HumanoidRootPart.CFrame
	wait()
	workspace.goldenChest.circleInner.CFrame = oldGoldenChestPosition
	workspace.enchantedChest.circleInner.CFrame = oldEnchantedChestPosition
	workspace.magmaChest.circleInner.CFrame = oldMagmaChestPosition
	workspace.groupRewardsCircle.circleInner.CFrame = oldGroupRewardsPosition
    end
  })

main:AddToggle("Toggle", {
    Title = "Auto Rebirth",
    Description = "will automatically rebirth when it reaches max level",
    Default = false
  })
Toggle:OnChanged(function(state)
_G.Rebirth = (state and true or false)
	wait()
	while _G.Rebirth == true do
		wait()
		game.ReplicatedStorage.rEvents.rebirthEvent:FireServer("rebirthRequest")
		end
		end)

spawn(function()
        pcall(function()
            game:GetService("RunService").Stepped:Connect(function()
                if _G.NoClip then
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false    
                        end
                    end
                end
            end)
        end)
    end)
main:AddToggle("Toggle", {
    Title = "No Clip",
    Default = false
  })
Toggle:OnChanged(function(value)
    _G.NoClip = value
  end)

main:AddSection("Player")
local PLIST = {}

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
    table.insert(PLIST,v.Name)
end

local TpPlayer;
main:AddDropdown("Dropdown", {
    Title = "Select Player",
    Values = {PLIST},
    Multi = false,
    Default = 1,
  })
Dropdown:OnChanged(function(value)
    TpPlayer = value;
  end)
main:AddButton({
    Title = "Teleport to Player",
    Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =  game.Players[TpPlayer].Character.HumanoidRootPart.CFrame * CFrame.new(0,2,1)
    end
  })

----------------- FARM TAB -----------------

    
