local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local Remote = script:WaitForChild('RemoteEvent')
local LMBs = {
	LMB1 = "rbxassetid://12493839985";
	LMB2 = "rbxassetid://12493839985";
	LMB3 = "rbxassetid://12493839985";
};
local MaxLMBs = 3 --// Max LMBS
local HeavyAnim = Humanoid:LoadAnimation(script:WaitForChild('Heavy'))
local ParryAnim = Humanoid:LoadAnimation(script:WaitForChild('Heavy'))
local LMBsAnim = {}
local UserInputService = game:GetService('UserInputService')
for i,v in pairs(LMBs) do
	local anim = Instance.new('Animation')
	anim.AnimationId = v
	local Load = Humanoid:LoadAnimation(anim)
	LMBsAnim[i] = Load
end

local function GetHitbox(Range)
	local tab = {}
	for i,v in pairs(workspace:GetChildren()) do
		if v:IsA('Model') and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0
			and v ~= Character and v:FindFirstChild('HumanoidRootPart') and
			(v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude < Range
		then
			table.insert(tab, v)
		end
	end
	return tab
end

local NormalCD = false
local HeavyCD = false
local ParryCD = false

local function Normal()
	if NormalCD then return end
	local Combo = Character:FindFirstChild('Combo')
	if Combo then
		local old = Combo.Value
		Combo:Destroy()
		Combo= Instance.new('NumberValue')
		game.Debris:AddItem(Combo, 0.5)
		Combo.Name = "Combo"
		Combo.Value = old+1
		Combo.Parent = Character 
	else
		Combo= Instance.new('NumberValue')
		game.Debris:AddItem(Combo, 0.5)
		Combo.Name = "Combo"
		Combo.Value = 1
		Combo.Parent = Character
	end
	print('LMB'..Combo.Value)
	if Combo.Value < MaxLMBs then
		LMBsAnim["LMB"..Combo.Value]:Play()
		wait(0.25) --// how fast
		local hit = GetHitbox(8)
		Remote:FireServer("DoDamage", hit, 15)
	elseif Combo.Value >= MaxLMBs then
		Combo:Destroy()
		LMBsAnim["LMB"..Combo.Value]:Play()
		wait(0.25) --// how fast
		local hit = GetHitbox(8)
		Remote:FireServer("DoDamage", hit, 15)
		NormalCD = true
		wait(2.5)
		NormalCD = false
	end
end

local function Heavy()
	if HeavyCD then return end
	HeavyCD = true
	HeavyAnim:Play()
	wait(0.15)
	local hit = GetHitbox(8)
	print('Heavy')
	Remote:FireServer("DoDamage", hit, 15)
	wait(2.5)
	HeavyCD = false
end

local function Parry()
	if HeavyCD then return end
	ParryCD = true
	print('Parry')
	Remote:FireServer("Parry")
	wait(2.5)
	ParryCD = false
end

UserInputService.InputBegan:Connect(function(input, gc)

	if gc then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		Normal()
	end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		Heavy()
	end

	if input.KeyCode == Enum.KeyCode.R then
		Parry()
	end

end)
