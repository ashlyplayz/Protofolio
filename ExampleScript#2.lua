--// These scripts won't work as they will be needing alot of instances

local Players = game:GetService("Players")
local Part = workspace.SafeZones.SF1
local PlayersTouching = {}
local AllPlayersTouching = false

local function OnPlayerTouching(Player)
	if Player and not Player.Character:FindFirstChild('InSafeZone') then
		local ins = Instance.new('StringValue')
		ins.Name = "InSafeZone"
		ins.Parent = Player.Character
	end
end

local function OnStopTouching(Player)
	if Player and Player.Character:FindFirstChild('InSafeZone') then
		Player.Character:FindFirstChild('InSafeZone'):Destroy()
	end
end


Part.Touched:Connect(function(TouchingPart: BasePart)
	for Index: number, Player: Player in Players:GetPlayers() do
		if Player.Character and Player.Character.PrimaryPart and TouchingPart == Player.Character.PrimaryPart then
			table.insert(PlayersTouching, Player)
			OnPlayerTouching(Player)
			break
		end
		continue
	end
end)

Part.TouchEnded:Connect(function(TouchingPart: BasePart)
	for Index: number, Player: Player in Players:GetPlayers() do
		if Player.Character and Player.Character.PrimaryPart and TouchingPart == Player.Character.PrimaryPart then
			local Index = table.find(PlayersTouching, Player)

			if Index then
				table.remove(PlayersTouching, Index)
				OnStopTouching(Player)
			end

		end
	end
end)
