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
Tabs.Main:AddSection("Farming")
    local Toggle = Tabs.Main:AddToggle("AutoCollectPlantedSeeds", {
    Title = "Auto Collect",
    Description = "Automatically harvest seeds planted in your garden.",
    Default = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local collecting = false

-- Set this to the folder/model where your planted seeds are stored
-- e.g., workspace:WaitForChild("Garden"):WaitForChild(LocalPlayer.Name)
local gardenFolder = workspace:WaitForChild("Garden"):WaitForChild(LocalPlayer.Name)

-- Function to get HumanoidRootPart safely
local function getHRP()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 10)
    return hrp
end

Toggle:OnChanged(function(state)
    collecting = state

    if collecting then
        task.spawn(function()
            local hrp = getHRP()
            if not hrp then
                warn("HumanoidRootPart not found, cannot collect seeds.")
                return
            end

            while collecting do
                wait(1) -- adjust wait time as needed

                -- Ensure gardenFolder still exists and parented
                if not gardenFolder or not gardenFolder.Parent then
                    warn("Garden folder missing or inaccessible.")
                    break
                end

                for _, seed in pairs(gardenFolder:GetChildren()) do
                    if not collecting then break end

                    -- Check if seed is a part or model you can harvest
                    local seedPart = (seed:IsA("BasePart") and seed) or (seed.PrimaryPart or seed:FindFirstChildWhichIsA("BasePart"))
                    if seedPart then
                        hrp.CFrame = seedPart.CFrame + Vector3.new(0, 3, 0)
                        wait(0.5)
                    end
                end
            end
        end)
    end
end)

    Tabs.Main:AddSection("Money")
    local Toggle = Tabs.Main:AddToggle("Toggle", {
    Title = "Instant Money",
    Description = "❗Enable this if someone is holding a pet, and you will automatically earn a money.",
    Default = false
})

Toggle:OnChanged(function(state)
    if state then
        task.spawn(function()
            while wait() do
                if not Toggle:Get() then
                    break
                end
                
                for i, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= game.Players.LocalPlayer then
                        local Pet = v.Character and v.Character:FindFirstChildOfClass("Tool")
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
