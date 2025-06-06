local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hungquan99/FluentUI/master/Addons/SaveManager.lua"))()

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hungquan99/FluentUI/master/Addons/InterfaceManager.lua"))()

local lp = game.Players.LocalPlayer

local minimizeUI = Enum.KeyCode.RightAlt

-- 🟢 Create Main UI
local Window = Fluent:CreateWindow({
    Title = "Hutao hub V1.5",
    SubTitle = "Grow a Garden",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = minimizeUI
})

-- Tabs
local Tabs = {
    Farm = Window:AddTab({ Title = "Farm", Icon = "rbxassetid://121302760641013" }),
    Items = Window:AddTab({ Title = "Items", Icon = "rbxassetid://121302760641013" }),
    Player = Window:AddTab({ Title = "Player", Icon = "rbxassetid://121302760641013" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://121302760641013" }),
    Settings = Window:AddTab({ Title = "Setting", Icon = "rbxassetid://121302760641013" }),
}  




--------------- All code ----------------

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")


-- Utility Functions
local function parseMoney(moneyStr)
    if not moneyStr then return 0 end
    moneyStr = tostring(moneyStr):gsub("Â¢", ""):gsub(",", ""):gsub(" ", ""):gsub("%$", "")
    local multiplier = 1
    if moneyStr:lower():find("k") then
        multiplier = 1000
        moneyStr = moneyStr:lower():gsub("k", "")
    elseif moneyStr:lower():find("m") then
        multiplier = 1000000
        moneyStr = moneyStr:lower():gsub("m", "")
    end
    return (tonumber(moneyStr) or 0) * multiplier
end

local function getPlayerMoney()
    return parseMoney((shecklesStat and shecklesStat.Value) or 0)
end

local function isInventoryFull()
    return #lp.Backpack:GetChildren() >= 200
end 







-------- Click Button Code --------

-- Tích hợp đầy đủ Auto Farm trong Fluent UI
local AutoFarmToggle = Tabs.Farm:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm",
    Default = false
})

AutoFarmToggle:OnChanged(function(state)
    local autoFarmEnabled = state
    local farmThread

    local function updateFarmData()
        farms = {}
        plants = {}
        for _, farm in pairs(workspace:FindFirstChild("Farm"):GetChildren()) do
            local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
            if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
                table.insert(farms, farm)
                local plantsFolder = farm.Important:FindFirstChild("Plants_Physical")
                if plantsFolder then
                    for _, plantModel in pairs(plantsFolder:GetChildren()) do
                        for _, part in pairs(plantModel:GetDescendants()) do
                            if part:IsA("BasePart") and part:FindFirstChildOfClass("ProximityPrompt") then
                                table.insert(plants, part)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    local function glitchTeleport(pos)
        if not lp.Character then return end
        local root = lp.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local tween = TweenService:Create(root, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
            CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        })
        tween:Play()
    end

    local function isInventoryFull()
        return #lp.Backpack:GetChildren() >= 200
    end

    if autoFarmEnabled then
        farmThread = task.spawn(function()
            while autoFarmEnabled do
                while isInventoryFull() do
                    if not autoFarmEnabled then return end
                    task.wait(1)
                end

                if not autoFarmEnabled then return end
                updateFarmData()

                for _, part in pairs(plants) do
                    if not autoFarmEnabled then return end
                    if isInventoryFull() then break end
                    if part and part.Parent then
                        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            glitchTeleport(part.Position)
                            task.wait(0.2)

                            for _, farm in pairs(farms) do
                                if not autoFarmEnabled or isInventoryFull() then break end
                                for _, obj in pairs(farm:GetDescendants()) do
                                    if obj:IsA("ProximityPrompt") then
                                        local str = tostring(obj.Parent)
                                        if not (str:find("Grow_Sign") or str:find("Core_Part")) then
                                            fireproximityprompt(obj, 1)
                                        end
                                    end
                                end
                            end

                            if not autoFarmEnabled then return end
                            task.wait(0.2)
                        end
                    end
                end

                if autoFarmEnabled then task.wait(0.1) end
            end
        end)
    elseif farmThread then
        task.cancel(farmThread)
        farmThread = nil
    end
end)





local autoBuySeeds = false
local autoBuyGears = false
local autoBuyEventItems = false

-- Mua hạt giống
Tabs.Farm:AddToggle("AutoBuySeeds", {
    Title = "Auto Buy Seed",
    Default = false,
    Callback = function(Value)
        autoBuySeeds = Value
        task.spawn(function()
            while autoBuySeeds do
                for _, name in ipairs({
                    "Carrot","Strawberry","Blueberry","Orange Tulip","Tomato",
                    "Corn","Daffodil","Watermelon","Pumpkin","Apple","Bamboo",
                    "Coconut","Cactus","Dragon Fruit","Mango","Grape","Mushroom",
                    "Pepper","Cacao","Beanstalk"
                }) do
                    ReplicatedStorage.GameEvents.BuySeedStock:FireServer(name)
                end
                task.wait(2)
            end
        end)
    end
})



local AutoCollectToggle = Tabs.Farm:AddToggle("AutoCollectV2Toggle", {
    Title = "Auto Collect V2",
    Default = false
})

local spamE = false
local RANGE = 50
local promptTracker = {}
local collectionThread
local descendantConnection

local function modifyPrompt(prompt, show)
    pcall(function()
        prompt.RequiresLineOfSight = not show
        prompt.Exclusivity = show and Enum.ProximityPromptExclusivity.AlwaysShow or Enum.ProximityPromptExclusivity.One
    end)
end

local function isInsideFarm(part)
    for _, farm in pairs(workspace:WaitForChild("Farm"):GetChildren()) do
        if part:IsDescendantOf(farm) then
            return true
        end
    end
    return false
end

local function handleNewPrompt(prompt)
    if not prompt:IsA("ProximityPrompt") then return end
    if not isInsideFarm(prompt) then return end

    if not promptTracker[prompt] then
        promptTracker[prompt] = {
            originalRequiresLOS = prompt.RequiresLineOfSight,
            originalExclusivity = prompt.Exclusivity
        }
    end

    modifyPrompt(prompt, spamE)
    prompt.AncestryChanged:Connect(function(_, parent)
        if parent == nil then
            promptTracker[prompt] = nil
        end
    end)
end

local function startAutoCollect()
    descendantConnection = workspace.DescendantAdded:Connect(handleNewPrompt)
    for _, desc in ipairs(workspace:GetDescendants()) do
        handleNewPrompt(desc)
    end
end

local function stopAutoCollect()
    if descendantConnection then
        descendantConnection:Disconnect()
        descendantConnection = nil
    end
    for prompt, _ in pairs(promptTracker) do
        modifyPrompt(prompt, false)
    end
    promptTracker = {}
end

AutoCollectToggle:OnChanged(function(state)
    spamE = state
    if spamE then
        startAutoCollect()
    else
        stopAutoCollect()
    end
end)




local autoSellEnabled = false
local autoSellThread

local function sellItems()
    local steven = workspace.NPCS:FindFirstChild("Steven")
    if not steven then return false end
    
    local char = lp.Character
    if not char then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local originalPosition = hrp.CFrame
    hrp.CFrame = steven.HumanoidRootPart.CFrame * CFrame.new(0, 3, 3)
    task.wait(0.5)
    
    for _ = 1, 5 do
        pcall(function()
            ReplicatedStorage.GameEvents.Sell_Inventory:FireServer()
        end)
        task.wait(0.15)
    end
    
    hrp.CFrame = originalPosition
    return true
end

-- Tạo nút Auto Sell
local AutoSellToggle = Tabs.Farm:AddToggle("AutoSellToggle", {
    Title = "Auto Sell All",
    Default = false
})

AutoSellToggle:OnChanged(function(state)
    autoSellEnabled = state

    if autoSellEnabled then
        autoSellThread = task.spawn(function()
            while autoSellEnabled do
                sellItems()
                task.wait(1) -- Đợi 1 giây trước lần bán tiếp theo
            end
        end)
    else
        if autoSellThread then
            task.cancel(autoSellThread)
            autoSellThread = nil
        end
    end
end)








local HarvestEnabled = false
local HarvestConnection = nil

local function FindGarden()
    local farm = workspace:FindFirstChild("Farm")
    if not farm then return nil end
    
    for _, plot in ipairs(farm:GetChildren()) do
        local data = plot:FindFirstChild("Important") and plot.Important:FindFirstChild("Data")
        local owner = data and data:FindFirstChild("Owner")
        if owner and owner.Value == lp.Name then
            return plot
        end
    end
    return nil
end

local function CanHarvest(part)
    local prompt = part:FindFirstChild("ProximityPrompt")
    return prompt and prompt.Enabled
end

local function Harvest()
    if not HarvestEnabled then return end
    if isInventoryFull() then return end
    
    local garden = FindGarden()
    if not garden then return end
    
    local plants = garden:FindFirstChild("Important") and garden.Important:FindFirstChild("Plants_Physical")
    if not plants then return end
    
    for _, plant in ipairs(plants:GetChildren()) do
        if not HarvestEnabled then break end
        local fruits = plant:FindFirstChild("Fruits")
        if fruits then
            for _, fruit in ipairs(fruits:GetChildren()) do
                if not HarvestEnabled then break end
                for _, part in ipairs(fruit:GetChildren()) do
                    if not HarvestEnabled then break end
                    if part:IsA("BasePart") and CanHarvest(part) then
                        local prompt = part.ProximityPrompt
                        local pos = part.Position + Vector3.new(0, 3, 0)
                        if lp.Character and lp.Character.PrimaryPart then
                            lp.Character:SetPrimaryPartCFrame(CFrame.new(pos))
                            task.wait(0.1)
                            if not HarvestEnabled then break end
                            prompt:InputHoldBegin()
                            task.wait(0.1)
                            if not HarvestEnabled then break end
                            prompt:InputHoldEnd()
                            task.wait(0.1)
                        end
                    end
                end
            end
        end
    end
end

local function ToggleHarvest(state)
    if HarvestConnection then
        HarvestConnection:Disconnect()
        HarvestConnection = nil
    end
    HarvestEnabled = state
    if state then
        HarvestConnection = RunService.Heartbeat:Connect(function()
            if HarvestEnabled then
                Harvest()
            else
                HarvestConnection:Disconnect()
                HarvestConnection = nil
            end
        end)
    end
end

-- Tạo nút Fluent UI Auto Harvest
local AutoHarvestToggle = Tabs.Farm:AddToggle("AutoHarvestToggle", {
    Title = "Auto Harvest",
    Default = false
})

AutoHarvestToggle:OnChanged(function(state)
    ToggleHarvest(state)
end)




-- Tabs.Items







-- Auto Claim Premium Seeds Functions
local autoClaimToggle = true -- mặc định bật
local claimConnection = nil

local function claimPremiumSeed()
    ReplicatedStorage.GameEvents.SeedPackGiverEvent:FireServer("ClaimPremiumPack")
end

local function toggleAutoClaim(newState)
    autoClaimToggle = newState
    if claimConnection then
        claimConnection:Disconnect()
        claimConnection = nil
    end
    if autoClaimToggle then
        claimConnection = RunService.Heartbeat:Connect(function()
            claimPremiumSeed()
            task.wait()
        end)
    end
end

-- Gọi ngay khi GUI load
toggleAutoClaim(true)

-- ✅ Nút bật tắt trong tab Ite
local AutoClaimToggle = Tabs.Items:AddToggle("AutoClaimPremiumSeedsToggle", {
    Title = "Auto Claim Premium Seeds",
    Default = true
})

AutoClaimToggle:OnChanged(function(state)
    toggleAutoClaim(state)
end)





-- Mua công cụ
Tabs.Items:AddToggle("AutoBuyGears", {
    Title = "Auto Buy Gear Items",
    Default = false,
    Callback = function(Value)
        autoBuyGears = Value
        task.spawn(function()
            while autoBuyGears do
                for _, name in ipairs({
                    "Watering Can","Trowel","Recall Wrench","Basic Sprinkler",
                    "Advanced Sprinkler","Godly Sprinkler","Lightning Rod",
                    "Master Sprinkler","Favorite Tool"
                }) do
                    ReplicatedStorage.GameEvents.BuyGearStock:FireServer(name)
                end
                task.wait(2)
            end
        end)
    end
})

-- Mua item từ Event Shop
Tabs.Items:AddToggle("AutoBuyEventItems", {
    Title = "Auto Buy Event Shop Items",
    Default = false,
    Callback = function(Value)
        autoBuyEventItems = Value
        task.spawn(function()
            while autoBuyEventItems do
                for _, name in ipairs({
                    "Mysterious Crate","Night Egg","Night Seed Pack",
                    "Blood Banana","Moon Melon","Star Caller",
                    "Blood Hedgehog","Blood Kiwi","Blood Owl"
                }) do
                    ReplicatedStorage.GameEvents.BuyEventShopStock:FireServer(name)
                end
                task.wait(2)
            end
        end)
    end
})








local AutoBuyEggToggle = Tabs.Items:AddToggle("AutoBuyEggToggle", {
    Title = "Auto Buy Egg",
    Default = false
})

local Autoegg_autoBuyEnabled = false
local autoBuyThread = nil

-- Giữ nguyên các biến và hàm trong code bạn gửi
local Autoegg_npc = workspace:WaitForChild("NPCS"):WaitForChild("Pet Stand")
local Autoegg_timer = Autoegg_npc.Timer.SurfaceGui:WaitForChild("ResetTimeLabel")
local Autoegg_eggLocations = Autoegg_npc:WaitForChild("EggLocations")
local Autoegg_events = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents")

local player = game.Players.LocalPlayer
local originalCFrame = player.Character and player.Character:WaitForChild("HumanoidRootPart").CFrame or CFrame.new()
local targetCFrame = CFrame.new(-255.12291, 2.99999976, -1.13749218, -0.0163238496, 1.05261321e-07, 0.999866784, -5.92361182e-09, 1, -1.0537206e-07, -0.999866784, -7.64290053e-09, -0.0163238496)

local function Autoegg_safeFirePrompt(prompt)
    if prompt then
        pcall(function()
            fireproximityprompt(prompt)
        end)
    end
end

local function Autoegg_safeFireServer(id)
    pcall(function()
        Autoegg_events:WaitForChild("BuyPetEgg"):FireServer(id)
    end)
end

local function Autoegg_setAlwaysShow()
    for _, obj in ipairs(Autoegg_eggLocations:GetChildren()) do
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("ProximityPrompt") then
                child.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
            end
        end
    end
end

local function Autoegg_autoBuyEggs()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    if not Autoegg_autoBuyEnabled then return end

    local firstRun = true
    while Autoegg_autoBuyEnabled do
        if not firstRun then
            repeat
                task.wait(0.1)
                if not Autoegg_autoBuyEnabled then return end
            until Autoegg_timer.Text == "00:00:00"
            task.wait(3)
        else
            firstRun = false
        end

        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        local originalPos = player.Character.HumanoidRootPart.CFrame
        player.Character.HumanoidRootPart.CFrame = targetCFrame

        Autoegg_setAlwaysShow()

        local commonEggPrompt = Autoegg_eggLocations:FindFirstChild("Common Egg")
        if commonEggPrompt then
            Autoegg_safeFirePrompt(commonEggPrompt:FindFirstChild("ProximityPrompt"))
            task.wait(0.3)
            Autoegg_safeFireServer(1)
        end

        local eggSlot6 = Autoegg_eggLocations:GetChildren()[6]
        if eggSlot6 then
            Autoegg_safeFirePrompt(eggSlot6:FindFirstChild("ProximityPrompt"))
            task.wait(0.3)
            Autoegg_safeFireServer(2)
        end

        local eggSlot5 = Autoegg_eggLocations:GetChildren()[5]
        if eggSlot5 then
            Autoegg_safeFirePrompt(eggSlot5:FindFirstChild("ProximityPrompt"))
            task.wait(0.3)
            Autoegg_safeFireServer(3)
        end

        player.Character.HumanoidRootPart.CFrame = originalPos
    end
end

AutoBuyEggToggle:OnChanged(function(state)
    Autoegg_autoBuyEnabled = state
    if state then
        autoBuyThread = task.spawn(function()
            Autoegg_autoBuyEggs()
        end)
    else
        if autoBuyThread then
            task.cancel(autoBuyThread)
            autoBuyThread = nil
        end
    end
end)





-- Tabs.Player



local OneClickRemoveToggle = Tabs.Player:AddToggle("OneClickRemoveToggle", {
    Title = "One Click Remove",
    Default = false
})

local enabled = false

local function OneClickRemove(state)
    enabled = state
    local confirmFrame = Players.LocalPlayer.PlayerGui:FindFirstChild("ShovelPrompt")
    if confirmFrame and confirmFrame:FindFirstChild("ConfirmFrame") then
        confirmFrame.ConfirmFrame.Visible = not state
    end
end

OneClickRemoveToggle:OnChanged(function(state)
    OneClickRemove(state)
end)


-- Fly Variables & Setup
local flyEnabled = false
local flySpeed = 48
local bodyVelocity, bodyGyro
local flightConnection

local function Fly(state)
    flyEnabled = state
    if flyEnabled then
        local character = lp.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity = Instance.new("BodyVelocity")
        bodyGyro.P = 9000
        bodyGyro.MaxTorque = Vector3.new(999999, 999999, 999999)
        bodyGyro.CFrame = character.HumanoidRootPart.CFrame
        bodyGyro.Parent = character.HumanoidRootPart

        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(999999, 999999, 999999)
        bodyVelocity.Parent = character.HumanoidRootPart

        humanoid.PlatformStand = true

        flightConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled or not character:FindFirstChild("HumanoidRootPart") then
                if flightConnection then flightConnection:Disconnect() end
                return
            end

            local cam = workspace.CurrentCamera.CFrame
            local moveVec = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVec += cam.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVec -= cam.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVec -= cam.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVec += cam.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVec += Vector3.new(0, flySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVec -= Vector3.new(0, flySpeed, 0)
            end

            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit * flySpeed
            end

            bodyVelocity.Velocity = moveVec
            bodyGyro.CFrame = cam
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end

        local character = lp.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end

        if flightConnection then
            flightConnection:Disconnect()
            flightConnection = nil
        end
    end
end

-- 🟦 Add to Fluent GUI
Tabs.Player:AddToggle("FlyToggle", {
    Title = "Fly [Mobie+PC]",
    Default = false,
    Callback = function(state)
        Fly(state)
    end
})



-- Giả sử bạn đã có biến Tabs.Ite (Tab hoặc Item trong Fluent UI framework của bạn)
-- Mình sẽ thêm 2 toggle cho NoClip và Infinite Jump

local noclipEnabled = false
local noclipConn = nil

local function ToggleNoclip(state)
    noclipEnabled = state
    if noclipEnabled and not noclipConn then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    elseif not noclipEnabled and noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
end

local infJumpEnabled = false

local function ToggleInfJump(state)
    infJumpEnabled = state
end

if not infJumpConn then
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- Tạo toggle NoClip
local NoClipToggle = Tabs.Player:AddToggle("NoClipToggle", {
    Title = "NoClip",
    Default = false
})

NoClipToggle:OnChanged(function(state)
    ToggleNoclip(state)
end)

-- Tạo toggle Infinite Jump
local InfJumpToggle = Tabs.Player:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = false
})

InfJumpToggle:OnChanged(function(state)
    ToggleInfJump(state)
end)






-- Tabs.Misc

-- Biến local player
local lp = game.Players.LocalPlayer

-- Toggle Seed Shop
local SeedShopToggle = Tabs.Misc:AddToggle("SeedShopToggle", {
    Title = "Seed Shop",
    Default = false
})

SeedShopToggle:OnChanged(function(state)
    local shop = lp.PlayerGui:FindFirstChild("Seed_Shop")
    if shop then
        shop.Enabled = state
    end
end)

-- Toggle Gear Shop
local GearShopToggle = Tabs.Misc:AddToggle("GearShopToggle", {
    Title = "Gear Shop",
    Default = false
})

GearShopToggle:OnChanged(function(state)
    local gear = lp.PlayerGui:FindFirstChild("Gear_Shop")
    if gear then
        gear.Enabled = state
    end
end)

-- Toggle Easter Shop
local EasterShopToggle = Tabs.Misc:AddToggle("EasterShopToggle", {
    Title = "Easter Shop",
    Default = false
})

EasterShopToggle:OnChanged(function(state)
    local easter = lp.PlayerGui:FindFirstChild("Easter_Shop")
    if easter then
        easter.Enabled = state
    end
end)

-- Toggle Daily Quest
local QuestToggle = Tabs.Misc:AddToggle("QuestToggle", {
    Title = "Daily Quest",
    Default = false
})

QuestToggle:OnChanged(function(state)
    local quest = lp.PlayerGui:FindFirstChild("DailyQuests_UI")
    if quest then
        quest.Enabled = state
    end
end)






-- Tabs.Settings









----------- Button On/Off -----------

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local ExistingUI = CoreGui:FindFirstChild("SkullHubMinimizeUI")
if ExistingUI then
    ExistingUI:Destroy()
end

-- Create Floating UI
local DragUI = Instance.new("ScreenGui")
DragUI.Name = "SkullHubMinimizeUI"
DragUI.ResetOnSpawn = false
DragUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Ensures highest rendering priority
DragUI.Parent = CoreGui -- Overrides all other UI elements

-- Create Circular Button (Draggable + Clickable)
local Button = Instance.new("ImageButton")
Button.Parent = DragUI
Button.Size = UDim2.new(0, 50, 0, 50) -- Adjust size if needed
Button.Position = UDim2.new(0, 10, 1, -85) -- Initial position
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Windows 11 Style
Button.BackgroundTransparency = 0.3 -- Semi-transparent
Button.BorderSizePixel = 0
Button.ClipsDescendants = true
Button.Image = "rbxassetid://90508203972003" -- Replace with your custom image ID
Button.ScaleType = Enum.ScaleType.Fit
Button.Active = true -- Allows drag functionality
Button.ZIndex = 1000 -- Ensure it stays on top

-- Make UI Circular
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Full circle
UICorner.Parent = Button

-- Tween Info for Animations
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Function to simulate RightShift key press
local function SimulateKeyPress()
    VirtualInputManager:SendKeyEvent(true, minimizeUI, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, minimizeUI, false, game)
end

-- Click Animation & UI Toggle (Only if NOT dragged too much)
local isDragging = false
local dragThreshold = 10 -- Allow small movement without canceling click

Button.MouseButton1Click:Connect(function()
    if isDragging then return end -- Prevent click after large dragging

    -- Enhanced Click Animation
    local tween = TweenService:Create(Button, tweenInfo, {
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 45, 0, 45),
        Rotation = 5
    })
    tween:Play()
    task.wait(0.1)
    local tweenBack = TweenService:Create(Button, tweenInfo, {
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 50, 0, 50),
        Rotation = 0
    })
    tweenBack:Play()

    -- Simulate RightShift to Toggle UI
    SimulateKeyPress()
end)

-- Hover Animation
Button.MouseEnter:Connect(function()
    TweenService:Create(Button, tweenInfo, {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

Button.MouseLeave:Connect(function()
    TweenService:Create(Button, tweenInfo, {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- Dragging Logic for PC & Mobile
local dragging, dragStart, startPos

local function StartDrag(input)
    isDragging = false -- Reset dragging state
    dragging = true
    dragStart = input.Position
    startPos = Button.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

local function OnDrag(input)
    if dragging then
        local delta = (input.Position - dragStart).Magnitude
        if delta > dragThreshold then -- Only mark as dragged if movement exceeds threshold
            isDragging = true
        end
        Button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + (input.Position.X - dragStart.X),
            startPos.Y.Scale,
            startPos.Y.Offset + (input.Position.Y - dragStart.Y)
        )
    end
end

-- Dragging Support for PC & Mobile (on the same button)
Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        StartDrag(input)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        OnDrag(input)
    end
end)