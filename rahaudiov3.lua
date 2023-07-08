if getgenv().AudioSnatcher then
	if AudioSnatcher.Parent then
		Print("Rahmeri's Audio Snatcher already exists!")
		return
	else
		getgenv().AudioSnatcher = nil
	end
end

local Players = game:GetService("Players")
local MPS = game:GetService("MarketplaceService")
local CG = game:GetService("CoreGui")

local Print = print

Print("Rahmeri's Audio Snatcher made by Rahmeri (583370924619857927) @ bork gang.")

local Copystring = setclipboard or toclipboard or Synapse and Synapse.CopyString or Clipboard and Clipboard.set or nil
if not Copystring then
	Print("Rahmeri's Audio Snatcher - Clipboard Copying is not available.")
else
	Print("Rahmeri's Audio Snatcher - Clipboard Copying is available.")
end

local IDsOnly = true --// Setting this to false will disable ID logging.
local HashesOnly = true --// Setting this to false will disable hash logging.
local VersionIDsOnly = true --// Setting this to false will disable VersionID logging.
local LogSelf = true --// Setting this to false will ignore your sounds completely.
local LogRecent = false --// Setting this to true will make it so the logger won't log anything played by the same player more than once until they play a different audio.
local IsActive = true --// Setting this to false will by default disable the logger.

local MostRecentAudio = {}

if AudioSnatcherConnections then
	for I, V in next, AudioSnatcherConnections do
		if typeof(V) == "RBXScriptConnection" and V.Connected then
			V:Disconnect()
			AudioSnatcherConnections[I] = nil
		end
	end
end

if HookedAudios then
	for I, V in next, HookedAudios do
		if I:IsA("Instance") then
			getgenv().HookedAudios[I] = nil
			I:Destroy()
		end
	end
end

getgenv().AudioList = {}
getgenv().HookedAudios = {}
getgenv().AudioSnatcherConnections = {}

getgenv().Blacklisted = { --// Throw in the audio IDs/Hashes you don't want to snatch.
	154482724,
	1352366478,
	281156569,
	28166555,
	169259022,
	154965929,
	147722098,
	204139415,
	169285411,
	328964620,
	256471452,
	861978247,
	175024455,
	311319322,
	142383762,
	335069960,
	181027147,
	344936319,
	142429556,
	78496487,
	344936269,
	328964589,
	311319345,
	362709353,
	219397110,
	229409838,
	156444949,
	10722059,
	"rbxasset://sounds/action_get_up.mp3",
	"rbxasset://sounds/uuhhh.mp3",
	"rbxasset://sounds/action_falling.mp3",
	"rbxasset://sounds/action_jump.mp3",
	"rbxasset://sounds/action_jump_land.mp3",
	"rbxasset://sounds/impact_water.mp3",
	"rbxasset://sounds/action_swim.mp3",
	"rbxasset://sounds/action_footsteps_plastic.mp3",
}

getgenv().SpecialTools = {
	Enabled = false,
	Instances = {
		"BoomBox",
		"Boombox",
		"Torso",
	}
}

local function CompileList()
	local List = {}
	
	for I, V in next, AudioList do
		table.insert(List, I)
	end
	
	if #List > 0 then
		return table.concat(List, "\n")
	end
	return "{}"
end

getgenv().AudioSnatcher = Instance.new("ScreenGui")
AudioSnatcher.Name = "Rahmeri's Audio Snatcher"

local Copy = Instance.new("TextButton")
Copy.Name = "Copy"
Copy.Size = UDim2.new(.13, 0, .07, 0)
Copy.Position = UDim2.new(.04, 0, .84)
Copy.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
Copy.TextScaled = true
Copy.TextColor3 = Color3.fromRGB(255, 255, 255)
Copy.TextStrokeTransparency = .75
Copy.Text = "Copy Audios"
Copy.ZIndex = 10
Copy.Font = Enum.Font.SourceSansBold

local Hashes = Instance.new("TextButton")
Hashes.Name = "Hashes"
Hashes.Size = UDim2.new(.13, 0, .07, 0)
Hashes.Position = UDim2.new(.04, 0, .77)
Hashes.Style = not HashesOnly and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
Hashes.TextScaled = true
Hashes.TextColor3 = Color3.fromRGB(255, 255, 255)
Hashes.TextStrokeTransparency = .75
Hashes.Text = "Hashes"
Hashes.ZIndex = 10
Hashes.Font = Enum.Font.SourceSansBold

local IDs = Instance.new("TextButton")
IDs.Name = "ID"
IDs.Size = UDim2.new(.13, 0, .07, 0)
IDs.Position = UDim2.new(.04, 0, .7)
IDs.Style = not IDsOnly and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
IDs.TextScaled = true
IDs.TextColor3 = Color3.fromRGB(255, 255, 255)
IDs.TextStrokeTransparency = .75
IDs.Text = "ID"
IDs.ZIndex = 10
IDs.Font = Enum.Font.SourceSansBold

local VersionIDs = Instance.new("TextButton")
VersionIDs.Name = "VersionID"
VersionIDs.Size = UDim2.new(.13, 0, .07, 0)
VersionIDs.Position = UDim2.new(.04, 0, .63)
VersionIDs.Style = not VersionIDsOnly and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
VersionIDs.TextScaled = true
VersionIDs.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionIDs.TextStrokeTransparency = .75
VersionIDs.Text = "Version ID"
VersionIDs.ZIndex = 10
VersionIDs.Font = Enum.Font.SourceSansBold

local Self = Instance.new("TextButton")
Self.Name = "Self"
Self.Size = UDim2.new(.13, 0, .07, 0)
Self.Position = UDim2.new(.17, 0, .7)
Self.Style = not LogSelf and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
Self.TextScaled = true
Self.TextColor3 = Color3.fromRGB(255, 255, 255)
Self.TextStrokeTransparency = .75
Self.Text = "Log Self"
Self.ZIndex = 10
Self.Font = Enum.Font.SourceSansBold

local Recent = Instance.new("TextButton")
Recent.Name = "Recent"
Recent.Size = UDim2.new(.13, 0, .07, 0)
Recent.Position = UDim2.new(.17, 0, .77)
Recent.Style = not LogRecent and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
Recent.TextScaled = true
Recent.TextColor3 = Color3.fromRGB(255, 255, 255)
Recent.TextStrokeTransparency = .75
Recent.Text = "Log Recent"
Recent.ZIndex = 10
Recent.Font = Enum.Font.SourceSansBold

local Active = Instance.new("TextButton")
Active.Name = "Active"
Active.Size = UDim2.new(.13, 0, .07, 0)
Active.Position = UDim2.new(.17, 0, .84)
Active.Style = not IsActive and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
Active.TextScaled = true
Active.TextColor3 = Color3.fromRGB(255, 255, 255)
Active.TextStrokeTransparency = .75
Active.Text = "Active"
Active.ZIndex = 10
Active.Font = Enum.Font.SourceSansBold

Copy.Parent = AudioSnatcher
Hashes.Parent = AudioSnatcher
IDs.Parent = AudioSnatcher
VersionIDs.Parent = AudioSnatcher
Self.Parent = AudioSnatcher
Recent.Parent = AudioSnatcher
Active.Parent = AudioSnatcher

AudioSnatcher.Parent = CG

Hashes.MouseButton1Click:Connect(function()
	HashesOnly = not HashesOnly
	Hashes.Style = not HashesOnly and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
end)

IDs.MouseButton1Click:Connect(function()
	IDsOnly = not IDsOnly
	IDs.Style = not IDsOnly and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
end)

VersionIDs.MouseButton1Click:Connect(function()
	VersionIDsOnly = not VersionIDsOnly
	VersionIDs.Style = not VersionIDsOnly and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
end)

Self.MouseButton1Click:Connect(function()
	LogSelf = not LogSelf
	Self.Style = not LogSelf and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
end)

Recent.MouseButton1Click:Connect(function()
	LogRecent = not LogRecent
	Recent.Style = not LogRecent and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
end)

Active.MouseButton1Click:Connect(function()
	IsActive = not IsActive
	Active.Style = not IsActive and Enum.ButtonStyle.RobloxRoundButton or Enum.ButtonStyle.RobloxRoundDefaultButton
end)

Copy.MouseButton1Click:Connect(function()
	if Copystring then
		local Status, Result = pcall(Copystring, CompileList())
		if Status then
			Print("Rahmeri's Audio Snatcher - Successfully copied list.")
		else
			Print("Rahmeri's Audio Snatcher - Failed to copy list. " .. "(" .. Result .. ")")
		end
	else
		Print("Rahmeri's Audio Snatcher - Failed to copy list. " .. "(Function not available)")
	end
end)

local function DoesCheckout(SoundId, Player)
	local Info
	local Id = string.match(SoundId, "rbxasset://sounds.+") or string.match(SoundId, "versionid=.+") or string.match(SoundId, "%p76.+=.+") or string.match(SoundId, "hash=.+") or string.match(SoundId, "%d+")
	
	local IsHash, IsVersionID = false, false
	if Id then
		if string.match(Id, "hash=.+") then
			Id = string.match(Id, "hash=(.+)")
			IsHash = true
		elseif string.match(Id, "versionid=.+") then
			Id = string.match(Id, "versionid=(.+)")
			IsVersionID = true
		elseif string.match(Id, "%p76.+=.+") then
			Id = string.match(Id, "%p76.+=(.+)")
			IsVersionID = true
		end
	end
	
	local Continue = true
	for I, V in next, Blacklisted do
		if Id == tostring(V) then
			Continue = false
			break
		end
	end
	
	if Continue and (LogRecent or not LogRecent and (not MostRecentAudio[Player] or MostRecentAudio[Player] ~= Id)) then
		local Status, Product = pcall(MPS.GetProductInfo, MPS, tonumber(Id), Enum.InfoType.Asset)
		if IsVersionID or IsHash or Product and Product.AssetTypeId == 3 then
			Info = IsVersionID and "VersionID" or IsHash and "Hash" or Product and Product.Name or nil
		end
	end
	return Info, Id
end

local function HookAudio(Sound, Player)
	if not HookedAudios[Sound] then
		table.insert(AudioSnatcherConnections, Sound.Changed:Connect(function(Property)
			if Property == "SoundId" then
				if not IsActive or IsActive and not LogSelf and Player == Players.LocalPlayer then
					return
				end
				
				local Info, Id = DoesCheckout(Sound.SoundId, Player)
				if Info then
					local IsHash, IsVersionID = Info == "Hash", Info == "VersionID"
					if IsHash and HashesOnly or IsVersionID and VersionIDsOnly or not IsHash and not IsVersionID and IDsOnly then
						getgenv().HookedAudios[Sound] = true
						MostRecentAudio[Player] = Id
						
						local Name = (IsHash or IsVersionID) and "Unknown" or Info or "Error fetching Name"
						local Audio = "{\n    " .. (IsHash and "Hash: " or IsVersionID and "VersionId: " or "SoundId: ") .. (Id or "Error fetching ID") .. "\n    Player: " .. Player.Name .. "\n    Name: " .. Name .. "\n}"
						if not AudioList[Audio] then
							getgenv().AudioList[Audio] = true
						end
						
						Print("Changed Audio" .. (IsHash and " (Hash)" or IsVersionID and " (VersionID)" or "") .. "\n" .. (IsHash and "Hash: " or IsVersionID and "VersionId: " or "SoundId: ") .. (Id or "Error fetching Id") .. "\nPlayer: " .. Player.Name .. "\nAncestry: " .. Sound:GetFullName() .. "\nName: " .. Name)
					end
				end
			end
		end))
	end
	
	local Info, Id = DoesCheckout(Sound.SoundId, Player)
	if IsActive and Info then
		local IsHash, IsVersionID = Info == "Hash", Info == "VersionID"
		if (LogRecent or not LogRecent and not HookedAudios[Sound]) and (LogSelf or not LogSelf and Player ~= Players.LocalPlayer) and (IsHash and HashesOnly or IsVersionID and VersionIDsOnly or not IsHash and not IsVersionID and IDsOnly) then
			getgenv().HookedAudios[Sound] = true
			MostRecentAudio[Player] = Id
			
			local Name = (IsHash or IsVersionID) and "Unknown" or Info or "Error fetching Name"
			local Audio = "{\n    " .. (IsHash and "Hash: " or IsVersionID and "VersionId: " or "SoundId: ") .. (Id or "Error fetching ID") .. "\n    Player: " .. Player.Name .. "\n    Name: " .. Name .. "\n}"
			if not AudioList[Audio] then
				getgenv().AudioList[Audio] = true
			end
			
			Print("Snatched Audio" .. (IsHash and " (Hash)" or IsVersionID and " (VersionID)" or "") .. "\n" .. (IsHash and "Hash: " or IsVersionID and "VersionId: " or "SoundId: ") .. (Id or "Error fetching Id") .. "\nPlayer: " .. Player.Name .. "\nAncestry: " .. Sound:GetFullName() .. "\nName: " .. Name)
		end
	end
end

table.insert(AudioSnatcherConnections, Players.LocalPlayer.Chatted:Connect(function(Message)
	if string.lower(Message) == "a_s console" and printconsole then
		if Print == printconsole then
			Print("Print setting is already set to printconsole")
		else
			Print = printconsole
			Print("Switched to console print")
		end
	elseif string.lower(Message) == "a_s output" and printoutput then
		if Print == printoutput then
			Print("Print setting is already set to printoutput")
		else
			Print = printoutput
			Print("Switched to output print")
		end
	elseif string.lower(Message) == "a_s print" then
		if Print == print then
			Print("Print setting is already set to default print")
		else
			Print = print
			Print("Switched to default print")
		end
	end
end))

local function AddPlayer(Player)
	local function AddCharacter(Character)
		delay(.3, function()
			if not SpecialTools.Enabled then
				for I, V in next, Character:GetDescendants() do
					if V:IsA("Sound") and not V:FindFirstChild("CharacterSoundEvent") then
						local Status, Result = pcall(HookAudio, V, Player)
						if not Status then
							Print("Audio Snatcher Protected Call Error: " .. Result)
						end
					end
				end
			else
				for I, V in next, SpecialTools.Instances do
					local Object = Character:FindFirstChild(V)
					if Object then
						for J, K in next, Object:GetDescendants() do
							if K:IsA("Sound") and not K:FindFirstChild("CharacterSoundEvent") then
								local Status, Result = pcall(HookAudio, K, Player)
								if not Status then
									Print("Audio Snatcher Protected Call Error: " .. Result)
								end
							end
						end
					end
				end
			end
		end)
		
		table.insert(AudioSnatcherConnections, Character.DescendantAdded:Connect(function(Object)
			if Object:IsA("Sound") and not Object:FindFirstChild("CharacterSoundEvent") then
				if not SpecialTools.Enabled then
					local Status, Result = pcall(HookAudio, Object, Player)
					if not Status then
						Print("Audio Snatcher Protected Call Error: " .. Result)
					end
				else
					for I, V in next, SpecialTools.Instances do
						local FoundObject = Character:FindFirstChild(V)
						if FoundObject and Object:IsDescendantOf(FoundObject) then
							local Status, Result = pcall(HookAudio, Object, Player)
							if not Status then
								Print("Audio Snatcher Protected Call Error: " .. Result)
							end
						end
					end
				end
			end
		end))
		
		table.insert(AudioSnatcherConnections, Character.DescendantRemoving:Connect(function(Object)
			if HookedAudios[Object] then
				getgenv().HookedAudios[Object] = nil
			end
		end))
	end
	
	AddCharacter(Player.Character or Player.CharacterAdded:Wait())
	wait(.5)
	table.insert(AudioSnatcherConnections, Player.CharacterAdded:Connect(AddCharacter))
end

for I, V in next, Players:GetPlayers() do
	AddPlayer(V)
end

table.insert(AudioSnatcherConnections, Players.PlayerAdded:Connect(AddPlayer))
