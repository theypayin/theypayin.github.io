local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Tween = function(Object, Time, Style, Direction, Property)
	return TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction]), Property)
end
local Credits = task.spawn(function()
    local UserIds = {
        4882533577
    }
    
    if table.find(UserIds, Player.UserId) then
        return
    end
    
    local Tag = Instance.new("BillboardGui")
    local Title = Instance.new("TextLabel", Tag)
    local Rank = Instance.new("TextLabel", Tag)
    local Gradient = Instance.new("UIGradient", Title)
    
    Tag.Brightness = 2
    Tag.Size = UDim2.new(4, 0, 1, 0)
    Tag.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
    
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, .6, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    
    Rank.AnchorPoint = Vector2.new(.5, 0)
    Rank.BackgroundTransparency = 1
    Rank.Position = UDim2.new(.5, 0, .65, 0)
    Rank.Size = UDim2.new(1, 0, .5, 0)
    Rank.TextColor3 = Color3.fromRGB(0, 0, 0)
    Rank.TextScaled = true
    Rank.Text = ""
    
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(.75, .75, .75)),
        ColorSequenceKeypoint.new(.27, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(.5, Color3.new(.3, .6, .5)),
        ColorSequenceKeypoint.new(0.78, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(.75, .75, .75))
    })
    Gradient.Offset = Vector2.new(-1, 0)
    
    local GradientTeen = Tween(Gradient, 2, "Circular", "Out", {Offset = Vector2.new(1, 0)})
    
    function PlayAnimation()
    	GradientTeen:Play()
    	GradientTeen.Completed:Wait()
    	Gradient.Offset = Vector2.new(-1, 0)
    	task.wait(.75)
    	PlayAnimation()
    end
    
    local AddTitle = function(Character)
        repeat task.wait() until Character
        
        local Humanoid = Character and Character:WaitForChild("Humanoid")
        local RootPart = Humanoid and Humanoid.RootPart
        
        if Humanoid then
            Humanoid:GetPropertyChangedSignal("RootPart"):Connect(function()
                if Humanoid.RootPart then
                    Tag.Adornee = RootPart
                end
            end)
        end
        
        if RootPart then
            Tag.Adornee = RootPart
        end
    end
    
    task.spawn(PlayAnimation)
    
    for _, x in next, Players:GetPlayers() do
        if table.find(UserIds, x.UserId) then
            Tag.Parent = workspace.Terrain
            Title.Text = x.Name
            AddTitle(x.Character)
            x.CharacterAdded:Connect(AddTitle)
        end
    end
    
    Players.PlayerAdded:Connect(function(x)
        if table.find(UserIds, x.UserId) then
            Tag.Parent = workspace.Terrain
            Title.Text = x.Name
            x.CharacterAdded:Connect(AddTitle)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(x)
        if table.find(UserIds, x.UserId) then
            Tag.Parent = game
        end
    end)
end)
