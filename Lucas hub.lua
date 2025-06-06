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
print("MADE BY LUCAS\nScript Version " .. script_version.version .. " - " .. script_version.alpha)
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
    Title = "Grow a Garden |",
    SubTitle = "Made by Lucas | Version: ".. vful,
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
    Title = "loja",
    Icon = "home"
})

local plant = Window:AddTab({
    Title = "plant",
    Icon = "list"
})

local sell = Window:AddTab({
    Title = "sell",
    Icon = "list"
})

local player = Window:AddTab({
        Title = "Player",
        Icon = "list"
    })

local pet = Window:AddTab({
        Title = "pet",
        Icon = "list"
    })

local ui = Window:AddTab({
        Title = "UIs",
        Icon = "list"
    })

local event = Window:AddTab({
    Title = "Eventos",
    Icon = "list"
})

local config = Window:AddTab({
    Title = "configurações",
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
    Title = "Buy all shop seed",
    Description = "Buy all shop seed",
    Default = false,
    Callback = function(Value)
        bsa = Value
    end
})

local dropdownSeed = loja:AddDropdown("DropdownSeed", {
    Title = "Selecione seeds para comprar\n",
    Description = "Selecione seeds para comprar\n",
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
    Title = "Buy shop gear",
    Description = "Buy shop gear",
    Default = false,
    Callback = function(Value)
        bsg = Value
    end
})

local dropdownGear = loja:AddDropdown("DropdownGear", {
    Title = "Selecione gears para comprar\n",
    Description = "Selecione gears para comprar\n",
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

local section = loja:AddSection("Pets buy")

loja:AddButton({
        Title = "comprar todos pets",
        Description = "auto se explica",
        Callback = function()
            buypetegg()
        end
    })

loja:AddToggle("", {
        Title = "comprar todos pets afk",
        Description = "auto se explica",
        Default = false,
        Callback = function(value)
         bsp = value
        end
    })

-- 

plant:AddButton({
        Title = "Set local X",
        Description = "click para setar o inicio do auto plant\n",
        Callback = function()
          x = Vector3.new(hrp.Position.X, 0.13552513718605042, hrp.Position.Z)
          print(x)
            
        end
    })

plant:AddButton({
        Title = "Set local Y",
        Description = "click para setar o fim do auto plant\n",
        Callback = function()
          y = Vector3.new(hrp.Position.X, 0.13552513718605042, hrp.Position.Z)
          print(y)
        end
    })

local plantDropdown = plant:AddDropdown("Dropdown", {
    Title = "Selecione a seed\n",
    Description = "Selecione a seed\n",
    Values = pseed,
    Multi = false,
    Default = 1,
})

plantDropdown:OnChanged(function(Value)
    plap = Value
end)

local Slider = plant:AddSlider("Slider", 
{
    Title = "Distancia de uma seed para outra\n",
    Description = "step seed\n",
    Default = 0.001,
    Min = 0.001,
    Max = 0.1,
    Rounding = 3,
    Callback = function(Value)
        step = Value
    end
})

plant:AddButton({
    Title = "click para plantar",
    Description = "esteja com a seed na mão", 
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
    Title = "Vender Colheitas",
    Description = "vende para o seller",
    Callback = function()
        tsf()       
    end
})




--

player:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed",
    Description = "Ajuste a velocidade de caminhada",
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
    print("Pets atualizados:")
    for _, id in ipairs(PetsId) do
        print(id)
    end
    return PetsId
end

local pDropdown = pet:AddDropdown("Dropdown", {
    Title = "Escolha o pet para feed\n",
    Description = "auto se explica\n",
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
    Title = "atualizar pet",
    Description = "Atualiza pets",
    Callback = function()
        updatePetDropdown()
    end
})

local pfeed

pDropdown:OnChanged(function(Value)
    pfeed = Value
    print("Pet selecionado:", pfeed)
end)

updatePetDropdown()


local autoFeed = false

pet:AddToggle("AutoFeedToggle", {
    Title = "Alimentação Automática\n",
    Description = "Alimenta o pet selecionado automaticamente\nPorem pegue a comida na mão!\n",
    Default = false,
    Callback = function(Value)
        autoFeed = Value
        if Value then
            spawn(function()
                while autoFeed do
                    if pfeed then
                        feedsc:FireServer("Feed", pfeed)
                        print("Pet alimentado:", pfeed)
                    else
                        print("Nenhum pet selecionado para alimentar")
                    end
                    wait(0.3) 
                end
            end)
        end
    end
})

pet:AddButton({
    Title = "Alimentar pet selecionado",
    Description = "Segure comida na mão!",
    Callback = function()
        if pfeed then
            feedsc:FireServer("Feed", pfeed)
            print("Pet alimentado:", pfeed)
        else
            print("Nenhum pet selecionado")
        end
    end
})

--

ui:AddSection("Controle de UIs")

ui:AddButton({
    Title = "Cosmetic Shop UI",
    Description = "Ativa/Desativa a loja de cosméticos",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("CosmeticShop_UI")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Cosmetic Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})


ui:AddButton({
    Title = "Gear Shop UI",
    Description = "Ativa/Desativa a loja de equipamentos",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Gear Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})


ui:AddButton({
    Title = "Seed Shop UI",
    Description = "Ativa/Desativa a loja de sementes",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
        if ui then
            ui.Enabled = not ui.Enabled
            print("Seed Shop UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})

ui:AddButton({
    Title = "Daily quest UI",
    Description = "Ativa/Desativa a Daily quest ui",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui.DailyQuests_UI
        if ui then
            ui.Enabled = not ui.Enabled
            print("Daily Quest UI:", ui.Enabled and "Ativada" or "Desativada")
        end
    end
})

--





local section = event:AddSection("Honey | bizze")
local ativo = false

event:AddToggle("Auto Trade Machine", {
    Title = "Auto trade event machine\n",
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
    Title = "Honey Shop UI",
    Description = "Ativa/Desativa a loja de Honey",
    Callback = function()
        local ui = game:GetService("Players").LocalPlayer.PlayerGui.HoneyEventShop_UI
        if ui then
            ui.Enabled = not ui.Enabled
            print("Honey Shop UI:", ui.Enabled and "Ativada" or "Desativada")
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

local section = event:AddSection("Shop Honey")

event:AddToggle("", {
    Title = "Buy all Bee Shop",
    Description = "Buy all Bee shop",
    Default = false,
    Callback = function(Value)
        bsb = Value
    end
})

local dropdownBee = event:AddDropdown("DropdownSeed", {
    Title = "Selecione Beeshop para comprar\n",
    Description = "Selecione Beeshop para comprar\n",
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
