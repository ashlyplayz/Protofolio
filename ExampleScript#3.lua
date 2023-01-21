--// These scripts won't work as they will be needing alot of instances

local UI = game:GetService('StarterGui'):WaitForChild('waiting')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local PlayersNeeded = 1

local function UpdateUI(Text)
	for i,v in pairs(game:GetService('Players'):GetPlayers()) do
		if v.PlayerGui and v.PlayerGui:FindFirstChild('waiting') then
			v.PlayerGui:FindFirstChild('waiting').Frame.TextLabel.Text = Text
		end
	end
end

local function AddUI()
	for i,v in pairs(game:GetService('Players'):GetPlayers()) do
		if v.PlayerGui and not v.PlayerGui:FindFirstChild('waiting') then
			UI:Clone().Parent = v.PlayerGui
		end
	end
end

local function RemoveUI()
	for i,v in pairs(game:GetService('Players'):GetPlayers()) do
		if v.PlayerGui and v.PlayerGui:FindFirstChild('waiting') then
			v.PlayerGui:FindFirstChild('waiting'):Destroy()
		end
	end
	game:GetService('StarterGui').waiting.Enabled = false
end

local function LoadCharacters() -- if you need it later
	for i,v in pairs(game:GetService('Players'):GetPlayers()) do
		v:LoadCharacter()
	end
end

AddUI()

repeat wait(1)
	AddUI()
	UpdateUI("waiting for players ("..#game:GetService('Players'):GetPlayers().."/"..PlayersNeeded..")")
	ReplicatedStorage.Receiver:FireAllClients('CameraFocus')
until #game:GetService('Players'):GetPlayers() >= tonumber(PlayersNeeded)

AddUI()
UpdateUI("waiting for players ("..#game:GetService('Players'):GetPlayers().."/"..PlayersNeeded..")")
wait(4)
ReplicatedStorage.Receiver:FireAllClients('CameraFocus')
print('Players Loaded!')
RemoveUI()
LoadCharacters()
RemoveUI()
wait(1)
--ReplicatedStorage.Receiver:FireAllClients('TweenCameraToPlayer')
--wait(1)
ReplicatedStorage.Receiver:FireAllClients('NomalizeCamera')

