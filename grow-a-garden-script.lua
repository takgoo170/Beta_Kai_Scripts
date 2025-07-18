
-- Grow a Garden Script
-- LAJ HUB v2

if not game:IsLoaded() then
    print("Waiting for game to load...")
    game.Loaded:Wait()
    print("Loaded Game")
end

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Get required data
local egg_shop = require(ReplicatedStorage.Data.PetEggData)
local seed_shop = require(ReplicatedStorage.Data.SeedData)
local gear_shop = require(ReplicatedStorage.Data.GearData)

-- Variables
local selectedSeeds = {}
local selectedGears = {}
local selectedEggs = {}
local selectedMutations = {}
local seeds = {}
local gears = {}
local eggs = {}
local mutations = {}

-- Farm location
local farm = nil
for _, v in next, Workspace:FindFirstChild("Farm"):GetDescendants() do
    if v.Name == "Owner" and v.Value == LocalPlayer.Name then
        farm = v.Parent.Parent
        break
    end
end

-- Get items from shop data
for i, v in next, seed_shop do
    if v.StockChance > 0 then
        table.insert(seeds, i)
    end
end

for _, v in next, egg_shop do
    if v.StockChance > 0 then
        table.insert(eggs, v.EggName)
    end
end

for _, v in next, gear_shop do
    if v.StockChance > 0 then
        table.insert(gears, v.GearName)
    end
end

for _, v in next, ReplicatedStorage.Mutation_FX:GetChildren() do
    table.insert(mutations, v.Name)
end
table.insert(mutations, "Gold")
table.insert(mutations, "Rainbow")

-- State variables
local autoPlant = false
local pickupAura = false
local hatchAura = false
local autoBuySeeds = false
local autoBuyGears = false
local autoBuyEggs = false
local autoFavorite = false
local autoSell = false
local autoConvertPollinated = false
local autoHoneyFarm = false

-- Settings
local pickupRange = 20
local pickupDelay = 0.1
local minWeight = 0.01
local plantDelay = 0.1
local favoriteDelay = 0.1
local sellDelay = 10
local plantPosition = nil
local autoPlantMethod = "Player Position"

-- Honey farm variables
local pollinatedTools = {}
local busy = false

-- Functions
local function updatePollinatedList()
    pollinatedTools = {}
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        local weightObj = tool:FindFirstChild("Weight")
        local weight = weightObj and weightObj:IsA("NumberValue") and weightObj.Value or 0

        local favObj = tool:FindFirstChild("Favorite")
        local isFav = favObj and favObj:IsA("BoolValue") and favObj.Value or false

        if tool.Name:match("%[.-Pollinated.-%]") and weight >= 10 and not isFav then
            table.insert(pollinatedTools, tool)
        end
    end
end

local function closestPet()
    local pet = nil
    local distance = math.huge

    for _, v in next, Workspace:FindFirstChild("PetsPhysical"):GetChildren() do
        if v:IsA("Part") and v:GetAttribute("OWNER") == LocalPlayer.Name and v:GetAttribute("UUID") then
            local dist = (v:GetPivot().Position - LocalPlayer.Character:GetPivot().Position).Magnitude
            if dist < distance then
                distance = dist
                pet = v
            end
        end
    end

    return pet
end

local function startPickupAura()
    if not pickupAura then return end
    
    task.spawn(function()
        while pickupAura do
            for _, v in next, farm:FindFirstChild("Plants_Physical"):GetChildren() do
                if v:IsA("Model") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, v2 in next, v:GetDescendants() do
                        if v2:IsA("ProximityPrompt") and v2.Parent.Parent:FindFirstChild("Weight") 
                        and v2.Parent.Parent.Weight.Value > minWeight 
                        and (v:GetPivot().Position - LocalPlayer.Character:GetPivot().Position).Magnitude < pickupRange then
                            fireproximityprompt(v2)
                            task.wait(pickupDelay)
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

local function startAutoPlant()
    if not autoPlant then return end
    
    task.spawn(function()
        while autoPlant do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") 
            and LocalPlayer.Character:FindFirstChildOfClass("Tool"):GetAttribute("ItemType") == "Seed" then
                
                if autoPlantMethod == "Choosen Position" and plantPosition then
                    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(plantPosition, LocalPlayer.Character:FindFirstChildOfClass("Tool"):GetAttribute("ItemName"))
                elseif autoPlantMethod == "Player Position" then
                    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Plant_RE"):FireServer(LocalPlayer.Character:GetPivot().Position, LocalPlayer.Character:FindFirstChildOfClass("Tool"):GetAttribute("ItemName"))
                end
                
                task.wait(plantDelay)
            end
            task.wait()
        end
    end)
end

local function startHatchAura()
    if not hatchAura then return end
    
    task.spawn(function()
        while hatchAura do
            for _, v in next, farm:FindFirstChild("Objects_Physical"):GetChildren() do
                if v:IsA("Model") and v:GetAttribute("TimeToHatch") == 0 and LocalPlayer.Character 
                and (v:GetPivot().Position - LocalPlayer.Character:GetPivot().Position).Magnitude < 20 then
                    for _, v2 in next, v:FindFirstChildOfClass("Model"):GetChildren() do
                        if v2:IsA("ProximityPrompt") and v2.Name == "ProximityPrompt" then
                            fireproximityprompt(v2)
                            task.wait(0.1)
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end

local function startAutoFavorite()
    if not autoFavorite then return end
    
    task.spawn(function()
        while autoFavorite do
            for _, v in next, LocalPlayer:FindFirstChild("Backpack"):GetChildren() do
                local seedModels = ReplicatedStorage:FindFirstChild("Seed_Models")
                for _, v2 in next, seedModels:GetChildren() do
                    if v:IsA("Tool") and not v:GetAttribute("Favorite") and v:GetAttribute("ItemName") == v2.Name 
                    and v:FindFirstChild("Weight") and v.Weight.Value > minWeight then
                        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(v)
                    elseif selectedMutations then
                        for i, _ in next, selectedMutations do
                            if v:IsA("Tool") and not v:GetAttribute("Favorite") and v:GetAttribute("ItemName") == v2.Name and v.Name:find(i) then
                                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(v)
                            end
                        end
                    end
                end
            end
            task.wait(favoriteDelay)
        end
    end)
end

local function startAutoBuySeeds()
    if not autoBuySeeds then return end
    
    task.spawn(function()
        while autoBuySeeds do
            for i, _ in next, selectedSeeds do
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(i)
            end
            task.wait(1)
        end
    end)
end

local function startAutoBuyGears()
    if not autoBuyGears then return end
    
    task.spawn(function()
        while autoBuyGears do
            for i, _ in next, selectedGears do
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(i)
            end
            task.wait(1)
        end
    end)
end

local function startAutoBuyEggs()
    if not autoBuyEggs then return end
    
    task.spawn(function()
        while autoBuyEggs do
            local eggLocation = Workspace:FindFirstChild("NPCS"):FindFirstChild("Pet Stand"):FindFirstChild("EggLocations")
            for i, v in next, eggLocation:GetChildren() do
                for i2, _ in next, selectedEggs do
                    if v.Name == i2 and not v:GetAttribute("RobuxEggOnly") then
                        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuyPetEgg"):FireServer(i - 3)
                    end
                end
            end
            task.wait(1)
        end
    end)
end

local function startAutoSell()
    if not autoSell then return end
    
    task.spawn(function()
        while autoSell do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local old = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
                LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Workspace.Tutorial_Points.Tutorial_Point_2.CFrame
                task.wait(0.2)
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
                task.wait(0.2)
                LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = old
                task.wait(sellDelay)
            end
        end
    end)
end

local function startHoneyFarm()
    if not autoHoneyFarm then return end
    
    local jar = Workspace.Interaction.UpdateItems.HoneyEvent.HoneyCombpressor.Spout:WaitForChild("Jar")
    
    updatePollinatedList()
    LocalPlayer.Backpack.ChildAdded:Connect(updatePollinatedList)
    LocalPlayer.Backpack.ChildRemoved:Connect(updatePollinatedList)

    local proximityPrompt = jar:FindFirstChild("HoneyCombpressorPrompt")
    if proximityPrompt then
        ReplicatedStorage.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
    end

    RunService.RenderStepped:Connect(function()
        if not autoHoneyFarm or busy then return end
        busy = true

        local statusText = Workspace.Interaction.UpdateItems.HoneyEvent.HoneyCombpressor.Sign.SurfaceGui.TextLabel.Text

        if (not statusText:match("^%d+:0%d$") and not statusText:match("^%d+:%d%d$")) and not statusText:find("READY") then
            if #pollinatedTools > 0 then
                LocalPlayer.Character.Humanoid:EquipTool(pollinatedTools[math.random(#pollinatedTools)])
            end
            ReplicatedStorage.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
        end

        task.wait(0.5)
        busy = false
    end)

    jar.ChildAdded:Connect(function(child)
        if autoHoneyFarm and child:IsA("ProximityPrompt") and child.Name == "HoneyCombpressorPrompt" then
            ReplicatedStorage.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
            task.wait(1)
        end
    end)
end

-- UI Setup
local ui = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local win = ui:CreateWindow({
    Title = "Kai Hub : Grow a Garden",
    Icon = "leaf",
    Folder = nil,
    Size = UDim2.fromOffset(500, 380),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    Background = "",
})

-- Main Tab
local mainTab = win:Tab({
    Title = "Farming",
    Icon = "sprout",
})

mainTab:Section({
    Title = "Plant Management",
    TextXAlignment = "Left",
    TextSize = 17,
})

mainTab:Toggle({
    Title = "Pickup Aura",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        pickupAura = state
        if state then
            startPickupAura()
        end
    end
})

mainTab:Slider({
    Title = "Pickup Range",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = pickupRange,
    },
    Callback = function(value)
        pickupRange = value
    end
})

mainTab:Slider({
    Title = "Pickup Delay",
    Step = 0.1,
    Value = {
        Min = 0.1,
        Max = 5,
        Default = pickupDelay,
    },
    Callback = function(value)
        pickupDelay = value
    end
})

mainTab:Toggle({
    Title = "Auto Plant",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        autoPlant = state
        if state then
            startAutoPlant()
        end
    end
})

mainTab:Dropdown({
    Title = "Plant Method",
    Values = {"Player Position", "Choosen Position"},
    Value = autoPlantMethod,
    Callback = function(option)
        autoPlantMethod = option
    end
})

mainTab:Button({
    Title = "Set Plant Position",
    Locked = false,
    Callback = function()
        if LocalPlayer.Character then
            plantPosition = LocalPlayer.Character:GetPivot().Position
        end
    end
})

mainTab:Toggle({
    Title = "Hatch Aura",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        hatchAura = state
        if state then
            startHatchAura()
        end
    end
})

-- Shop Tab
local shopTab = win:Tab({
    Title = "Shop",
    Icon = "shopping-cart",
})

shopTab:Section({
    Title = "Auto Buy",
    TextXAlignment = "Left",
    TextSize = 17,
})

shopTab:Toggle({
    Title = "Auto Buy Seeds",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        autoBuySeeds = state
        if state then
            startAutoBuySeeds()
        end
    end
})

shopTab:Dropdown({
    Title = "Select Seeds",
    Values = seeds,
    Value = {},
    Multi = true,
    Callback = function(options)
        selectedSeeds = {}
        for option, selected in pairs(options) do
            if selected then
                selectedSeeds[option] = true
            end
        end
    end
})

shopTab:Toggle({
    Title = "Auto Buy Gears",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        autoBuyGears = state
        if state then
            startAutoBuyGears()
        end
    end
})

shopTab:Dropdown({
    Title = "Select Gears",
    Values = gears,
    Value = {},
    Multi = true,
    Callback = function(options)
        selectedGears = {}
        for option, selected in pairs(options) do
            if selected then
                selectedGears[option] = true
            end
        end
    end
})

shopTab:Toggle({
    Title = "Auto Buy Eggs",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        autoBuyEggs = state
        if state then
            startAutoBuyEggs()
        end
    end
})

shopTab:Dropdown({
    Title = "Select Eggs",
    Values = eggs,
    Value = {},
    Multi = true,
    Callback = function(options)
        selectedEggs = {}
        for option, selected in pairs(options) do
            if selected then
                selectedEggs[option] = true
            end
        end
    end
})

-- Inventory Tab
local inventoryTab = win:Tab({
    Title = "Inventory",
    Icon = "package",
})

inventoryTab:Section({
    Title = "Management",
    TextXAlignment = "Left",
    TextSize = 17,
})

inventoryTab:Toggle({
    Title = "Auto Favorite",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        autoFavorite = state
        if state then
            startAutoFavorite()
        end
    end
})

inventoryTab:Slider({
    Title = "Min Weight",
    Step = 0.01,
    Value = {
        Min = 0.01,
        Max = 100,
        Default = minWeight,
    },
    Callback = function(value)
        minWeight = value
    end
})

inventoryTab:Dropdown({
    Title = "Favorite Mutations",
    Values = mutations,
    Value = {},
    Multi = true,
    Callback = function(options)
        selectedMutations = {}
        for option, selected in pairs(options) do
            if selected then
                selectedMutations[option] = true
            end
        end
    end
})

inventoryTab:Toggle({
    Title = "Auto Sell",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        autoSell = state
        if state then
            startAutoSell()
        end
    end
})

inventoryTab:Button({
    Title = "Sell All Now",
    Locked = false,
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local old = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Workspace.Tutorial_Points.Tutorial_Point_2.CFrame
            task.wait(0.2)
            ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
            task.wait(0.2)
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = old
        end
    end
})

-- Event Tab
local eventTab = win:Tab({
    Title = "Event",
    Icon = "star",
})

eventTab:Section({
    Title = "Honey Farm",
    TextXAlignment = "Left",
    TextSize = 17,
})

eventTab:Toggle({
    Title = "Auto Honey Farm",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        autoHoneyFarm = state
        if state then
            startHoneyFarm()
        end
    end
})

eventTab:Button({
    Title = "Teleport to Event",
    Locked = false,
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Workspace.NightEvent.OwlNPCTree["26"].Part.CFrame + Vector3.new(0, 5, 0)
        end
    end
})

-- Pet Tab
local petTab = win:Tab({
    Title = "Pets",
    Icon = "heart",
})

petTab:Section({
    Title = "Pet Management",
    TextXAlignment = "Left",
    TextSize = 17,
})

petTab:Button({
    Title = "Feed Closest Pet",
    Locked = false,
    Callback = function()
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not tool then return end
        
        local pet = closestPet()
        if not pet then return end
        
        ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("ActivePetService"):FireServer("Feed", pet:GetAttribute("UUID"))
    end
})

-- Misc Tab
local miscTab = win:Tab({
    Title = "Misc",
    Icon = "settings",
})

miscTab:Section({
    Title = "Utilities",
    TextXAlignment = "Left",
    TextSize = 17,
})

miscTab:Button({
    Title = "Rejoin Server",
    Locked = false,
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

miscTab:Button({
    Title = "Unfavorite All",
    Locked = false,
    Callback = function()
        for _, v in next, LocalPlayer:FindFirstChild("Backpack"):GetChildren() do
            if v:GetAttribute("Favorite") then
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(v)
            end
        end
    end
})
