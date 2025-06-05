local KaiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/takgoo170/Beta_Kai_Scripts/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local VIM = game:GetService("VirtualInputManager")

local Window = KaiUI:CreateWindow({
    Title = "Kai Hub | Blue Lock: Rivals",
    SubTitle = "by Kai Team | (discord.gg/wDMPK3QAmY)",
    TabWidth = 149,
    Size = UDim2.fromOffset(540, 375),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-------------- TABS ---------------------
local info = Window:AddTab({ Title = "Info", Icon = "info" })
local farm = Window:AddTab({ Title = "Auto Farm", Icon = "swords" })
local stats = Window:AddTab({ Title = "Stats", Icon = "scroll" })
local gstats = Window:AddTab({ Title = "Game Stats", Icon = "scroll" })
local esp = Window:AddTab({ Title = "ESP", Icon = "visibility" })
local styles = Window:AddTab({ Title = "Styles", Icon = "brush" })
local flow = Window:AddTab({ Title = "Flow", Icon = "waves" })
local misc = Window:AddTab({ Title = "Misc", Icon = "settings" })

------------------ FUNCTION -----------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 100
local maxFlySpeed = 1000
local speedIncrement = 0.4
local originalGravity = workspace.Gravity

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local function randomizeValue(value, range)
    return value + (value * (math.random(-range, range) / 100))
end

local function fly()
    while flying do
        local MoveDirection = Vector3.new()
        local cameraCFrame = workspace.CurrentCamera.CFrame

        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.W) and cameraCFrame.LookVector or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.S) and cameraCFrame.LookVector or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.A) and cameraCFrame.RightVector or Vector3.new())
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.D) and cameraCFrame.RightVector or Vector3.new())
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, 1, 0) or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Vector3.new(0, 1, 0) or Vector3.new())

        if MoveDirection.Magnitude > 0 then
            flySpeed = math.min(flySpeed + speedIncrement, maxFlySpeed)
            MoveDirection = MoveDirection.Unit * math.min(randomizeValue(flySpeed, 10), maxFlySpeed)
            HumanoidRootPart.Velocity = MoveDirection * 0.5
        else
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end

        RunService.RenderStepped:Wait()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            workspace.Gravity = 0
            fly()
        else
            flySpeed = 100
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            workspace.Gravity = originalGravity
        end
    end
end)

local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local ball = game.Workspace:FindFirstChild("Football")
local autoFarmEnabled = false
local autoFarmTweenEnabled = false

local function autoGoal()
    while autoGoalEnabled do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local football = character and character:FindFirstChild("Football")
        
        if football and rootPart then
            local goal = player.Team.Name == "Away" and workspace.Goals.Away or workspace.Goals.Home
            rootPart.CFrame = goal.CFrame
            
            local ShootRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot
            ShootRemote:FireServer(60, nil, nil, Vector3.new(-0.6976264715194702, -0.3905344605445862, -0.6006664633750916))
        end
        task.wait()
    end
end

local function autoGoalKeeper()
	local ball
	while autoGoalKeeperEnabled do
		ball = workspace:FindFirstChild("Football")
		if ball and ball.AssemblyLinearVelocity.Magnitude > 5 then
			rootPart.CFrame = CFrame.new(
				ball.Position + (ball.AssemblyLinearVelocity * 0.1)
			)
		end
		task.wait()
	end
end
local function autoFarm()
    if not (autoFarmEnabled or autoFarmTweenEnabled) then return end

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    local GameValues = ReplicatedStorage.GameValues
    local SlideRemote = ReplicatedStorage.Packages.Knit.Services.BallService.RE.Slide
    local ShootRemote = ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot
    local GoalsFolder = workspace.Goals
    local AwayGoal, HomeGoal = GoalsFolder.Away, GoalsFolder.Home

    local function IsInGame()
        return GameValues.State.Value == "Playing"
    end

    local function IsScored()
        return GameValues.Scored.Value
    end

    local function IsVisitor()
        return LocalPlayer.Team.Name == "Visitor"
    end

    local function JoinGame()
        if not IsVisitor() then return end
        for _, v in ipairs(ReplicatedStorage.Teams:GetDescendants()) do
            if v:IsA("ObjectValue") and v.Value == nil then
                local args = {string.sub(v.Parent.Name, 1, #v.Parent.Name - 4), v.Name}
                ReplicatedStorage.Packages.Knit.Services.TeamService.RE.Select:FireServer(unpack(args))
            end
        end
    end

    local function StealBall()
        if not IsInGame() or IsScored() then return end
        
        local Football = workspace:FindFirstChild("Football")
        if rootPart and Football and not Football.Anchored and Football.Char.Value ~= character then
            if autoFarmEnabled then
                rootPart:PivotTo(CFrame.new(Football.Position.X, 9, Football.Position.Z))
            else
                local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = CFrame.new(Football.Position.X, 9, Football.Position.Z)})
                tween:Play()
                tween.Completed:Wait()
            end
        end

        for _, OtherPlayer in ipairs(Players:GetPlayers()) do
            if OtherPlayer ~= LocalPlayer and OtherPlayer.Team ~= LocalPlayer.Team then
                local OtherCharacter = OtherPlayer.Character
                local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Football")
                local OtherHRP = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")
                
                if OtherFootball and OtherHRP and rootPart then
                    if autoFarmEnabled then
                        rootPart:PivotTo(OtherFootball.CFrame * CFrame.new(0, 3, 0))
                    else
                        local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = OtherFootball.CFrame * CFrame.new(0, 3, 0)})
                        tween:Play()
                        tween.Completed:Wait()
                    end
                    SlideRemote:FireServer()
                    break
                end
            end
        end
  end

  JoinGame()
    if IsVisitor() and not IsInGame() then return end
    StealBall()
    
    local PlayerFootball = character and character:FindFirstChild("Football")

    if PlayerFootball then
        ShootRemote:FireServer(60, nil, nil, Vector3.new(-0.6976264715194702, -0.3905344605445862, -0.6006664633750916))
    end

    local Football = workspace:FindFirstChild("Football")
    if Football and Football.Char.Value ~= character then return end

    if Football:FindFirstChild("BodyVelocity") then
        Football.BodyVelocity:Destroy()
    end

    local Goal = LocalPlayer.Team.Name == "Away" and AwayGoal or HomeGoal
    
    if rootPart then
        rootPart:PivotTo(Goal.CFrame)
    end
    
    local BV = Instance.new("BodyVelocity")
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = Football
    Football.CFrame = Goal.CFrame
    task.delay(0.1, function()
        BV:Destroy()
    end)
end

local function autoSteal()
    if not IsInGame() or IsScored() then return end
        
    local Football = workspace:FindFirstChild("Football")
    if rootPart and Football and not Football.Anchored and Football.Char.Value ~= character then
        if autoFarmEnabled then
            rootPart:PivotTo(CFrame.new(Football.Position.X, 9, Football.Position.Z))
        else
            local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = CFrame.new(Football.Position.X, 9, Football.Position.Z)})
            tween:Play()
            tween.Completed:Wait()
        end
    end

    for _, OtherPlayer in ipairs(Players:GetPlayers()) do
        if OtherPlayer ~= LocalPlayer and OtherPlayer.Team ~= LocalPlayer.Team then
            local OtherCharacter = OtherPlayer.Character
            local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Football")
            local OtherHRP = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")
            
            if OtherFootball and OtherHRP and rootPart then
                if autoFarmEnabled then
                    rootPart:PivotTo(OtherFootball.CFrame * CFrame.new(0, 3, 0))
                else
                    local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = OtherFootball.CFrame * CFrame.new(0, 3, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                end
                SlideRemote:FireServer()
                break
            end
        end
    end
end

local function CreateESPPart(parent, size, color)
    local esp = Instance.new("BoxHandleAdornment")
    esp.Name = "ESP"
    esp.Size = size
    esp.Color3 = color
    esp.AlwaysOnTop = true
    esp.ZIndex = 5
    esp.Transparency = 0
    esp.Adornee = parent
    esp.Parent = parent
    return esp
end

local function CreateTracer(parent)
    local tracer = Instance.new("Beam")
    local attachment0 = Instance.new("Attachment")
    local attachment1 = Instance.new("Attachment")
    tracer.AlwaysOnTop = true
    tracer.Name = "Tracer"
    tracer.FaceCamera = true
    tracer.Width0 = 0.2
    tracer.Width1 = 0.2
    tracer.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
    
    attachment0.Parent = parent
    attachment1.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    
    tracer.Attachment0 = attachment0
    tracer.Attachment1 = attachment1
    tracer.Parent = parent
    
    return tracer
end

local function UpdatePlayerESP()
    while PlayerESPEnabled do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local esp = hrp:FindFirstChild("ESP")
                    if not esp then
                        CreateESPPart(hrp, Vector3.new(2,5,2), Color3.fromRGB(255, 0, 0))
                    end
                end
            end
        end
        task.wait()
    end
end

local function UpdateTeamESP()
    while TeamESPEnabled do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Team then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local esp = hrp:FindFirstChild("ESP")
                    if not esp then
                        local color = player.Team.Name == "Home" and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 0, 0)
                        CreateESPPart(hrp, Vector3.new(2,5,2), color)
                    end
                end
            end
        end
        task.wait()
    end
end

local function UpdateFootballESP()
    while FootballESPEnabled or TracerEnabled do
        local ball = workspace:FindFirstChild("Football")
        if ball then
            if FootballESPEnabled then
                local esp = ball:FindFirstChild("ESP")
                if not esp then
                    CreateESPPart(ball, Vector3.new(2,2,2), Color3.fromRGB(255, 165, 0))
                end
            else
                local esp = ball:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
            
            if TracerEnabled then
                local tracer = ball:FindFirstChild("Tracer")
                if not tracer then
                    CreateTracer(ball)
                end
            else
                local tracer = ball:FindFirstChild("Tracer")
                if tracer then 
                    tracer:Destroy() 
                    ball:FindFirstChild("Attachment"):Destroy()
                end
            end
        end
        task.wait()
    end
end

local function ClearESP()
    local ball = workspace:FindFirstChild("Football")
    if ball then
        local esp = ball:FindFirstChild("ESP")
        local tracer = ball:FindFirstChild("Tracer")
        local attachment = ball:FindFirstChild("Attachment")
        
        if esp then esp:Destroy() end
        if tracer then tracer:Destroy() end
        if attachment then attachment:Destroy() end
    end
end

local function ClearPlayerESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local esp = hrp:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end

local function ClearTeamESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local esp = hrp:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end

--------------- FARM TAB ---------------
farm:AddToggle("Toggle", {
    Title = "Auto Farm"
    Description = "",
    Default = false
  })
Toggle:OnChanged(function(Value)
    autoFarmEnabled = Value
        if Value then autoFarmTweenEnabled = false end
  end)

farm:AddToggle("Toggle", {
    Title = "Auto Steal",
    Description = "",
    Default = false
  })
Toggle:OnChanged(function(Value)
    StealBall = Value
        if Value then
             task.spawn(autoSteal)
        else
            task.cancel(autoSteal)
        end
  end)

farm:AddToggle("Toggle", {
    Title = "Auto Goal",
    Description = "will automatically score goals when enabled",
    Default = false
  })
Toggle:OnChanged(function(Value)
    autoGoalEnabled = Value
        if Value then
            task.spawn(autoGoal)
        else
            task.cancel(autoGoal)
        end
  end)

farm:AddToggle("Toggle", {
    Title = "Auto Goal Keeper",
    Description = "",
    Default = false
  })
Toggle:OnChanged(function(Value)
    autoBallRadiusEnabled = Value
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local visualRadius = Instance.new("Part")
        visualRadius.Shape = Enum.PartType.Ball
        visualRadius.Material = Enum.Material.ForceField
        visualRadius.Size = Vector3.new(120, 120, 120)
        visualRadius.Color = Color3.fromRGB(0, 170, 255)
        visualRadius.CastShadow = false
        visualRadius.Anchored = true
        visualRadius.CanCollide = false
        visualRadius.CanTouch = false
        visualRadius.CanQuery = false
        visualRadius.Transparency = 0.5
        visualRadius.Parent = workspace
        
        if Value then
            task.spawn(function()
                while autoBallRadiusEnabled do
                    if rootPart then
                        visualRadius.Position = rootPart.Position
                    end
                    task.wait()
                end
            end)
            
            task.spawn(function() 
                while autoBallRadiusEnabled do
                    local Football = workspace:FindFirstChild("Football")
                    if Football and rootPart and not Football.Anchored and Football.Char.Value ~= character then
                        local distance = (Football.Position - rootPart.Position).Magnitude
                        if distance <= 120 then
                            local ballVelocity = Football.Velocity.Unit
                            local predictedPos = Football.Position + (ballVelocity * 2)
                            
                            local lookAt = CFrame.new(predictedPos, Football.Position)
                            rootPart.CFrame = lookAt + (lookAt.LookVector * 2)
                        end
                    end
                    task.wait()
                end
            end)
        else
            visualRadius:Destroy()
        end
    end
})

farm:AddToggle("Toggle", {
  Title = "Auto TP Ball",
  Description = "teleport on purpose to the ball",
  Default = false
})
Toggle:OnChanged(function(Value)
  autoTPBallEnabled = Value
        if Value then
            task.spawn(function()
                while autoTPBallEnabled do
                    if Football and rootPart then
                        rootPart.CFrame = Football.CFrame
                    end
                    task.wait()
                end
            end)
        end
    end)

farm:AddSection("Other")
farm:AddToggle("Toggle", {
  Title = "No CD",
  Description = "",
  Default = false
})
Toggle:OnChanged(function(Value)
  noCDEnabled = Value
		local AbilityController = require(game:GetService("ReplicatedStorage").Controllers.AbilityController)

		if Value then
			if not AbilityController._OriginalAbilityCooldown then
				AbilityController._OriginalAbilityCooldown = AbilityController.AbilityCooldown
			end

			AbilityController.AbilityCooldown = function(s, n, ...)
				return AbilityController._OriginalAbilityCooldown(s, n, 0, ...)
			end
		else
			if AbilityController._OriginalAbilityCooldown then
				AbilityController.AbilityCooldown = AbilityController._OriginalAbilityCooldown
				AbilityController._OriginalAbilityCooldown = nil
			end
		end
end)

farm:AddToggle("Toggle", {
  Title = "Anti AFK"
  Description = "kick due to inactivity can be avoided",
  Default = true
})
Toggle:OnChanged(function(Value)
  antiAFKEnabled = Value
		if Value then
			task.spawn(antiAFK)
			KaiUI:Notify({
				Title = "Anti-AFK Enabled",
				Content = "You will not be kicked for inactivity",
        Duration = 6
			})
		end
end)

  
