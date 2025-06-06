local script_version = {
    -- version
    version = "1.55",
    alpha = false,
    -- event 
    Night = false,
    Bee = false,
}
if script_version.alpha == true then
    script_version.alpha = "Alpha version"
else 
    script_version.alpha = "Release version"
end
print("MADE BY KAI TEAM\nScript Version " .. script_version.version .. " - " .. script_version.alpha)
local vful = script_version.version .." - ".. script_version.alpha
getgenv().vers = vful




repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui") 

local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local buySeed = ReplicatedStorage.GameEvents.BuySeedStock
local buyGear = ReplicatedStorage.GameEvents.BuyGearStock
local Plant = ReplicatedStorage.GameEvents.Plant_RE
local BuyPet = ReplicatedStorage.GameEvents.BuyPetEgg
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local scrollingFrame = game:GetService("Players").LocalPlayer.PlayerGui.ActivePetUI.Frame.Main.ScrollingFrame
local feedsc = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("ActivePetService")

-- event local

player.CharacterAdded:Connect(function(char)
    character = char
    hrp = character:WaitForChild("HumanoidRootPart")
end)

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()

local Window = Fluent:CreateWindow({
    Title = "Kai Hub : Grow a Garden",
    SubTitle = "by Kai Team | Version: ".. vful,
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true,
    Keybind = Enum.KeyCode.LeftControl
})

-- Local Tabs --

local loja = Window:AddTab({
    Title = "Main",
    Icon = "home"
})

local plant = Window:AddTab({
    Title = "Plant",
    Icon = "list"
})

local sell = Window:AddTab({
    Title = "Sell",
    Icon = "list"
})

local player = Window:AddTab({
        Title = "Player",
        Icon = "list"
    })

local pet = Window:AddTab({
        Title = "Pet",
        Icon = "list"
    })

local ui = Window:AddTab({
        Title = "UIs",
        Icon = "list"
    })

local event = Window:AddTab({
    Title = "Event",
    Icon = "list"
})

local config = Window:AddTab({
    Title = "Misc",
    Icon = "settings"
})

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("GrowAGarden")
InterfaceManager:BuildInterfaceSection(config)

-- Local Variáveis --

local byallseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk"}
local bygear = {"Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Favorite Tool", "Harvest Tool"}
local pseed = {"Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Moon Melon", "Blood Banana"}



local bsa = false
local bsg = false
local bsp = false 

local selectedSeeds = {}
local selectedGears = {}
local buypets = {1, 2, 3}

local step = 0.001
local x = Vector3.new(34.14344024658203, 0.13552513718605042, -112.62083435058594)
local y = Vector3.new(31.82763671875, 0.13552513718605042, -112.6816635131836)
local plap = ""

local Pos = hrp.Position
local pos = tostring(Pos)

local walkSpeed = humanoid.WalkSpeed

local PetsId = {}

-- Local functions --

function byallseedfc()
    for i = 1, 25 do
        for _, seed in ipairs(selectedSeeds) do
            buySeed:FireServer(seed)
            task.wait()
        end
    end
end

function byallgearfc()
    for i = 1, 25 do
        for _, gear in ipairs(selectedGears) do
            buyGear:FireServer(gear)
            task.wait()
        end
    end
end

function buypetegg()
    for i = 1, 3 do
        for _, pet in ipairs(buypets) do 
            BuyPet:FireServer(pet)
            task.wait()
        end
    end
end

function svp()
    Pos = hrp.Position
    pos = tostring(Pos)
end

function tpt(v3)
    if typeof(v3) == "Vector3" then
        hrp.CFrame = CFrame.new(v3)
    elseif typeof(v3) == "string" then
        local x, y, z = string.match(v3, "Vector3%s*%(([^,]+),%s*([^,]+),%s*([^)]+)%)")
        if x and y and z then
            hrp.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
        end
    end
end

function sf()
    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
end

function sm()
    ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("NightQuestRemoteEvent"):FireServer("SubmitAllPlants")
end

function tsf()
    svp()
    hrp.CFrame = CFrame.new(86.57965850830078, 2.999999761581421, 0.4267919063568115)
    task.wait(0.25)
    sf()
    task.wait(0.2)
    tpt(Pos)
end

function tsm()
    svp()
    hrp.CFrame = CFrame.new(-101.0422592163086, 4.400012493133545, -10.985257148742676)
    task.wait(0.25)
    sm()
    task.wait(0.2)
    tpt(Pos)
end

function ufav()
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character
    local backpack = player.Backpack

    local tool = char:FindFirstChildOfClass("Tool") or backpack:FindFirstChildOfClass("Tool")

    if tool and tool:GetAttribute("Favorite") == true then

        game:GetService("ReplicatedStorage").GameEvents.Favorite_Item:FireServer(tool)
    end
end

-- Local Script --

local section = loja:AddSection("Seeds")

loja:AddToggle("", {
    Title = "Buy Seeds",
    Description = "Purchases a seed based on selected seed.",
    Default = false,
    Callback = function(Value)
        bsa = Value
    end
})

local dropdownSeed = loja:AddDropdown("DropdownSeed", {
    Title = "Select Seeds",
    Description = "",
    Values = byallseed,
    Multi = true,
    Default = {},
})

dropdownSeed:OnChanged(function(Value)
    selectedSeeds = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedSeeds, v)
        end
    end
end)

local section = loja:AddSection("Gears")

loja:AddToggle("", {
    Title = "Buy Gear",
    Description = "Purchases a gear based on selected gear.",
    Default = false,
    Callback = function(Value)
        bsg = Value
    end
})

local dropdownGear = loja:AddDropdown("DropdownGear", {
    Title = "Select Gear",
    Description = "",
    Values = bygear,
    Multi = true,
    Default = {},
})

dropdownGear:OnChanged(function(Value)
    selectedGears = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedGears, v)
        end
    end
end)

local section = loja:AddSection("Pets")

loja:AddButton({
        Title = "Buy Egg",
        Description = "self explain",
        Callback = function()
            buypetegg()
        end
    })

loja:AddToggle("", {
        Title = "buy all afk pets",
        Description = "self explain",
        Default = false,
        Callback = function(value)
         bsp = value
        end
    })

-- 

plant:AddButton({
        Title = "Set local X",
        Description = "click to set the start of auto plant\n",
        Callback = function()
          x = Vector3.new(hrp.Position.X, 0.13552513718605042, hrp.Position.Z)
          print(x)
            
        end
    })

plant:AddButton({
        Title = "Set local Y",
        Description = "click to set the end of auto plant\n",
        Callback = function()
          y = Vector3.new(hrp.Position.X, 0.13552513718605042, hrp.Position.Z)
          print(y)
        end
    })

local plantDropdown = plant:AddDropdown("Dropdown", {
    Title = "Select Seed\n",
    Description = "",
    Values = pseed,
    Multi = false,
    Default = 1,
})

plantDropdown:OnChanged(function(Value)
    plap = Value
end)

local Slider = plant:AddSlider("Slider", 
{
    Title = "Distance from one seed to another\n",
    Description = "Seed Distance",
    Default = 0.001,
    Min = 0.001,
    Max = 0.1,
    Rounding = 3,
    Callback = function(Value)
        step = Value
    end
})

plant:AddButton({
    Title = "Click to Plant",
    Description = "", 
    Callback = function()
        local direction = (y - x).Unit
        local distance = (y - x).Magnitude
        for i = 0, distance, step do
            local pos = x + direction * i
            Plant:FireServer(pos, plap)
            task.wait()
        end
    end
})

--

sell:AddButton({
    Title = "Sell Crops",
    Description = "",
    Callback = function()
        tsf()       
    end
})




--

player:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed",
    Description = "Adjust walkspeed",
    Min = 20,
    Max = 150,
    Default = 20,
    Rounding = 1,
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
     end      
})

--

function prefsh()
    PetsId = {}
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child.Name ~= "PetTemplate" and child:FindFirstChild("PetStats") then
            table.insert(PetsId, child.Name)
        end
    end
    print("Pets updated:")
    for _, id in ipairs(PetsId) do
        print(id)
    end
    return PetsId
end

local pDropdown = pet:AddDropdown("Dropdown", {
    Title = "Choose the pet to feed\n",
    Description = "",
    Values = {},
    Multi = false,
    Default = nil,
})

local function updatePetDropdown()
    local pets = prefsh()
    pDropdown:SetValues(pets)
    if #pets > 0 then
        pDropdown:SetValue(pets[1])
    end
end

pet:AddButton({
    Title = "Refresh Pet",
    Description = "",
    Callback = function()
        updatePetDropdown()
    end
})

local pfeed

pDropdown:OnChanged(function(Value)
    pfeed = Value
    print("Pet selected:", pfeed)
end)

updatePetDropdown()


local autoFeed = false

pet:AddToggle("AutoFeedToggle", {
    Title = "Auto Feed\n",
    Description = "Feeds the selected pet automatically\nBut take the fruit in your hand!\n",
    Default = false,
    Callback = function(Value)
        autoFeed = Value
        if Value then
            spawn(function()
                while autoFeed do
                    if pfeed then
                        feedsc:FireServer("Feed", pfeed)
                        print("Pet fed:", pfeed)
                    else
                        print("No pets selected to feed")
                    end
                    wait(0.3) 
                end
            end)
        end
    end
})

pet:AddButton({
    Title = "Feed Selected Pet",
    Description = "Hold fruit in your inventory.",
    Callback = function()
        if pfeed then
            feedsc:FireServer("Feed", pfeed)
            print("Pet fed:", pfeed)
        else
            print("No pet selected")
        end
    end
})

--

ui:AddSection("Visual")

ui:AddButton({
    Title = "Cosmetic Shop UI",
    Description = "Open the cosmetics store",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("CosmeticShop_UI")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Cosmetic Shop UI:", ui.Enabled and "Activated" or "Deactivated")
        end
    end
})


ui:AddButton({
    Title = "Gear Shop UI",
    Description = "",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Gear Shop UI:", ui.Enabled and "Activated" or "Deactivated")
        end
    end
})


ui:AddButton({
    Title = "Seed Shop UI",
    Description = "",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Seed Shop UI:", ui.Enabled and "Activated" or "Deactivated")
        end
    end
})

ui:AddButton({
    Title = "Daily Quest UI",
    Description = "",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui.DailyQuests_UI
        if ui then
            ui.Enabled = not ui.Enabled
            print("Daily Quest UI:", ui.Enabled and "Activated" or "Deactivated")
        end
    end
})

--





local section = event:AddSection("[🐝] Bee Event")
local ativo = false

event:AddToggle("Auto Trade Machine", {
    Title = "Auto Trade Machine",
    Description = "Equips only Pollinated items and interacts with machine",
    Default = false,
    Callback = function(toggle)
        ativo = toggle
        if not toggle then return end

        task.spawn(function()
            local player = game:GetService("Players").LocalPlayer
            local rs = game:GetService("ReplicatedStorage")

            local function temPollinated(nome)
                return nome:lower():find("pollinated") ~= nil
            end

            while ativo do
                local char = player.Character or player.CharacterAdded:Wait()
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                local mochila = player:FindFirstChild("Backpack")
                local itens = {}

                for _, container in ipairs({char, mochila}) do
                    if container then
                        for _, item in ipairs(container:GetChildren()) do
                            if item:IsA("Tool") and temPollinated(item.Name) then
                                table.insert(itens, item)
                            end
                        end
                    end
                end

                for _, item in ipairs(itens) do
                    if not ativo then return end

                    humanoid:EquipTool(item)
                    task.wait(0.1)

                    ufav()
                    rs.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")

                    local tempo = tick()
                    while ativo and char:FindFirstChildOfClass("Tool") == item do
                        if tick() - tempo >= 2 then
                            rs.GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
                            tempo = tick()
                        end
                        task.wait(0.5)
                    end
                end

                task.wait(0.5)
            end
        end)
    end
})

event:AddButton({
    Title = "Bee Shop UI",
    Description = "",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui.HoneyEventShop_UI
        if ui then
            ui.Enabled = not ui.Enabled
            print("Honey Shop UI:", ui.Enabled and "Activated" or "Deactivated")
        end
    end
})

local byallBee = { "Flower Seed Pack", "Nectarine", "Hive Fruit", "Honey Sprinkler", "Bee Egg", "Bee Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway" }
local buyBee = game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock
local selectedBees = {}
local bsb = false

function byallbeefc()
    for i = 1, 25 do
        for _, bee in ipairs(selectedBees) do
            local args = {
                [1] = bee
            }
            game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock:FireServer(unpack(args))
            task.wait()
        end
    end
end

local section = event:AddSection("Shop")

event:AddToggle("", {
    Title = "Buy Bee Shop",
    Description = "Purchases an item based on selected bee shop.",
    Default = false,
    Callback = function(Value)
        bsb = Value
    end
})

local dropdownBee = event:AddDropdown("DropdownSeed", {
    Title = "Select Beeshop to purchase\n",
    Description = "",
    Values = byallBee,
    Multi = true,
    Default = {},
})

dropdownBee:OnChanged(function(Value)
    selectedBees = {}
    for v, state in pairs(Value) do
        if state then
            table.insert(selectedBees, v)
        end
    end
end)







  
--

task.spawn(function()
    local lastMinute = -1
    while true do
        local minutos = os.date("*t").min
        if minutos ~= lastMinute then
            lastMinute = minutos

            if bsa then
                byallseedfc()
            end
            if bsm then
                byallmoonfc()
            end
            if bsg then
                byallgearfc()
            end
            if bsm2 then
                byallmoon2fc()
            end
            if bsp then
                buypetegg()
            end
            if bsb then 
                byallbeefc()
            end
        end
        task.wait(1)
    end
end)



game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
