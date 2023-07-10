--// Use the game to test it ingame, there are animations and server part which exists there. thanks.

--// Defined instances, i will comment each one below.
local Player = game:GetService('Players').LocalPlayer --// The LocalPlayer
local UserInputService = game:GetService("UserInputService") -- The InputService, For detecting input.
local RunService = game:GetService("RunService") --// RunService for loops and other stuff
local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait() --// Character or if not character just wait for character.
local Humanoid = Character:WaitForChild("Humanoid") -- waiting for humanoid
local cam = workspace.CurrentCamera --// Get the current camera of the client
local hrp = Character:WaitForChild("HumanoidRootPart") -- RootPart of the character.

--// Bool Values, i recommend using CollectionService tags, but for the simplicity of the script, i will just use simple bools.
local doubleJumpEnabled = false 
local Sliding = false
local jumpCooldown = 3.0
local plr = Player
local Jumped = false --Debounce
local NormalCD = false
local HeavyCD = false
local ParryCD = false

--// Used for tilting mechanics, Locked Mouse -> can tilt sideways and stuff.
local RootJoint = Character.HumanoidRootPart.RootJoint
local Force = nil
local Direction = nil
local V1 = 0
local V2 = 0
local RootJointC0 = RootJoint.C0
local Remote = script:WaitForChild('RemoteEvent')
local LMBs = { --// This is for loading the animations for lmbs in a table, so we can use it easily
	LMB1 = "rbxassetid://12493839985";
	LMB2 = "rbxassetid://12493839985";
	LMB3 = "rbxassetid://12493839985";
};
--// Animations, make sure they exists
local Animations = { --// Doing it again, animations loading and table (you would want to know why 2 times, cause idk i just want it to be in different tables)
	["AirDash"] = script:WaitForChild('AirDash');
	["Roll"] = script:WaitForChild('Roll');
	["Slide"] = script:WaitForChild('Slide');
}
local anim = {}
local MaxLMBs = 3 --// Max LMBS
local HeavyAnim = Humanoid:LoadAnimation(script:WaitForChild('Heavy')) --// Animation
local ParryAnim = Humanoid:LoadAnimation(script:WaitForChild('Heavy')) --// animation
local LMBsAnim = {} --// The LMBs animations we loaded, will be in this table so LMBsAnim[AnimationName]:Play()
for i,v in pairs(LMBs) do --// Loading Process
	local anim = Instance.new('Animation') --// Create Animation
	anim.AnimationId = v
	local Load = Humanoid:LoadAnimation(anim) --// Load It on Animator or Humanoid
	LMBsAnim[i] = Load --// In the LMBs table.
end
for i,v in pairs(Animations) do -- same process, but this time we got the animations in Animations Table.
	if v then
		local load = Humanoid:LoadAnimation(v)
		anim[i] = load
	end
end
local function GetHitbox(Range) --// Just making a simple client Magnitude based hitbox.
	local tab = {}
	for i,v in pairs(workspace:GetChildren()) do
		if v:IsA('Model') and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 -- Checks
			and v ~= Character and v:FindFirstChild('HumanoidRootPart') and
			(v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude < Range --// range Check
		then
			table.insert(tab, v) -- Insert if in the local table we created above
		end
	end
	return tab -- Return the table
end
local Functions;
--// Functions
Functions = { -- Functions we will use in the input, for sorting and easy usage, specially if u r to use modules.
	["CreateCooldown"] = function(Name, Time) --// Create Cooldowns so we dont stack
		local ins = Instance.new('StringValue')
		ins.Name = Name
		ins.Parent = Character
		game.Debris:AddItem(ins, Time)
		return ins
	end,
	["CreateKey"] = function(Key) --// Create key for some stuff, key checks and all
		local ins = Instance.new('StringValue')
		ins.Name = Key
		ins.Parent = Character
	end;
	["Dash"] = function(Speed, Time) --// Dash using bodyvelocity, IK its deprecated, but its just veification.
		if Character:FindFirstChild("Dash") then return end --// Check for cooldown
		local bodyVel = Instance.new("BodyVelocity") -- Create Body Velocity
		bodyVel.Name = "Dash"
		game.Debris:AddItem(bodyVel, Time) --// time it says, the longer the more it will go far
		local direction = Character.Humanoid.MoveDirection * Vector3.new(2.3,0,2.3) -- Direction
		if direction == Vector3.new(0,0,0) then --// If no movement, then do below
			direction = Character.Head.CFrame.LookVector * Vector3.new(2.3,0,2.3)
		end
		anim.AirDash:Play() -- Play Animation
		local mousecf = game.Players.LocalPlayer:GetMouse().Hit -- Mouse Reference
		direction = Character.Humanoid.MoveDirection * Vector3.new(2.3,2.3,2.3)
		bodyVel.Parent = Character.PrimaryPart
		bodyVel.MaxForce = Vector3.new(25000,0,25000) --// Just bodyvelocity related properties
		local mass = 0
		for _,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and v.Massless == false then
				mass += v.Mass
			end
		end
		bodyVel.Velocity = direction * (mass * Speed) --// Push the velocity
		Functions.CreateCooldown("Dash", 1) --// Create Cooldown
	end,
	["Double Jump"] = function() --// Double jump, simple. it acts on the state checks and then just changes the state.
		if doubleJumpEnabled then
			if Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
				if Character:FindFirstChild("DoubleJump") then return end
				Functions.CreateCooldown("DoubleJump", 2.5)
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				doubleJumpEnabled = false
			end
		end
	end,
	["Slide"] = function() --// Slide, well same thing as DASH but this time we just slowly decrease the velocity until its practically none or the key is not found.
		-- Yes we will create cooldowns and everything the same way.
		if Character:FindFirstChild("Slide") then return end
		local EHMMM = 5
		local Power = 16
		Sliding = true
		local bodyVel = Instance.new("BodyVelocity")
		bodyVel.Name = "Sliding"
		local direction = Character.Humanoid.MoveDirection * Vector3.new(3,0,3)
		if direction == Vector3.new(0,0,0) then
			direction = Character.HumanoidRootPart.CFrame.LookVector * Vector3.new(3,0,3)
		end
		anim.Slide:Play()
		Character.HumanoidRootPart.CFrame = CFrame.new(Character.HumanoidRootPart.CFrame.p, Character.HumanoidRootPart.CFrame.p + direction)
		bodyVel.Parent = Character.HumanoidRootPart
		bodyVel.MaxForce = Vector3.new(25000,1000,25000)
		local mass = 0
		for _,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and v.Massless == false then
				mass += v.Mass
			end
		end
		bodyVel.Velocity = (direction + Vector3.new(0,2,0)) * (mass * 1.2)
		repeat task.wait(0.1) 
			EHMMM += 1 
			bodyVel.Velocity = (direction + Vector3.new(0,2,0)) * (mass * ((EHMMM/20)/(EHMMM/20))/((EHMMM/20)*((EHMMM/20)/2))/10) 
		until EHMMM == Power --or not character:FindFirstChild('C')
		game:GetService("Debris"):AddItem(bodyVel, 0.15) 
		Functions.CreateCooldown("Slide", 0.15)
		wait(0.1)
		Sliding = false	
	end,
}
local function Normal() --// Normal Mouse M1s
	if NormalCD then return end
	local Combo = Character:FindFirstChild('Combo')
	if Combo then --// If combo instance exists then destroy it and create a new one, with the value from previous +1, so we can use it for our next lmbs.
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
	if Combo.Value < MaxLMBs then --// Checks
		LMBsAnim["LMB"..Combo.Value]:Play() --// Animations
		wait(0.25) --// how fast
		local hit = GetHitbox(8) --// Hitbox
		Remote:FireServer("DoDamage", hit, 15) --// Do Damage, Handled on server
	elseif Combo.Value >= MaxLMBs then --// same as above, but here is the final hit
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
local function Heavy() --// Heavy Hit
	if HeavyCD then return end --// CD Checj
	HeavyCD = true
	HeavyAnim:Play() --// Animation
	wait(0.15)
	local hit = GetHitbox(8) --// Hitbox with range
	print('Heavy')
	Remote:FireServer("DoDamage", hit, 15) --// Dmaage
	wait(2.5)
	HeavyCD = false
end
local function Parry() --// Parry
	if HeavyCD then return end
	ParryCD = true
	print('Parry')
	Remote:FireServer("Parry") --// We just practically add a instance into the character, with some time. if in that time the user is hit, it return no damage and parries stuns the target character
	wait(2.5)
	ParryCD = false
end
local func = Functions
--// State Change
Humanoid.StateChanged:Connect(function(_oldState, newState) --// Simple STate Change Connection
	if newState == Enum.HumanoidStateType.Jumping then
		if Sliding then
			local Push = Character.HumanoidRootPart:FindFirstChild('Sliding') --// Check if sliding is happening
			if Push then -- if yes, then destroy it
				Push:Destroy()
				Sliding = false
			end
		end
		if not doubleJumpEnabled then --// Double Jump
			task.wait(0.2)
			if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then --// If he jumped and is falling, can double jump.
				doubleJumpEnabled = true
			end
		end
	end
end)
--// Jump Cooldown
UserInputService.JumpRequest:Connect(function() --// If Jump happend, add a cooldown to jump
	local char = plr.Character
	if not Jumped then
		if char.Humanoid.FloorMaterial == Enum.Material.Air then return end
		Jumped = true
		char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) 
		task.wait(jumpCooldown)
		Jumped = false
	else
		char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	end
end)
local crouching = false --// Crouching Bool, This was made in a hurry, so everything is in the place. I HOPE YOU CAN READ IT
local Crouch = Humanoid:LoadAnimation(script.Crouch) --// Animation Loading
local walkAnim = Humanoid:LoadAnimation(script.CrouchWalk) --// Animation Loading
UserInputService.InputBegan:Connect(function(inputObject, gc) --// Input connection, with the input object and gameprocessevent
	if gc then return end
	task.spawn(function() --// Create Key, Remember i explained above.
		if inputObject.KeyCode and inputObject.KeyCode ~= Enum.KeyCode.Unknown then
			local a = inputObject.KeyCode
			local key = tostring(a):split(".")
			func.CreateKey(tostring(key[3]))
		end
	end)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then --// If its mouse1 then do lmbs
		Normal()
	end
	if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then --// If its mouse2 then do Heavy
		Heavy()
	end

	if inputObject.KeyCode == Enum.KeyCode.R then --// If its R key then Parry
		Parry()
	end
	if inputObject.KeyCode == Enum.KeyCode.Space then --// If its Space -> Jump, but if its in air, do double jump.
		func["Double Jump"]()
	end
	if inputObject.KeyCode == Enum.KeyCode.Q then --// If its Q then dash with the Distance Covered and Amount of time.
		func.Dash(4.5, 0.25)
	end
	if inputObject.KeyCode == Enum.KeyCode.T then --// if its T then slide
		func.Slide()
	end
	if inputObject.KeyCode == Enum.KeyCode.C then --// If its C then crouch, but if crouching then uncrouch, change the speed/jump related to either event.
		if crouching == false then
			Crouch:Play()
			Humanoid.WalkSpeed = 7
			Humanoid.JumpHeight = 0
			Humanoid.JumpPower = 0
			crouching = true
		else
			walkAnim:Stop()
			Crouch:Stop()
			crouching = false
			Humanoid.WalkSpeed = 17
			Humanoid.JumpHeight = 50
			Humanoid.JumpPower = 50
		end
	end
end)
UserInputService.InputEnded:Connect(function(inputObject, gc) --// USed for removing the key from character, if input ends.
	if gc then return end
	task.spawn(function()
		local a = inputObject.KeyCode
		local key = tostring(a):split(".")
		if Character:FindFirstChild(tostring(key[3])) then
			Character:FindFirstChild(tostring(key[3])):Destroy()
		end
	end)
end)
RunService.RenderStepped:Connect(function() --// Loop for Tilting, Explained Above.
	Force = hrp.Velocity * Vector3.new(1,0,1)
	if Force.Magnitude > 2 then
		Direction = Force.Unit
		V1 = hrp.CFrame.RightVector:Dot(Direction)
		V2 = hrp.CFrame.LookVector:Dot(Direction)
	else
		V1 = 0
		V2 = 0
	end
	RootJoint.C0 = RootJoint.C0:Lerp(RootJointC0 * CFrame.Angles(math.rad(-V2 * 30), math.rad(-V1 * 30), 0), 0.2)
end)

--// This script wont wwork individually, it needs tons of instances, test ingame \\--
