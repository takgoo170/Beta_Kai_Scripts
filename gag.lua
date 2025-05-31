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
    -- Auto Collect Planted Seeds with Tweening using Fluent UI toggle

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Toggle = Tabs.Main:AddToggle("AutoCollectPlantedSeeds", {
    Title = "Auto Collect Planted Seeds",
    Description = "Automatically harvest seeds planted in your garden using smooth movement.",
    Default = false,
})

-- Update this path to your game's actual garden planted seeds folder
local function getGardenFolder()
    -- Example path:
    -- Replace with your actual game path where planted seeds are parented
    local garden = workspace:FindFirstChild("Garden")
    if garden then
        return garden:FindFirstChild(LocalPlayer.Name)
    end
    return nil
end

local function getHRP()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 10)
    return hrp
end

local collecting = false

local function tweenToPosition(part, goalCFrame, duration)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(part, tweenInfo, {CFrame = goalCFrame})
    tween:Play()
    tween.Completed:Wait()
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
                wait(0.5)
                local gardenFolder = getGardenFolder()
                if not gardenFolder then
                    warn("Garden folder not found!")
                    wait(5)
                    continue
                end

                local seeds = gardenFolder:GetChildren()
                for _, seed in pairs(seeds) do
                    if not collecting then break end

                    local seedPart = nil
                    if seed:IsA("BasePart") then
                        seedPart = seed
                    elseif seed:IsA("Model") then
                        seedPart = seed.PrimaryPart or seed:FindFirstChildWhichIsA("BasePart")
                    end

                    if seedPart then
                        -- Tween smoothly near seed (above by 3 studs)
                        local targetCFrame = seedPart.CFrame + Vector3.new(0,3,0)
                        tweenToPosition(hrp, targetCFrame, 1)
                        wait(1)

                        -- TODO: Fire harvesting event here if needed, e.g.:
                        -- game:GetService("ReplicatedStorage").Events.HarvestSeed:FireServer(seed)

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
